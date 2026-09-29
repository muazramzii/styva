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
