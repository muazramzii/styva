import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/malaysia.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/profile_provider.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _phone;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider);
    _name = TextEditingController(text: user?.fullName ?? '');
    _phone = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(editProfileProvider.notifier).save(
          fullName: _name.text.trim(),
          phone: _phone.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<SubmitState>(editProfileProvider, (previous, next) {
      if (next is SubmitSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated')));
        context.pop();
      }
    });

    final submitState = ref.watch(editProfileProvider);
    final isSaving = submitState is SubmitLoading || submitState is SubmitSuccess;
    final email = ref.watch(currentUserProvider)?.email ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              key: const Key('profile_name'),
              controller: _name,
              enabled: !isSaving,
              decoration: const InputDecoration(labelText: 'Full name'),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.isEmpty) return 'Full name is required';
                if (text.length > 255) return 'Full name is too long';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const Key('profile_phone'),
              controller: _phone,
              enabled: !isSaving,
              decoration: const InputDecoration(labelText: 'Phone (optional)', hintText: '012-345 6789'),
              keyboardType: TextInputType.phone,
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.isNotEmpty && !phonePattern.hasMatch(text)) return 'Enter a valid phone number';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: email,
              enabled: false,
              decoration: const InputDecoration(
                labelText: 'Email',
                helperText: 'Your email is your login and can’t be changed here.',
              ),
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
            key: const Key('profile_save'),
            onPressed: isSaving ? null : _save,
            child: isSaving
                ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Save'),
          ),
        ),
      ),
    );
  }
}
