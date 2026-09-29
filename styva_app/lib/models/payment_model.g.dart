// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentModelImpl _$$PaymentModelImplFromJson(Map<String, dynamic> json) =>
    _$PaymentModelImpl(
      id: (json['id'] as num).toInt(),
      reference: json['reference'] as String,
      orderId: (json['order_id'] as num).toInt(),
      orderNumber: json['order_number'] as String,
      amount: _moneyFromJson(json['amount']),
      status: json['status'] as String,
      provider: json['provider'] as String,
      providerReference: json['provider_reference'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$PaymentModelImplToJson(_$PaymentModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reference': instance.reference,
      'order_id': instance.orderId,
      'order_number': instance.orderNumber,
      'amount': _moneyToJson(instance.amount),
      'status': instance.status,
      'provider': instance.provider,
      'provider_reference': instance.providerReference,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
