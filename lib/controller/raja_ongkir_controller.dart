import 'package:dio/dio.dart';

class RajaOngkirService {
  static const String _baseUrl = 'https://api.rajaongkir.com/starter';
  static const String _apiKey = 'f538c92090626e1e9a7a82f44c2ff8bb';

  static final Dio _dio = Dio(BaseOptions(
    baseUrl: _baseUrl,
    headers: {'key': _apiKey},
  ));

  static Future<List<Map<String, dynamic>>> getShippingCosts(
      String destination) async {
    try {
      List<String> couriers = [
        'jne',
        'pos',
        'tiki',
      ];
      List<Map<String, dynamic>> allShippingServices = [];

      for (String courier in couriers) {
        // Kirim request API per kurir
        final response = await _dio.post(
          '/cost',
          data: {
            'origin': '152',
            'destination': destination,
            'weight': 1000,
            'courier': courier,
          },
          options: Options(
            contentType: Headers.formUrlEncodedContentType,
            validateStatus: (status) => true,
          ),
        );


        if (response.statusCode == 200) {
          final results = response.data['rajaongkir']['results'] as List;

          for (var courierResult in results) {
            final courierName = courierResult['name'];
            final costs = courierResult['costs'] as List;

            for (var cost in costs) {
              allShippingServices.add({
                'name': '$courierName',
                'description': cost['description'],
                'price': cost['cost'][0]['value'],
                'etd': cost['cost'][0]['etd'] ?? '1-1',
                'service': cost['service'],
              });
            }
          }
        } else {
          throw Exception(
              'Failed to load shipping costs for $courier: ${response.statusCode}');
        }
      }

      return allShippingServices;
    } catch (e) {
      throw Exception('Error fetching shipping costs: $e');
    }
  }
}
