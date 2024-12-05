class ProductStockCache {
  static final Map<String, Map<String, int>> _stockCache = {};

  static void addStock(String productId, String size, int stock) {
    if (!_stockCache.containsKey(productId)) {
      _stockCache[productId] = {};
    }
    _stockCache[productId]![size] = stock;
  }

  int getStock(String productId, String size) {
    return _stockCache[productId]?[size] ?? 0; 
  }
}

final productStockCache = ProductStockCache();
