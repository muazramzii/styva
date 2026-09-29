import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/malaysia.dart';
import '../../../core/utils/api_error.dart';
import '../../../models/address_model.dart';
import '../../../providers/address_provider.dart';

/// Add a new address (`addressId == null`) or edit an existing one. On save
/// the page pops with the saved [AddressModel], so callers such as checkout
/// can select it straight away.
class AddressFormPage extends ConsumerWidget {
  const AddressFormPage({super.key, this.addressId});

  final String? addressId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = addressId != null;
    final id = isEditing ? int.tryParse(addressId!) : null;
    final title = Text(isEditing ? 'Edit Address' : 'Add Address');

    if (isEditing && id == null) {
      return Scaffold(appBar: AppBar(title: title), body: const Center(child: Text('Address not found')));
    }

    final addressesAsync = ref.watch(addressesProvider);
    return Scaffold(
      appBar: AppBar(title: title),
      body: addressesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Could not load your addresses.\n${extractApiErrorMessage(error)}', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              OutlinedButton(onPressed: () => ref.invalidate(addressesProvider), child: const Text('Retry')),
            ],
          ),
        ),
        data: (addresses) {
          if (!isEditing) {
            return _AddressForm(initial: null, isFirstAddress: addresses.isEmpty);
          }
          final address = addresses.where((a) => a.id == id).firstOrNull;
          if (address == null) return const Center(child: Text('Address not found'));
          return _AddressForm(initial: address, isFirstAddress: false);
        },
      ),
    );
  }
}

class _AddressForm extends ConsumerStatefulWidget {
  const _AddressForm({required this.initial, required this.isFirstAddress});

  final AddressModel? initial;
  final bool isFirstAddress;

  @override
  ConsumerState<_AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends ConsumerState<_AddressForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _line1;
  late final TextEditingController _line2;
  late final TextEditingController _city;
  late final TextEditingController _postcode;
  String? _state;
  late bool _isDefault;
  bool _saving = false;
  String? _error;

  /// The first address, and the current default, are always the default --
  /// the backend enforces this, so the switch is shown on and locked.
  bool get _defaultLocked => widget.isFirstAddress || (widget.initial?.isDefault ?? false);

  @override
  void initState() {
    super.initState();
    final a = widget.initial;
    _name = TextEditingController(text: a?.recipientName ?? '');
    _phone = TextEditingController(text: a?.phone ?? '');
    _line1 = TextEditingController(text: a?.addressLine1 ?? '');
    _line2 = TextEditingController(text: a?.addressLine2 ?? '');
    _city = TextEditingController(text: a?.city ?? '');
    _postcode = TextEditingController(text: a?.postcode ?? '');
    _state = malaysianStates.any((s) => s.$1 == a?.state) ? a!.state : null;
    _isDefault = _defaultLocked;
  }

  @override
  void dispose() {
    for (final c in [_name, _phone, _line1, _line2, _city, _postcode]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _required(String? value, String label) =>
      (value == null || value.trim().isEmpty) ? '$label is required' : null;

  Future<void> _save() async {
    if (_saving || !_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final input = AddressInput(
      recipientName: _name.text.trim(),
      phone: _phone.text.trim(),
      addressLine1: _line1.text.trim(),
      addressLine2: _line2.text.trim(),
      city: _city.text.trim(),
      state: _state!,
      postcode: _postcode.text.trim(),
      isDefault: _isDefault,
    );
    try {
      final notifier = ref.read(addressesProvider.notifier);
      final saved = widget.initial == null
          ? await notifier.create(input)
          : await notifier.save(widget.initial!.id, input);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Address saved')));
      context.pop(saved);
    } catch (e) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = extractApiErrorMessage(e);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  key: const Key('address_recipient'),
                  controller: _name,
                  enabled: !_saving,
                  decoration: const InputDecoration(labelText: 'Recipient name'),
                  textCapitalization: TextCapitalization.words,
                  validator: (v) => _required(v, 'Recipient name'),
                ),
                TextFormField(
                  key: const Key('address_phone'),
                  controller: _phone,
                  enabled: !_saving,
                  decoration: const InputDecoration(labelText: 'Phone number', hintText: '012-345 6789'),
                  keyboardType: TextInputType.phone,
                  validator: (v) {
                    final missing = _required(v, 'Phone number');
                    if (missing != null) return missing;
                    return phonePattern.hasMatch(v!.trim()) ? null : 'Enter a valid phone number';
                  },
                ),
                TextFormField(
                  key: const Key('address_line_1'),
                  controller: _line1,
                  enabled: !_saving,
                  decoration: const InputDecoration(labelText: 'Address line 1'),
                  validator: (v) => _required(v, 'Address line 1'),
                ),
                TextFormField(
                  key: const Key('address_line_2'),
                  controller: _line2,
                  enabled: !_saving,
                  decoration: const InputDecoration(labelText: 'Address line 2 (optional)'),
                ),
                TextFormField(
                  key: const Key('address_city'),
                  controller: _city,
                  enabled: !_saving,
                  decoration: const InputDecoration(labelText: 'City'),
                  validator: (v) => _required(v, 'City'),
                ),
                DropdownButtonFormField<String>(
                  key: const Key('address_state'),
                  value: _state,
                  decoration: const InputDecoration(labelText: 'State'),
                  items: [
                    for (final (value, label) in malaysianStates)
                      DropdownMenuItem(value: value, child: Text(label)),
                  ],
                  onChanged: _saving ? null : (value) => setState(() => _state = value),
                  validator: (v) => v == null ? 'State is required' : null,
                ),
                TextFormField(
                  key: const Key('address_postcode'),
                  controller: _postcode,
                  enabled: !_saving,
                  decoration: const InputDecoration(labelText: 'Postcode'),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    final missing = _required(v, 'Postcode');
                    if (missing != null) return missing;
                    return postcodePattern.hasMatch(v!.trim()) ? null : 'Enter a valid 5-digit postcode';
                  },
                ),
                TextFormField(
                  initialValue: 'Malaysia',
                  enabled: false,
                  decoration: const InputDecoration(labelText: 'Country'),
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  key: const Key('address_default'),
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Set as default'),
                  subtitle: _defaultLocked
                      ? Text(widget.isFirstAddress
                          ? 'Your first address is your default.'
                          : 'This is your default. To change it, set another address as default.')
                      : null,
                  value: _isDefault,
                  onChanged: _defaultLocked || _saving ? null : (value) => setState(() => _isDefault = value),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 8),
                  Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                ],
              ],
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                key: const Key('address_save'),
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Save Address'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
