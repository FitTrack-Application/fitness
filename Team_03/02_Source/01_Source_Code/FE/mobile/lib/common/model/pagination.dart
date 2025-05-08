class Pagination {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int pageSize;

  Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.pageSize,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['currentPage'] as int,
      totalPages: json['totalPages'] as int,
      totalItems: json['totalItems'] as int,
      pageSize: json['pageSize'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPage': currentPage,
      'totalPages': totalPages,
      'totalItems': totalItems,
      'pageSize': pageSize,
    };
  }
}

class PaginatedResponse<T> {
  final String message;
  final List<T> data;
  final Pagination pagination;

  PaginatedResponse({
    required this.message,
    required this.data,
    required this.pagination,
  });
}
