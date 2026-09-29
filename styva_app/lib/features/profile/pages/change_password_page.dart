import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../providers/profile_provider.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _current = TextEditingController();
  final _new = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _current.dispose();
    _new.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(changePasswordProvider.notifier).change(
          currentPassword: _current.text,
          newPassword: _new.text,
          confirmNewPassword: _confirm.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<SubmitState>(changePasswordProvider, (previous, next) {
      if (next is SubmitSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password changed. Other devices have been signed out.')),
        );
        context.pop();
      }
    });

    final submitState = ref.watch(changePasswordProvider);
    final isSaving = submitState is SubmitLoading || submitState is SubmitSuccess;

    String? required(String? value, String label) =>
        (value == null || value.isEmpty) ? '$label is required' : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Change Password')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              key: const Key('password_current'),
              controller: _current,
              enabled: !isSaving,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Current password'),
              validator: (v) => required(v, 'Current password'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const Key('password_new'),
              controller: _new,
              enabled: !isSaving,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New password',
                helperText: 'At least 8 characters, not too common or all numbers.',
              ),
              validator: (v) {
                final missing = required(v, 'New password');
                if (missing != null) return missing;
                if (v!.length < 8) return 'Use at least 8 characters';
                if (v == _current.text) return 'Choose a different password from your current one';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const Key('password_confirm'),
              controller: _confirm,
              enabled: !isSaving,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirm new password'),
              validator: (v) {
                final missing = required(v, 'Confirmation');
                if (missing != null) return missing;
                if (v != _new.text) return 'Passwords do not match';
                return null;
              },
            ),
            if (submitState case SubmitError(:final message)) ...[
              const SizedBox(height: 16),
              Text(message, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ],
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            key: const Key('password_submit'),
            onPressed: isSaving ? null : _submit,
            child: isSaving
                ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Change Password'),
          ),
        ),
      ),
    );
  }
}
