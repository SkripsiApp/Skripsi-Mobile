import 'package:skripsi_app/model/voucher_model.dart';
import 'package:skripsi_app/response/pagination_response.dart';

class VoucherResponse {
  final bool status;
  final String message;
  final List<Voucher> data;
  final Pagination pagination;

  VoucherResponse({
    required this.status,
    required this.message,
    required this.data,
    required this.pagination,
  });

  factory VoucherResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List?;
    List<Voucher> voucherList =
        list?.map((i) => Voucher.fromJson(i)).toList() ?? [];

    return VoucherResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: voucherList,
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : Pagination(limit: 0, currentPage: 0, lastPage: 0),
    );
  }
}
