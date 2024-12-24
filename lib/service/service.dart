import 'package:dio/dio.dart';
import 'package:skripsi_app/helper/dio_client.dart';
import 'package:skripsi_app/model/address_model.dart';
import 'package:skripsi_app/model/checkout_model.dart';
import 'package:skripsi_app/model/register_model.dart';
import 'package:skripsi_app/model/user_model.dart';
import 'package:skripsi_app/response/address_response.dart';
import 'package:skripsi_app/response/chatbot_response.dart';
import 'package:skripsi_app/response/checkout_response.dart';
import 'package:skripsi_app/response/forget_password_response.dart';
import 'package:skripsi_app/response/login_response.dart';
import 'package:skripsi_app/response/pagination_response.dart';
import 'package:skripsi_app/response/product_response.dart';
import 'package:skripsi_app/response/register_reposnse.dart';
import 'package:skripsi_app/response/riwayat_response.dart';
import 'package:skripsi_app/response/user_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skripsi_app/response/voucher_response.dart';

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
  Future<ProductResponse> getProducts({String? search, int? page}) async {
    try {
      final response = await _dio.get(
        '/products',
        queryParameters: {
          if (search != null && search.isNotEmpty) 'search': search,
          if (page != null) 'page': page,
          'limit': 10,
        },
      );

      return ProductResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return ProductResponse(
          status: false,
          message:
              e.response?.data['message'] ?? 'Terjadi kesalahan pada server',
          data: [],
          pagination: Pagination(
            limit: 0,
            currentPage: 0,
            lastPage: 0,
          ),
        );
      } else {
        return ProductResponse(
          status: false,
          message: 'Gagal terhubung ke server',
          data: [],
          pagination: Pagination(
            limit: 0,
            currentPage: 0,
            lastPage: 0,
          ),
        );
      }
    }
  }

  // Fetch product detail method
  Future<ProductDetailResponse> getProductDetail(String productId) async {
    try {
      final response = await _dio.get('/products/$productId');

      if (response.statusCode == 200) {
        return ProductDetailResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load product detail');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load product detail: ${e.message}');
    }
  }

  // Fetch voucher method
  Future<VoucherResponse> getVouchers({String? search, int? page}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (token.isEmpty) {
      return VoucherResponse(
        status: false,
        message: 'Silahkan login terlebih dahulu',
        data: [],
        pagination: Pagination(
          limit: 0,
          currentPage: 0,
          lastPage: 0,
        ),
      );
    }

    try {
      final response = await _dio.get(
        '/voucher',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        queryParameters: {
          if (search != null && search.isNotEmpty) 'search': search,
          if (page != null) 'page': page,
          'limit': 10,
        },
      );

      return VoucherResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return VoucherResponse(
          status: false,
          message:
              e.response?.data['message'] ?? 'Terjadi kesalahan pada server',
          data: [],
          pagination: Pagination(
            limit: 0,
            currentPage: 0,
            lastPage: 0,
          ),
        );
      } else {
        return VoucherResponse(
          status: false,
          message: 'Gagal terhubung ke server',
          data: [],
          pagination: Pagination(
            limit: 0,
            currentPage: 0,
            lastPage: 0,
          ),
        );
      }
    }
  }

  // Checkout method
  Future<CheckoutResponse> checkout(CheckoutRequest request) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (token.isEmpty) {
      return CheckoutResponse(
        status: false,
        message: 'Silahkan login terlebih dahulu',
        data: null,
      );
    }

    try {
      final response = await _dio.post(
        '/transaction',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: request.toJson(),
      );

      return CheckoutResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return CheckoutResponse(
          status: false,
          message:
              e.response?.data['message'] ?? 'Terjadi kesalahan pada server',
          data: null,
        );
      } else {
        return CheckoutResponse(
          status: false,
          message: 'Gagal terhubung ke server',
          data: null,
        );
      }
    }
  }

  // Add Address method
  Future<AddressResponse> addAddress(AddressModel request) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (token.isEmpty) {
      return AddressResponse(
        status: false,
        message: 'Silahkan login terlebih dahulu',
        data: null,
      );
    }

    try {
      final response = await _dio.post(
        '/address',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: request.toJson(),
      );

      return AddressResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response?.statusCode == 401) {
          await prefs.remove('token');
          return AddressResponse(
            status: false,
            message: 'Sesi Anda telah berakhir. Silahkan login kembali.',
            data: null,
          );
        }
        return AddressResponse(
          status: false,
          message:
              e.response?.data['message'] ?? 'Terjadi kesalahan pada server',
          data: null,
        );
      } else {
        return AddressResponse(
          status: false,
          message: 'Gagal terhubung ke server',
          data: null,
        );
      }
    }
  }

  // Fetch Address method
  Future<AddressResponse> getAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (token.isEmpty) {
      return AddressResponse(
        status: false,
        message: 'Silahkan login terlebih dahulu',
        data: [],
      );
    }

    try {
      final response = await _dio.get(
        '/address',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return AddressResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response?.statusCode == 401) {
          await prefs.remove('token');
          return AddressResponse(
            status: false,
            message: 'Sesi Anda telah berakhir. Silahkan login kembali.',
            data: [],
          );
        }
        return AddressResponse(
          status: false,
          message:
              e.response?.data['message'] ?? 'Terjadi kesalahan pada server',
          data: [],
        );
      } else {
        return AddressResponse(
          status: false,
          message: 'Gagal terhubung ke server',
          data: [],
        );
      }
    }
  }

  // Update Address method
  Future<AddressResponse> updateAddress(AddressModel request) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (token.isEmpty) {
      return AddressResponse(
        status: false,
        message: 'Silahkan login terlebih dahulu',
        data: null,
      );
    }

    try {
      final response = await _dio.put(
        '/address/${request.id}',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: request.toJson(),
      );

      return AddressResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response?.statusCode == 401) {
          await prefs.remove('token');
          return AddressResponse(
            status: false,
            message: 'Sesi Anda telah berakhir. Silahkan login kembali.',
            data: null,
          );
        }
        return AddressResponse(
          status: false,
          message:
              e.response?.data['message'] ?? 'Terjadi kesalahan pada server',
          data: null,
        );
      } else {
        return AddressResponse(
          status: false,
          message: 'Gagal terhubung ke server',
          data: null,
        );
      }
    }
  }

  // Delete Address method
  Future<AddressResponse> deleteAddress(String addressId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (token.isEmpty) {
      return AddressResponse(
        status: false,
        message: 'Silahkan login terlebih dahulu',
        data: null,
      );
    }

    try {
      final response = await _dio.delete(
        '/address/$addressId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return AddressResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response?.statusCode == 401) {
          await prefs.remove('token');
          return AddressResponse(
            status: false,
            message: 'Sesi Anda telah berakhir. Silahkan login kembali.',
            data: null,
          );
        }
        return AddressResponse(
          status: false,
          message:
              e.response?.data['message'] ?? 'Terjadi kesalahan pada server',
          data: null,
        );
      } else {
        return AddressResponse(
          status: false,
          message: 'Gagal terhubung ke server',
          data: null,
        );
      }
    }
  }

  // Edit Profile method
  Future<EditProfileResponse> editProfile(EditProfile request) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (token.isEmpty) {
      return EditProfileResponse(
        status: false,
        message: 'Silahkan login terlebih dahulu',
      );
    }

    try {
      final response = await _dio.put(
        '/profile',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: request.toJson(),
      );

      return EditProfileResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response?.statusCode == 401) {
          await prefs.remove('token');
          return EditProfileResponse(
            status: false,
            message: 'Sesi Anda telah berakhir. Silahkan login kembali.',
          );
        }
        return EditProfileResponse(
          status: false,
          message:
              e.response?.data['message'] ?? 'Terjadi kesalahan pada server',
        );
      } else {
        return EditProfileResponse(
          status: false,
          message: 'Gagal terhubung ke server',
        );
      }
    }
  }

  // Fetch Riwayat method
  Future<RiwayatResponse> getRiwayat({String? search, int? page}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (token.isEmpty) {
      return RiwayatResponse(
        status: false,
        message: 'Silahkan login terlebih dahulu',
        data: [],
        pagination: Pagination(
          limit: 0,
          currentPage: 0,
          lastPage: 0,
        ),
      );
    }

    try {
      final response = await _dio.get(
        '/transaction/profile',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        queryParameters: {
          if (search != null && search.isNotEmpty) 'search': search,
          if (page != null) 'page': page,
          'limit': 10,
        },
      );

      return RiwayatResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response?.statusCode == 401) {
          await prefs.remove('token');
          return RiwayatResponse(
            status: false,
            message: 'Sesi Anda telah berakhir. Silahkan login kembali.',
            data: [],
            pagination: Pagination(
              limit: 0,
              currentPage: 0,
              lastPage: 0,
            ),
          );
        }
        return RiwayatResponse(
          status: false,
          message:
              e.response?.data['message'] ?? 'Terjadi kesalahan pada server',
          data: [],
          pagination: Pagination(
            limit: 0,
            currentPage: 0,
            lastPage: 0,
          ),
        );
      } else {
        return RiwayatResponse(
          status: false,
          message: 'Gagal terhubung ke server',
          data: [],
          pagination: Pagination(
            limit: 0,
            currentPage: 0,
            lastPage: 0,
          ),
        );
      }
    }
  }

  // Update Riwayat method
  Future<RiwayatStatusResponse> updateRiwayat(String transactionId, String status) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (token.isEmpty) {
      return RiwayatStatusResponse(
        status: false,
        message: 'Silahkan login terlebih dahulu',
      );
    }

    try {
      final response = await _dio.patch(
        '/transaction/$transactionId/status',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          'status': status,
        },
      );

      return RiwayatStatusResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response?.statusCode == 401) {
          await prefs.remove('token');
          return RiwayatStatusResponse(
            status: false,
            message: 'Sesi Anda telah berakhir. Silahkan login kembali.',
          );
        }
        return RiwayatStatusResponse(
          status: false,
          message:
              e.response?.data['message'] ?? 'Terjadi kesalahan pada server',
        );
      } else {
        return RiwayatStatusResponse(
          status: false,
          message: 'Gagal terhubung ke server',
        );
      }
    }
  }

  // Send OTP method
  Future<SendOTPResponse> sendOTP(String email) async {
    try {
      final response = await _dio.post(
        '/forgot-password',
        data: {
          'email': email,
        },
      );

      return SendOTPResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return SendOTPResponse(
          status: false,
          message:
              e.response?.data['message'] ?? 'Terjadi kesalahan pada server',
        );
      } else {
        return SendOTPResponse(
          status: false,
          message: 'Gagal terhubung ke server',
        );
      }
    }
  }

  // Verify OTP method
  Future<VerifyOTPResponse> verifyOTP(String email, String otp) async {
    try {
      final response = await _dio.post(
        '/verify-otp',
        data: {
          'email': email,
          'otp': otp,
        },
      );

      return VerifyOTPResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return VerifyOTPResponse(
          status: false,
          message:
              e.response?.data['message'] ?? 'Terjadi kesalahan pada server',
        );
      } else {
        return VerifyOTPResponse(
          status: false,
          message: 'Gagal terhubung ke server',
        );
      }
    }
  }

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }
  
  // New Password method
  Future<ResetPasswordResponse> resetPassword(String password, String confirmPassword) async {
    try {
      final response = await _dio.post(
        '/new-password',
        data: {
          'password': password,
          'confirm_password': confirmPassword,
        },
      );

      return ResetPasswordResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return ResetPasswordResponse(
          status: false,
          message:
              e.response?.data['message'] ?? 'Terjadi kesalahan pada server',
        );
      } else {
        return ResetPasswordResponse(
          status: false,
          message: 'Gagal terhubung ke server',
        );
      }
    }
  }

  // Chatbot method
  Future<ChatbotResponse> chatbot(String question) async {
    try {
      final response = await _dio.post(
        '/chatbot',
        data: {
          'question': question,
        },
      );

      return ChatbotResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return ChatbotResponse(
          status: false,
          message:
              e.response?.data['message'] ?? 'Terjadi kesalahan pada server',
          data: null,
        );
      } else {
        return ChatbotResponse(
          status: false,
          message: 'Gagal terhubung ke server',
          data: null,
        );
      }
    }
  }
}
