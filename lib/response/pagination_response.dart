class Pagination {
  final int limit;
  final int currentPage;
  final int lastPage;

  Pagination({
    required this.limit,
    required this.currentPage,
    required this.lastPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      limit: json['limit'],
      currentPage: json['current_page'],
      lastPage: json['last_page'],
    );
  }
}
