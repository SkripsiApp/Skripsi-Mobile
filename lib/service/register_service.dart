import 'package:dio/dio.dart';
import 'package:skripsi_app/helper/dio_client.dart';
import 'package:skripsi_app/model/register_model.dart';
import 'package:skripsi_app/response/register_reposnse.dart';

class ApiService {
  final Dio _dio = DioClient().dio;

  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      final response = await _dio.post(
        '/register',
        data: request.toJson(),
      );

      return RegisterResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return RegisterResponse(
          status: false,
          message:
              e.response?.data['message'] ?? 'Terjadi kesalahan pada server',
        );
      } else {
        return RegisterResponse(
          status: false,
          message: 'Gagal terhubung ke server',
        );
      }
    }
  }
}
