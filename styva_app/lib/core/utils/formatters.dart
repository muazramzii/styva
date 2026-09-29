/// Display-only formatting. Amounts are always server-calculated; the app
/// never does arithmetic on them.
String formatMoney(double amount) => 'RM ${amount.toStringAsFixed(2)}';

/// `pending` -> `Pending`.
String formatStatus(String status) {
  if (status.isEmpty) return status;
  return status[0].toUpperCase() + status.substring(1);
}

/// `2026-09-30`, in the device's local time zone.
String formatDate(DateTime dateTime) {
  final local = dateTime.toLocal();
  final month = local.month.toString().padLeft(2, '0');
  final day = local.day.toString().padLeft(2, '0');
  return '${local.year}-$month-$day';
}
