import 'package:skripsi_app/model/address_model.dart';

class AddressResponse {
  final bool status;
  final String message;
  final List<AddressModel>? data;

  AddressResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory AddressResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List?;
    List<AddressModel> addressList =
        list?.map((i) => AddressModel.fromJson(i)).toList() ?? [];

    return AddressResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: addressList,
    );
  }
}