import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/malaysia.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../models/user_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/profile_provider.dart';
import '../../../shared/widgets/bottom_action_bar.dart';
import '../../../shared/widgets/form_error_text.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  bool _prefilled = false;

  @override
  void initState() {
    super.initState();
    // Opened directly by URL, this page can build while the session is still
    // being restored; fill the form as soon as the user is known (once only,
    // so it never overwrites what the user has typed).
    ref.listenManual<UserModel?>(currentUserProvider, (_, user) {
      if (user == null || _prefilled) return;
      _prefilled = true;
      _name.text = user.fullName;
      _phone.text = user.phone;
    }, fireImmediately: true);
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
        popOrGo(context, AppRoutes.profile);
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
          padding: const EdgeInsets.fromLTRB(AppSpacing.page, AppSpacing.lg, AppSpacing.page, AppSpacing.xl),
          children: [
            TextFormField(
              key: const Key('profile_name'),
              controller: _name,
              enabled: !isSaving,
              decoration: const InputDecoration(labelText: 'Full name'),
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.name],
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.isEmpty) return 'Full name is required';
                if (text.length > 255) return 'Full name is too long';
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              key: const Key('profile_phone'),
              controller: _phone,
              enabled: !isSaving,
              decoration: const InputDecoration(labelText: 'Phone (optional)', hintText: '012-345 6789'),
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.telephoneNumber],
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.isNotEmpty && !phonePattern.hasMatch(text)) return 'Enter a valid phone number';
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              // initialValue is read once; the key rebuilds the field if the
              // user loads after the page was first built.
              key: ValueKey('profile_email_$email'),
              initialValue: email,
              enabled: false,
              decoration: const InputDecoration(
                labelText: 'Email',
                helperText: 'Your email is your login and can’t be changed here.',
              ),
            ),
            if (submitState case SubmitError(:final message)) ...[
              const SizedBox(height: AppSpacing.lg),
              FormErrorText(message),
            ],
          ],
        ),
      ),
      bottomNavigationBar: BottomActionBar(
        child: FilledButton(
          key: const Key('profile_save'),
          onPressed: isSaving ? null : _save,
          child: isSaving ? const ButtonProgress() : const Text('Save'),
        ),
      ),
    );
  }
}
