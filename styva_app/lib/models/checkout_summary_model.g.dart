// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CheckoutSummaryModelImpl _$$CheckoutSummaryModelImplFromJson(
  Map<String, dynamic> json,
) => _$CheckoutSummaryModelImpl(
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  subtotal: _moneyFromJson(json['subtotal']),
  shippingFee: _moneyFromJson(json['shipping_fee']),
  total: _moneyFromJson(json['total']),
);

Map<String, dynamic> _$$CheckoutSummaryModelImplToJson(
  _$CheckoutSummaryModelImpl instance,
) => <String, dynamic>{
  'items': instance.items,
  'subtotal': _moneyToJson(instance.subtotal),
  'shipping_fee': _moneyToJson(instance.shippingFee),
  'total': _moneyToJson(instance.total),
};
