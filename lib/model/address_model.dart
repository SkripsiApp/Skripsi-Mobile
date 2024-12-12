class AddressModel {
  final String name;
  final String address;
  final String city;
  final String subdistrict;
  final String zipCode;
  final String phone;

  AddressModel({
    required this.name,
    required this.address,
    required this.city,
    required this.subdistrict,
    required this.zipCode,
    required this.phone,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      name: json['name'],
      address: json['address'],
      city: json['city'],
      subdistrict: json['subdistrict'],
      zipCode: json['zip_code'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'city': city,
      'subdistrict': subdistrict,
      'zip_code': zipCode,
      'phone': phone,
    };
  }
}