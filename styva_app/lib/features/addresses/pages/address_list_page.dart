import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/api_error.dart';
import '../../../models/address_model.dart';
import '../../../providers/address_provider.dart';
import '../../../shared/widgets/state_message.dart';
import '../widgets/address_summary.dart';

class AddressListPage extends ConsumerStatefulWidget {
  const AddressListPage({super.key});

  @override
  ConsumerState<AddressListPage> createState() => _AddressListPageState();
}

class _AddressListPageState extends ConsumerState<AddressListPage> {
  /// Id of the address with a Set Default / Delete request in flight. While
  /// set, every address action is disabled so nothing is sent twice.
  int? _busyId;

  Future<void> _run(int id, Future<void> Function() action, String successMessage) async {
    if (_busyId != null) return;
    setState(() => _busyId = id);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await action();
      messenger.showSnackBar(SnackBar(content: Text(successMessage)));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(extractApiErrorMessage(e))));
    } finally {
      if (mounted) setState(() => _busyId = null);
    }
  }

  Future<void> _confirmDelete(AddressModel address) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete address?'),
            content: Text(
              address.isDefault
                  ? 'This is your default address. Your most recently added address will become the default.'
                  : 'This address will be removed from your saved addresses.',
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
    if (confirmed != true || !mounted) return;
    await _run(address.id, () => ref.read(addressesProvider.notifier).delete(address.id), 'Address deleted');
  }

  @override
  Widget build(BuildContext context) {
    final addressesAsync = ref.watch(addressesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Addresses')),
      body: addressesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, _) => StateMessage.error(
              title: 'Could not load your addresses',
              message: extractApiErrorMessage(error),
              onRetry: () => ref.invalidate(addressesProvider),
            ),
        data: (addresses) {
          if (addresses.isEmpty) {
            return StateMessage(
              icon: Icons.location_off_outlined,
              title: 'No saved addresses',
              message: "You haven't saved an address yet.",
              actionLabel: 'Add Address',
              onAction: () => context.push(AppRoutes.addressNew),
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.refresh(addressesProvider.future),
            child: ListView.separated(
              // Bottom space keeps the last card's actions clear of the Add Address button.
              padding: const EdgeInsets.fromLTRB(AppSpacing.page, AppSpacing.lg, AppSpacing.page, 96),
              itemCount: addresses.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final address = addresses[index];
                final disabled = _busyId != null;
                return Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.sm, AppSpacing.sm),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AddressSummary(address: address),
                        const SizedBox(height: AppSpacing.xs),
                        // Wraps onto a second line with large text instead of overflowing.
                        SizedBox(
                          width: double.infinity,
                          child: Wrap(
                            alignment: WrapAlignment.end,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              if (_busyId == address.id)
                                const Padding(
                                  padding: EdgeInsets.all(AppSpacing.md),
                                  child: SizedBox.square(
                                    dimension: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                ),
                              if (!address.isDefault)
                                TextButton(
                                  onPressed:
                                      disabled
                                          ? null
                                          : () => _run(
                                            address.id,
                                            () => ref.read(addressesProvider.notifier).setDefault(address.id),
                                            'Default address updated',
                                          ),
                                  child: const Text('Set Default'),
                                ),
                              TextButton(
                                onPressed: disabled ? null : () => context.push('/addresses/${address.id}/edit'),
                                child: const Text('Edit'),
                              ),
                              TextButton(
                                onPressed: disabled ? null : () => _confirmDelete(address),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton:
          addressesAsync.hasValue && addressesAsync.value!.isNotEmpty
              ? FloatingActionButton.extended(
                onPressed: () => context.push(AppRoutes.addressNew),
                icon: const Icon(Icons.add),
                label: const Text('Add Address'),
              )
              : null,
    );
  }
}
