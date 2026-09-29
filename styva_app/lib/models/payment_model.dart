import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_model.freezed.dart';
part 'payment_model.g.dart';

double _moneyFromJson(dynamic value) => double.parse(value.toString());

String _moneyToJson(double value) => value.toStringAsFixed(2);

/// Payment status values sent by the backend (`pending`/`success`/`failed`).
abstract class PaymentStatus {
  PaymentStatus._();

  static const String pending = 'pending';
  static const String success = 'success';
  static const String failed = 'failed';
}

/// A payment attempt for an order. Everything here is set by the backend;
/// the app only ever sends the order id.
@freezed
class PaymentModel with _$PaymentModel {
  const factory PaymentModel({
    required int id,
    required String reference,
    @JsonKey(name: 'order_id') required int orderId,
    @JsonKey(name: 'order_number') required String orderNumber,
    @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson) required double amount,
    required String status,
    required String provider,
    @JsonKey(name: 'provider_reference') String? providerReference,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _PaymentModel;

  factory PaymentModel.fromJson(Map<String, dynamic> json) => _$PaymentModelFromJson(json);
}
