import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../providers/auth_provider.dart';

/// The Account screen: profile summary plus entry points for editing the
/// profile, orders, password, saved addresses and signing out.
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: ListView(
        children: [
          const _SectionHeader('Profile'),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Name'),
            subtitle: Text(user?.fullName ?? ''),
          ),
          ListTile(
            leading: const Icon(Icons.mail_outline),
            title: const Text('Email'),
            subtitle: Text(user?.email ?? ''),
          ),
          ListTile(
            leading: const Icon(Icons.phone_outlined),
            title: const Text('Phone'),
            subtitle: Text(
              (user?.phone.isNotEmpty ?? false) ? user!.phone : 'Not set',
              style: (user?.phone.isNotEmpty ?? false) ? null : TextStyle(color: colors.outline),
            ),
          ),
          _NavTile(
            icon: Icons.edit_outlined,
            label: 'Edit Profile',
            onTap: () => context.push(AppRoutes.editProfile),
          ),
          const Divider(height: 32),
          const _SectionHeader('Orders'),
          _NavTile(
            icon: Icons.receipt_long_outlined,
            label: 'My Orders',
            onTap: () => context.push(AppRoutes.orders),
          ),
          const Divider(height: 32),
          const _SectionHeader('Addresses'),
          _NavTile(
            icon: Icons.location_on_outlined,
            label: 'Saved Addresses',
            onTap: () => context.push(AppRoutes.addresses),
          ),
          const Divider(height: 32),
          const _SectionHeader('Security'),
          _NavTile(
            icon: Icons.lock_outline,
            label: 'Change Password',
            onTap: () => context.push(AppRoutes.changePassword),
          ),
          const Divider(height: 32),
          const _SectionHeader('Session'),
          ListTile(
            leading: Icon(Icons.logout, color: colors.error),
            title: Text('Log out', style: TextStyle(color: colors.error)),
            onTap: () => ref.read(authProvider.notifier).logout(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              letterSpacing: 1.2,
              color: Theme.of(context).colorScheme.outline,
            ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
