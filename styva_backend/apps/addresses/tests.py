import threading

from django.contrib.auth import get_user_model
from django.db import IntegrityError, connection, transaction
from django.test import TransactionTestCase
from rest_framework import status
from rest_framework.test import APIClient, APITestCase

from .models import Address

User = get_user_model()

LIST_URL = '/api/addresses'


def detail_url(address_id):
    return f'/api/addresses/{address_id}'


def address_payload(**overrides):
    payload = {
        'recipient_name': 'Test Buyer',
        'phone': '0123456789',
        'address_line_1': '123 Jalan ABC',
        'address_line_2': 'Taman Ujian',
        'city': 'Skudai',
        'state': 'Johor',
        'postcode': '81300',
    }
    payload.update(overrides)
    return payload


def make_user(email):
    return User.objects.create_user(email=email, password='StrongPass123!', full_name='User')


def make_address(user, **overrides):
    fields = address_payload(**overrides)
    fields.setdefault('is_default', False)
    return Address.objects.create(user=user, **fields)


class AddressTestCase(APITestCase):
    def setUp(self):
        self.user = make_user('owner@example.com')
        self.client.force_authenticate(user=self.user)

    def create(self, **overrides):
        return self.client.post(LIST_URL, address_payload(**overrides), format='json')

    def defaults(self, user=None):
        return list(Address.objects.filter(user=user or self.user, is_default=True).values_list('id', flat=True))


class AddressCrudTests(AddressTestCase):
    def test_create_address(self):
        response = self.create()

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        address = Address.objects.get(id=response.data['id'])
        self.assertEqual(address.user, self.user)
        self.assertEqual(address.address_line_1, '123 Jalan ABC')
        self.assertEqual(address.country, 'Malaysia')
        self.assertEqual(set(response.data), {
            'id', 'recipient_name', 'phone', 'address_line_1', 'address_line_2', 'city',
            'state', 'postcode', 'country', 'is_default', 'created_at', 'updated_at',
        })

    def test_address_line_2_is_optional(self):
        payload = address_payload()
        del payload['address_line_2']

        response = self.client.post(LIST_URL, payload, format='json')

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(response.data['address_line_2'], '')

    def test_owner_in_body_is_ignored(self):
        other = make_user('other@example.com')

        response = self.create(user=other.id)

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(Address.objects.get(id=response.data['id']).user, self.user)
        self.assertFalse(Address.objects.filter(user=other).exists())

    def test_list_returns_only_own_addresses_default_first(self):
        older = make_address(self.user, address_line_1='Older', is_default=True)
        newer = make_address(self.user, address_line_1='Newer')
        make_address(make_user('other@example.com'), address_line_1='Not mine')

        response = self.client.get(LIST_URL)

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual([a['id'] for a in response.data], [older.id, newer.id])

    def test_retrieve_own_address(self):
        address = make_address(self.user)

        response = self.client.get(detail_url(address.id))

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['id'], address.id)

    def test_update_own_address(self):
        address = make_address(self.user, is_default=True)

        response = self.client.patch(
            detail_url(address.id), {'address_line_1': '456 Jalan XYZ', 'city': 'Johor Bahru'}, format='json',
        )

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        address.refresh_from_db()
        self.assertEqual(address.address_line_1, '456 Jalan XYZ')
        self.assertEqual(address.city, 'Johor Bahru')
        self.assertEqual(address.postcode, '81300')

    def test_put_is_not_allowed(self):
        address = make_address(self.user)
        response = self.client.put(detail_url(address.id), address_payload(), format='json')
        self.assertEqual(response.status_code, status.HTTP_405_METHOD_NOT_ALLOWED)

    def test_delete_own_address(self):
        address = make_address(self.user)

        response = self.client.delete(detail_url(address.id))

        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
        self.assertFalse(Address.objects.filter(id=address.id).exists())

    def test_missing_address_returns_404(self):
        self.assertEqual(self.client.get(detail_url(999999)).status_code, status.HTTP_404_NOT_FOUND)


class AddressValidationTests(AddressTestCase):
    def test_required_fields(self):
        response = self.client.post(LIST_URL, {}, format='json')

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertEqual(
            set(response.data),
            {'recipient_name', 'phone', 'address_line_1', 'city', 'state', 'postcode'},
        )

    def test_invalid_values_are_rejected(self):
        cases = {
            'blank name': {'recipient_name': '   '},
            'bad phone': {'phone': 'not-a-phone'},
            'short postcode': {'postcode': '8130'},
            'long postcode': {'postcode': '813000'},
            'letters in postcode': {'postcode': '81A00'},
            'unknown state': {'state': 'Atlantis'},
            'non-Malaysian country': {'country': 'Singapore'},
            'blank city': {'city': ''},
        }
        for label, override in cases.items():
            with self.subTest(label):
                response = self.create(**override)
                self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
                self.assertIn(next(iter(override)), response.data)
        self.assertFalse(Address.objects.exists())

    def test_all_malaysian_states_and_federal_territories_accepted(self):
        states = [
            'Johor', 'Kedah', 'Kelantan', 'Melaka', 'Negeri Sembilan', 'Pahang', 'Perak', 'Perlis',
            'Pulau Pinang', 'Sabah', 'Sarawak', 'Selangor', 'Terengganu',
            'Kuala Lumpur', 'Labuan', 'Putrajaya',
        ]
        for state in states:
            with self.subTest(state=state):
                self.assertEqual(self.create(state=state).status_code, status.HTTP_201_CREATED)

    def test_postcodes_with_leading_zero_are_kept(self):
        response = self.create(postcode='01000', state='Perlis', city='Kangar')

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(response.data['postcode'], '01000')

    def test_values_are_trimmed(self):
        response = self.create(recipient_name='  Test Buyer  ', postcode=' 81300 ')

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(response.data['recipient_name'], 'Test Buyer')
        self.assertEqual(response.data['postcode'], '81300')

    def test_invalid_update_is_rejected_and_nothing_changes(self):
        address = make_address(self.user)

        response = self.client.patch(detail_url(address.id), {'postcode': 'abcde'}, format='json')

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        address.refresh_from_db()
        self.assertEqual(address.postcode, '81300')


class AddressOwnershipTests(AddressTestCase):
    """User A must never reach User B's address by changing the id."""

    def setUp(self):
        super().setUp()
        self.other = make_user('other@example.com')
        self.others_address = make_address(self.other, address_line_1='B private', is_default=True)

    def test_cannot_view_another_users_address(self):
        response = self.client.get(detail_url(self.others_address.id))

        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)
        self.assertNotIn('B private', response.content.decode())

    def test_cannot_modify_another_users_address(self):
        response = self.client.patch(
            detail_url(self.others_address.id), {'address_line_1': 'Hijacked', 'is_default': False},
            format='json',
        )

        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)
        self.others_address.refresh_from_db()
        self.assertEqual(self.others_address.address_line_1, 'B private')
        self.assertTrue(self.others_address.is_default)

    def test_cannot_delete_another_users_address(self):
        response = self.client.delete(detail_url(self.others_address.id))

        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)
        self.assertTrue(Address.objects.filter(id=self.others_address.id).exists())

    def test_setting_own_default_does_not_touch_another_users_default(self):
        response = self.create(is_default=True)
        mine = response.data['id']
        make_address(self.user, is_default=False)

        self.client.patch(detail_url(mine), {'is_default': True}, format='json')

        self.others_address.refresh_from_db()
        self.assertTrue(self.others_address.is_default)

    def test_unauthenticated_requests_are_rejected(self):
        self.client.force_authenticate(user=None)
        requests = [
            self.client.get(LIST_URL),
            self.client.post(LIST_URL, address_payload(), format='json'),
            self.client.get(detail_url(self.others_address.id)),
            self.client.patch(detail_url(self.others_address.id), {'city': 'X'}, format='json'),
            self.client.delete(detail_url(self.others_address.id)),
        ]
        for response in requests:
            self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)
        self.assertEqual(Address.objects.count(), 1)


class DefaultAddressTests(AddressTestCase):
    def test_first_address_becomes_default_even_if_client_says_no(self):
        response = self.create(is_default=False)

        self.assertTrue(response.data['is_default'])
        self.assertEqual(self.defaults(), [response.data['id']])

    def test_second_address_is_not_default_unless_requested(self):
        first = self.create().data['id']
        second = self.create()

        self.assertFalse(second.data['is_default'])
        self.assertEqual(self.defaults(), [first])

    def test_new_default_on_create_replaces_previous(self):
        self.create()
        second = self.create(is_default=True).data['id']

        self.assertEqual(self.defaults(), [second])

    def test_setting_default_on_update_replaces_previous(self):
        first = self.create().data['id']
        second = self.create().data['id']

        response = self.client.patch(detail_url(second), {'is_default': True}, format='json')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(response.data['is_default'])
        self.assertEqual(self.defaults(), [second])
        self.assertFalse(Address.objects.get(id=first).is_default)

    def test_current_default_cannot_be_switched_off_directly(self):
        first = self.create().data['id']
        self.create()

        response = self.client.patch(detail_url(first), {'is_default': False}, format='json')

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('is_default', response.data)
        self.assertEqual(self.defaults(), [first])

    def test_re_marking_the_default_as_default_is_a_no_op(self):
        first = self.create().data['id']

        response = self.client.patch(detail_url(first), {'is_default': True}, format='json')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(self.defaults(), [first])

    def test_non_default_can_be_marked_not_default(self):
        self.create()
        second = self.create().data['id']

        response = self.client.patch(detail_url(second), {'is_default': False}, format='json')

        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_editing_other_fields_keeps_default_flag(self):
        first = self.create().data['id']

        self.client.patch(detail_url(first), {'city': 'Batu Pahat'}, format='json')

        self.assertEqual(self.defaults(), [first])

    def test_deleting_default_promotes_most_recent_remaining_address(self):
        first = self.create().data['id']
        second = self.create().data['id']
        third = self.create().data['id']

        self.client.delete(detail_url(first))

        self.assertEqual(self.defaults(), [third])
        self.assertTrue(Address.objects.filter(id=second).exists())

    def test_deleting_non_default_keeps_default(self):
        first = self.create().data['id']
        second = self.create().data['id']

        self.client.delete(detail_url(second))

        self.assertEqual(self.defaults(), [first])

    def test_deleting_last_address_leaves_no_addresses(self):
        only = self.create().data['id']

        self.client.delete(detail_url(only))

        self.assertFalse(Address.objects.filter(user=self.user).exists())
        self.assertTrue(self.create().data['is_default'])

    def test_exactly_one_default_after_many_changes(self):
        ids = [self.create().data['id'] for _ in range(4)]
        for address_id in (ids[2], ids[1], ids[3], ids[1]):
            self.client.patch(detail_url(address_id), {'is_default': True}, format='json')
        self.client.delete(detail_url(ids[1]))
        self.create(is_default=True)
        self.client.patch(detail_url(ids[0]), {'is_default': True, 'city': 'Muar'}, format='json')

        self.assertEqual(self.defaults(), [ids[0]])

    def test_database_rejects_a_second_default(self):
        make_address(self.user, is_default=True)

        with self.assertRaises(IntegrityError), transaction.atomic():
            make_address(self.user, is_default=True)


class ConcurrentDefaultAddressTests(TransactionTestCase):
    """Real concurrent requests on separate connections: the user-row lock
    must keep 'exactly one default' true even when requests race."""

    def run_concurrently(self, action, count=4):
        barrier = threading.Barrier(count)
        results = []

        def attempt(index):
            try:
                barrier.wait()
                results.append(action(index))
            finally:
                connection.close()

        threads = [threading.Thread(target=attempt, args=(i,)) for i in range(count)]
        for thread in threads:
            thread.start()
        for thread in threads:
            thread.join()
        return results

    def client_for(self, user):
        client = APIClient()
        client.force_authenticate(user=user)
        return client

    def test_concurrent_first_addresses_produce_one_default(self):
        user = make_user('racer@example.com')

        responses = self.run_concurrently(
            lambda i: self.client_for(user).post(LIST_URL, address_payload(city=f'City {i}'), format='json'),
        )

        self.assertEqual([r.status_code for r in responses], [201] * 4)
        self.assertEqual(Address.objects.filter(user=user).count(), 4)
        self.assertEqual(Address.objects.filter(user=user, is_default=True).count(), 1)

    def test_concurrent_set_default_produces_one_default(self):
        user = make_user('racer@example.com')
        addresses = [make_address(user, is_default=(i == 0)) for i in range(4)]

        responses = self.run_concurrently(
            lambda i: self.client_for(user).patch(
                detail_url(addresses[i].id), {'is_default': True}, format='json',
            ),
        )

        self.assertEqual([r.status_code for r in responses], [200] * 4)
        self.assertEqual(Address.objects.filter(user=user, is_default=True).count(), 1)
