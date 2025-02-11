import 'package:health_ed_flutter/modules/home/model/blog_categories.dart';

class BlogCategoriesResponse {
  bool? success;
  List<BlogCategory>? data;

  BlogCategoriesResponse({this.success, this.data});

  BlogCategoriesResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <BlogCategory>[];
      json['data'].forEach((v) {
        data!.add(BlogCategory.fromJson(v));
      });
    }
  }
}
