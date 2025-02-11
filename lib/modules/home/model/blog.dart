class Blog {
  final String id;
  final Map<String, dynamic> name;
  final Map<String, dynamic> description;
  final String category;
  final String image;
  final int appreciations;
   bool isAppreciated;
  final String createdAt;
  final String updatedAt;

  Blog({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.image,
    required this.appreciations,
    required this.isAppreciated,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      image: json['image'],
      appreciations: json['appreciations'],
      isAppreciated: json['isAppreciated'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
