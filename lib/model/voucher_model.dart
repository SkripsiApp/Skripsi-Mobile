class Voucher {
  final String id;
  final String name;
  final String description;
  final int discount;

  Voucher({
    required this.id,
    required this.name,
    required this.description,
    required this.discount,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) {
    return Voucher(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      discount: json['discount'],
    );
  }
}