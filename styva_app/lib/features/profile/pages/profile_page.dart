import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../providers/auth_provider.dart';

/// The Account screen: who is signed in, then entry points for editing the
/// profile, orders, saved addresses, password and signing out.
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final textTheme = Theme.of(context).textTheme;
    final hasPhone = user?.phone.isNotEmpty ?? false;

    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.page, AppSpacing.xl, AppSpacing.page, AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(header: true, child: Text(user?.fullName ?? '', style: textTheme.headlineMedium)),
                const SizedBox(height: AppSpacing.md),
                _ContactLine(icon: Icons.mail_outline, semanticLabel: 'Email', value: user?.email ?? ''),
                const SizedBox(height: AppSpacing.xs),
                _ContactLine(
                  icon: Icons.phone_outlined,
                  semanticLabel: 'Phone',
                  value: hasPhone ? user!.phone : 'Not set',
                  muted: !hasPhone,
                ),
              ],
            ),
          ),
          const Divider(),
          _NavTile(
            icon: Icons.edit_outlined,
            label: 'Edit Profile',
            onTap: () => context.push(AppRoutes.editProfile),
          ),
          _NavTile(
            icon: Icons.receipt_long_outlined,
            label: 'My Orders',
            onTap: () => context.push(AppRoutes.orders),
          ),
          _NavTile(
            icon: Icons.location_on_outlined,
            label: 'Saved Addresses',
            onTap: () => context.push(AppRoutes.addresses),
          ),
          _NavTile(
            icon: Icons.lock_outline,
            label: 'Change Password',
            onTap: () => context.push(AppRoutes.changePassword),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: Text('Log out', style: textTheme.bodyLarge?.copyWith(color: AppColors.error)),
            onTap: () => ref.read(authProvider.notifier).logout(),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

/// An icon and one line of contact detail under the user's name.
class _ContactLine extends StatelessWidget {
  const _ContactLine({required this.icon, required this.semanticLabel, required this.value, this.muted = false});

  final IconData icon;
  final String semanticLabel;
  final String value;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium;
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary, semanticLabel: semanticLabel),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: Text(value, style: muted ? style?.copyWith(color: AppColors.textSecondary) : style)),
      ],
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
