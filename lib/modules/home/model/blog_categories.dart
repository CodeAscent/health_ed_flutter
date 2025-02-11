class BlogCategory {
  final String id;
  final Map<String, dynamic> name;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  BlogCategory(
      this.id, this.name, this.isActive, this.createdAt, this.updatedAt);

  factory BlogCategory.fromJson(Map<String, dynamic> json) {
    return BlogCategory(
      json['_id'],
      json['name'],
      json['isActive'],
      json['createdAt'],
      json['updatedAt'],
    );
  }
}
