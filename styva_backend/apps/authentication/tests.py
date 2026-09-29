from django.contrib.auth import get_user_model
from rest_framework import status
from rest_framework.test import APITestCase

User = get_user_model()


class RegisterTestCase(APITestCase):
    def test_register_success(self):
        response = self.client.post('/api/auth/register', {
            'full_name': 'Jane Doe',
            'email': 'jane@example.com',
            'password': 'StrongPass123!',
        })

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertIn('access', response.data)
        self.assertIn('refresh', response.data)
        self.assertEqual(response.data['user']['email'], 'jane@example.com')
        self.assertTrue(User.objects.filter(email='jane@example.com').exists())

    def test_register_hashes_password(self):
        self.client.post('/api/auth/register', {
            'full_name': 'Jane Doe',
            'email': 'jane2@example.com',
            'password': 'StrongPass123!',
        })
        user = User.objects.get(email='jane2@example.com')
        self.assertNotEqual(user.password, 'StrongPass123!')
        self.assertTrue(user.check_password('StrongPass123!'))

    def test_duplicate_email_is_rejected(self):
        User.objects.create_user(email='dupe@example.com', password='pass12345', full_name='Existing')

        response = self.client.post('/api/auth/register', {
            'full_name': 'New Person',
            'email': 'dupe@example.com',
            'password': 'StrongPass123!',
        })

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('email', response.data)

    def test_duplicate_email_is_rejected_case_insensitively(self):
        User.objects.create_user(email='dupe@example.com', password='pass12345', full_name='Existing')

        response = self.client.post('/api/auth/register', {
            'full_name': 'New Person',
            'email': 'DUPE@example.com',
            'password': 'StrongPass123!',
        })

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_validation_errors_are_returned_cleanly(self):
        response = self.client.post('/api/auth/register', {
            'full_name': '',
            'email': 'not-an-email',
            'password': '123',
        })

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('email', response.data)
        self.assertIn('password', response.data)

    def test_register_missing_required_field_is_rejected(self):
        response = self.client.post('/api/auth/register', {
            'full_name': 'Jane Doe',
            'password': 'StrongPass123!',
        })

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('email', response.data)
        self.assertFalse(User.objects.filter(full_name='Jane Doe').exists())

    def test_register_invalid_email_format_is_rejected(self):
        response = self.client.post('/api/auth/register', {
            'full_name': 'Jane Doe',
            'email': 'not-an-email',
            'password': 'StrongPass123!',
        })

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('email', response.data)


class LoginTestCase(APITestCase):
    def setUp(self):
        self.user = User.objects.create_user(
            email='login@example.com', password='CorrectPass123!', full_name='Login User',
        )

    def test_login_success_returns_tokens_and_user(self):
        response = self.client.post('/api/auth/login', {
            'email': 'login@example.com',
            'password': 'CorrectPass123!',
        })

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('access', response.data)
        self.assertIn('refresh', response.data)
        self.assertEqual(response.data['user']['email'], 'login@example.com')

    def test_login_is_case_insensitive_on_email(self):
        response = self.client.post('/api/auth/login', {
            'email': 'LOGIN@example.com',
            'password': 'CorrectPass123!',
        })
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_login_with_invalid_password_is_rejected(self):
        response = self.client.post('/api/auth/login', {
            'email': 'login@example.com',
            'password': 'WrongPassword',
        })

        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)
        self.assertNotIn('access', response.data)

    def test_login_with_unknown_email_is_rejected(self):
        response = self.client.post('/api/auth/login', {
            'email': 'nobody@example.com',
            'password': 'WhateverPass123!',
        })

        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)
        self.assertNotIn('access', response.data)

    def test_login_error_does_not_reveal_whether_the_email_exists(self):
        unknown_email_response = self.client.post('/api/auth/login', {
            'email': 'nobody@example.com',
            'password': 'WhateverPass123!',
        })
        wrong_password_response = self.client.post('/api/auth/login', {
            'email': 'login@example.com',
            'password': 'WrongPassword',
        })

        self.assertEqual(unknown_email_response.status_code, status.HTTP_401_UNAUTHORIZED)
        self.assertEqual(wrong_password_response.status_code, status.HTTP_401_UNAUTHORIZED)
        self.assertEqual(unknown_email_response.data, wrong_password_response.data)

    def test_login_response_does_not_expose_password(self):
        response = self.client.post('/api/auth/login', {
            'email': 'login@example.com',
            'password': 'CorrectPass123!',
        })

        self.assertNotIn('password', response.data['user'])
        self.assertNotIn('password', str(response.data))


class MeTestCase(APITestCase):
    def setUp(self):
        self.user = User.objects.create_user(
            email='me@example.com', password='CorrectPass123!', full_name='Me User',
        )

    def _login(self):
        response = self.client.post('/api/auth/login', {
            'email': 'me@example.com',
            'password': 'CorrectPass123!',
        })
        return response.data['access'], response.data['refresh']

    def test_me_requires_authentication(self):
        response = self.client.get('/api/auth/me')
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_me_returns_current_user(self):
        access, _ = self._login()
        response = self.client.get('/api/auth/me', HTTP_AUTHORIZATION=f'Bearer {access}')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['email'], 'me@example.com')
        self.assertEqual(response.data['full_name'], 'Me User')
        self.assertIn('created_at', response.data)
        self.assertIn('id', response.data)


class RefreshTestCase(APITestCase):
    def setUp(self):
        self.user = User.objects.create_user(
            email='refresh@example.com', password='CorrectPass123!', full_name='Refresh User',
        )

    def _login(self):
        response = self.client.post('/api/auth/login', {
            'email': 'refresh@example.com',
            'password': 'CorrectPass123!',
        })
        return response.data['access'], response.data['refresh']

    def test_valid_refresh_token_returns_a_new_access_token(self):
        _, refresh = self._login()

        response = self.client.post('/api/auth/refresh', {'refresh': refresh})

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('access', response.data)

    def test_invalid_refresh_token_is_rejected(self):
        response = self.client.post('/api/auth/refresh', {'refresh': 'not-a-real-token'})

        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)
        self.assertNotIn('access', response.data)


class LogoutTestCase(APITestCase):
    def setUp(self):
        self.user = User.objects.create_user(
            email='logout@example.com', password='CorrectPass123!', full_name='Logout User',
        )

    def _login(self):
        response = self.client.post('/api/auth/login', {
            'email': 'logout@example.com',
            'password': 'CorrectPass123!',
        })
        return response.data['access'], response.data['refresh']

    def test_logout_blacklists_refresh_token(self):
        access, refresh = self._login()

        response = self.client.post(
            '/api/auth/logout', {'refresh': refresh}, HTTP_AUTHORIZATION=f'Bearer {access}',
        )
        self.assertEqual(response.status_code, status.HTTP_205_RESET_CONTENT)

        refresh_response = self.client.post('/api/auth/refresh', {'refresh': refresh})
        self.assertEqual(refresh_response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_logout_requires_authentication(self):
        response = self.client.post('/api/auth/logout', {'refresh': 'whatever'})
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_logout_without_refresh_token_is_a_clean_400(self):
        access, _ = self._login()
        response = self.client.post('/api/auth/logout', {}, HTTP_AUTHORIZATION=f'Bearer {access}')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_logout_does_not_delete_the_user(self):
        access, refresh = self._login()

        self.client.post('/api/auth/logout', {'refresh': refresh}, HTTP_AUTHORIZATION=f'Bearer {access}')

        self.assertTrue(User.objects.filter(email='logout@example.com').exists())

    def test_blacklisted_refresh_token_cannot_be_reused_for_logout(self):
        access, refresh = self._login()

        first = self.client.post(
            '/api/auth/logout', {'refresh': refresh}, HTTP_AUTHORIZATION=f'Bearer {access}',
        )
        self.assertEqual(first.status_code, status.HTTP_205_RESET_CONTENT)

        second = self.client.post(
            '/api/auth/logout', {'refresh': refresh}, HTTP_AUTHORIZATION=f'Bearer {access}',
        )
        self.assertEqual(second.status_code, status.HTTP_400_BAD_REQUEST)


class ProfileTestCase(APITestCase):
    def setUp(self):
        self.user = User.objects.create_user(
            email='profile@example.com', password='StrongPass123!', full_name='Profile User',
        )
        self.client.force_authenticate(user=self.user)

    def test_view_profile_includes_phone_and_never_the_password(self):
        self.user.phone = '0123456789'
        self.user.save()

        response = self.client.get('/api/auth/me')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(set(response.data), {'id', 'full_name', 'email', 'phone', 'created_at'})
        self.assertEqual(response.data['phone'], '0123456789')

    def test_update_name_and_phone(self):
        response = self.client.patch(
            '/api/auth/me', {'full_name': '  New Name  ', 'phone': '+60 12-345 6789'}, format='json',
        )

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['full_name'], 'New Name')
        self.assertEqual(response.data['phone'], '+60 12-345 6789')
        self.user.refresh_from_db()
        self.assertEqual(self.user.full_name, 'New Name')

    def test_phone_can_be_cleared(self):
        self.user.phone = '0123456789'
        self.user.save()

        response = self.client.patch('/api/auth/me', {'phone': ''}, format='json')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.user.refresh_from_db()
        self.assertEqual(self.user.phone, '')

    def test_invalid_profile_data_is_rejected(self):
        for payload in ({'full_name': ''}, {'full_name': '   '}, {'phone': 'call me'}, {'phone': '12'},
                        {'full_name': 'x' * 256}):
            with self.subTest(payload=payload):
                response = self.client.patch('/api/auth/me', payload, format='json')
                self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.user.refresh_from_db()
        self.assertEqual(self.user.full_name, 'Profile User')

    def test_email_and_privileged_fields_cannot_be_changed(self):
        response = self.client.patch('/api/auth/me', {
            'email': 'hijack@example.com', 'is_staff': True, 'is_superuser': True,
            'password': 'Whatever123!', 'full_name': 'Still Me',
        }, format='json')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.user.refresh_from_db()
        self.assertEqual(self.user.email, 'profile@example.com')
        self.assertFalse(self.user.is_staff)
        self.assertFalse(self.user.is_superuser)
        self.assertTrue(self.user.check_password('StrongPass123!'))
        self.assertEqual(self.user.full_name, 'Still Me')

    def test_put_is_not_allowed(self):
        response = self.client.put('/api/auth/me', {'full_name': 'X'}, format='json')
        self.assertEqual(response.status_code, status.HTTP_405_METHOD_NOT_ALLOWED)

    def test_unauthenticated_access_is_rejected(self):
        self.client.force_authenticate(user=None)
        self.assertEqual(self.client.get('/api/auth/me').status_code, status.HTTP_401_UNAUTHORIZED)
        self.assertEqual(
            self.client.patch('/api/auth/me', {'full_name': 'X'}, format='json').status_code,
            status.HTTP_401_UNAUTHORIZED,
        )


class ChangePasswordTestCase(APITestCase):
    URL = '/api/auth/change-password'
    OLD = 'StrongPass123!'
    NEW = 'BrandNewPass456!'

    def setUp(self):
        self.user = User.objects.create_user(
            email='secure@example.com', password=self.OLD, full_name='Secure User',
        )

    def login(self, password=OLD):
        return self.client.post('/api/auth/login', {'email': 'secure@example.com', 'password': password})

    def change(self, current=OLD, new=NEW, confirm=None, token=None):
        if token:
            self.client.credentials(HTTP_AUTHORIZATION=f'Bearer {token}')
        return self.client.post(self.URL, {
            'current_password': current,
            'new_password': new,
            'confirm_new_password': new if confirm is None else confirm,
        }, format='json')

    def test_correct_current_password_changes_password(self):
        response = self.change(token=self.login().data['access'])

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.user.refresh_from_db()
        self.assertTrue(self.user.check_password(self.NEW))
        self.assertFalse(self.user.check_password(self.OLD))

    def test_new_password_is_stored_hashed(self):
        self.change(token=self.login().data['access'])

        self.user.refresh_from_db()
        self.assertTrue(self.user.password.startswith('pbkdf2_sha256$'))
        self.assertNotIn(self.NEW, self.user.password)

    def test_response_contains_new_tokens_and_no_password(self):
        response = self.change(token=self.login().data['access'])

        self.assertEqual(set(response.data), {'access', 'refresh'})
        self.assertNotIn(self.NEW, response.content.decode())
        self.assertNotIn(self.OLD, response.content.decode())

    def test_new_password_works_for_login_and_old_one_does_not(self):
        self.change(token=self.login().data['access'])
        self.client.credentials()

        self.assertEqual(self.login(self.OLD).status_code, status.HTTP_401_UNAUTHORIZED)
        self.assertEqual(self.login(self.NEW).status_code, status.HTTP_200_OK)

    def test_incorrect_current_password_is_rejected(self):
        response = self.change(current='WrongPass999!', token=self.login().data['access'])

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('current_password', response.data)
        self.user.refresh_from_db()
        self.assertTrue(self.user.check_password(self.OLD))

    def test_invalid_new_passwords_are_rejected(self):
        token = self.login().data['access']
        cases = {
            'too short': 'Ab1!',
            'common': 'password123',
            'all numeric': '1234567890123',
            'similar to email': 'secure@example.com',
            'same as current': self.OLD,
        }
        for label, new in cases.items():
            with self.subTest(label):
                response = self.change(new=new, token=token)
                self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
                self.assertIn('new_password', response.data)
        self.user.refresh_from_db()
        self.assertTrue(self.user.check_password(self.OLD))

    def test_mismatched_confirmation_is_rejected(self):
        response = self.change(confirm='SomethingElse789!', token=self.login().data['access'])

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('confirm_new_password', response.data)

    def test_missing_fields_are_rejected(self):
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {self.login().data['access']}")
        response = self.client.post(self.URL, {}, format='json')

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertEqual(set(response.data), {'current_password', 'new_password', 'confirm_new_password'})

    def test_requires_authentication(self):
        self.assertEqual(self.change().status_code, status.HTTP_401_UNAUTHORIZED)

    def test_other_sessions_can_no_longer_refresh(self):
        other_device = self.login().data
        this_device = self.login().data

        response = self.change(token=this_device['access'])
        self.client.credentials()

        for old_refresh in (other_device['refresh'], this_device['refresh']):
            refreshed = self.client.post('/api/auth/refresh', {'refresh': old_refresh})
            self.assertEqual(refreshed.status_code, status.HTTP_401_UNAUTHORIZED)
        # The fresh pair returned to the caller keeps working.
        refreshed = self.client.post('/api/auth/refresh', {'refresh': response.data['refresh']})
        self.assertEqual(refreshed.status_code, status.HTTP_200_OK)

    def test_rotated_refresh_tokens_are_also_revoked(self):
        session = self.login().data
        rotated = self.client.post('/api/auth/refresh', {'refresh': session['refresh']}).data

        self.change(token=rotated['access'])
        self.client.credentials()

        refreshed = self.client.post('/api/auth/refresh', {'refresh': rotated['refresh']})
        self.assertEqual(refreshed.status_code, status.HTTP_401_UNAUTHORIZED)
