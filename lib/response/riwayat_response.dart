import 'package:skripsi_app/model/riwayat_model.dart';
import 'package:skripsi_app/response/pagination_response.dart';

class RiwayatResponse {
 final bool status;
  final String message;
  final List<RiwayatModel> data;
  final Pagination pagination;

  RiwayatResponse({
    required this.status,
    required this.message,
    required this.data,
    required this.pagination,
  });

  factory RiwayatResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<RiwayatModel> riwayatList = list.map((i) => RiwayatModel.fromJson(i)).toList();

    return RiwayatResponse(
      status: json['status'],
      message: json['message'],
      data: riwayatList,
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}