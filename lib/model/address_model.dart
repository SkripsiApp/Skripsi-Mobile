class AddressModel {
  final String? id;
  final String name;
  final String address;
  final String city;
  final String? cityId;
  final String subdistric;
  final String zipCode;
  final String phone;

  AddressModel({
    this.id,
    required this.name,
    required this.address,
    required this.city,
    this.cityId,
    required this.subdistric,
    required this.zipCode,
    required this.phone,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      city: json['city'],
      cityId: json['city_id'],
      subdistric: json['subdistric'],
      zipCode: json['zip_code'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'city': city,
      'city_id': cityId,
      'subdistric': subdistric,
      'zip_code': zipCode,
      'phone': phone,
    };
  }
}