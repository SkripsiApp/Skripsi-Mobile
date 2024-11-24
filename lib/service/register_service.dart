import 'package:dio/dio.dart';
import 'package:skripsi_app/helper/dio_client.dart';
import 'package:skripsi_app/model/register_model.dart';
import 'package:skripsi_app/model/user_model.dart';
import 'package:skripsi_app/response/login_response.dart';
import 'package:skripsi_app/response/product_response.dart';
import 'package:skripsi_app/response/register_reposnse.dart';
import 'package:skripsi_app/response/user_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

   // Login method
   Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return LoginResponse(
          status: false,
          message:
              e.response?.data['message'] ?? 'Terjadi kesalahan pada server',
        );
      } else {
        return LoginResponse(
          status: false,
          message: 'Gagal terhubung ke server',
        );
      }
    }
  }

  // Fetch Profile method
  Future<ProfileResponse> getProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await _dio.get(
        '/profile',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return ProfileResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return ProfileResponse(
          status: false,
          message:
              e.response?.data['message'] ?? 'Terjadi kesalahan pada server',
          data: null,
        );
      } else {
        return ProfileResponse(
          status: false,
          message: 'Gagal terhubung ke server',
          data: null,
        );
      }
    }
  }

  // Fetch products method
  Future<ProductResponse> getProducts() async {
    try {
      final response = await _dio.get('/products');

      return ProductResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return ProductResponse(
          status: false,
          message:
              e.response?.data['message'] ?? 'Terjadi kesalahan pada server',
          data: [],
        );
      } else {
        return ProductResponse(
          status: false,
          message: 'Gagal terhubung ke server',
          data: [],
        );
      }
    }
  }
}
