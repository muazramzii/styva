// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderModelImpl _$$OrderModelImplFromJson(Map<String, dynamic> json) =>
    _$OrderModelImpl(
      id: (json['id'] as num).toInt(),
      orderNumber: json['order_number'] as String,
      status: json['status'] as String,
      paymentStatus: json['payment_status'] as String,
      subtotal: _moneyFromJson(json['subtotal']),
      shippingFee: _moneyFromJson(json['shipping_fee']),
      total: _moneyFromJson(json['total']),
      itemCount: (json['item_count'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      shippingAddress:
          json['shipping_address'] == null
              ? null
              : ShippingAddressModel.fromJson(
                json['shipping_address'] as Map<String, dynamic>,
              ),
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$OrderModelImplToJson(_$OrderModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_number': instance.orderNumber,
      'status': instance.status,
      'payment_status': instance.paymentStatus,
      'subtotal': _moneyToJson(instance.subtotal),
      'shipping_fee': _moneyToJson(instance.shippingFee),
      'total': _moneyToJson(instance.total),
      'item_count': instance.itemCount,
      'created_at': instance.createdAt.toIso8601String(),
      'shipping_address': instance.shippingAddress?.toJson(),
      'items': instance.items.map((e) => e.toJson()).toList(),
    };
