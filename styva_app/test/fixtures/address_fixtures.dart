import 'package:styva_app/models/address_model.dart';

Map<String, dynamic> addressJson({
  int id = 1,
  bool isDefault = true,
  String recipientName = 'Ali Bin Abu',
  String addressLine1 = '123 Jalan ABC',
  String addressLine2 = 'Taman Lama',
  String city = 'Skudai',
  String state = 'Johor',
  String postcode = '81300',
}) =>
    {
      'id': id,
      'recipient_name': recipientName,
      'phone': '0198765432',
      'address_line_1': addressLine1,
      'address_line_2': addressLine2,
      'city': city,
      'state': state,
      'postcode': postcode,
      'country': 'Malaysia',
      'is_default': isDefault,
      'created_at': '2026-09-30T10:00:00Z',
      'updated_at': '2026-09-30T10:00:00Z',
    };

AddressModel address({
  int id = 1,
  bool isDefault = true,
  String recipientName = 'Ali Bin Abu',
  String addressLine1 = '123 Jalan ABC',
}) =>
    AddressModel.fromJson(addressJson(
      id: id,
      isDefault: isDefault,
      recipientName: recipientName,
      addressLine1: addressLine1,
    ));
