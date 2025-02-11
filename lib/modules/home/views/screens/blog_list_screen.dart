import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:health_ed_flutter/core/services/api_urls.dart';
import 'package:health_ed_flutter/core/services/http_wrapper.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';
import 'package:health_ed_flutter/modules/home/model/blog.dart';
import 'package:health_ed_flutter/modules/home/model/blog_categories.dart';
import 'package:health_ed_flutter/modules/home/model/response/blog_categories_response.dart';
import 'package:health_ed_flutter/modules/home/views/screens/blog_details_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:health_ed_flutter/core/utils/custom_widgets.dart';

class BlogListScreen extends StatefulWidget {
  @override
  _BlogListScreenState createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
  String selectedLanguage = 'English';
  bool isDragging = false;
  bool isLoading = true;
  List<Blog> blogs = [];
  List<BlogCategory> categories = [];
  String? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    fetchCategories().then((_) {
      if (selectedCategoryId != null) {
        fetchBlogs(selectedCategoryId!);
      }
    });
  }

  Future<void> fetchCategories() async {
    try {
      final response = await HttpWrapper.getRequest(
        ApiUrls.blog_category_all,
      );
      print(response.body);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final categoriesResponse =
            BlogCategoriesResponse.fromJson(jsonResponse);
        setState(() {
          categories = categoriesResponse.data ?? [];
          categories.insert(
              0, BlogCategory('all', {'en': 'All'}, true, '', ''));
          selectedCategoryId = 'all';
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
      // showErrorSnackbar('Error: ${e.toString()}');
    }
  }

  Future<void> fetchBlogs(String categoryId) async {
    try {
      final response = await HttpWrapper.getRequest(
        ApiUrls.blog_all + "/$categoryId",
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          setState(() {
            blogs = (jsonResponse['data'] as List)
                .map((blog) => Blog.fromJson(blog))
                .toList();
          });
        }
      }
    } catch (e) {
      print('Error fetching blogs: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/bg/videobgimage.png'),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTransparentContainer(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Blogs',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 20),
                            if (isLoading)
                              Center(child: CircularProgressIndicator())
                            else
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children:
                                      List.generate(categories.length, (index) {
                                    bool isSelected = selectedCategoryId ==
                                        categories[index].id;
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedCategoryId =
                                              categories[index].id;
                                        });
                                        fetchBlogs(categories[index].id);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? ColorPallete.primary
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        padding: EdgeInsets.all(10),
                                        margin: EdgeInsets.all(10),
                                        child: Text(
                                          categories[index].name['en'] ?? '',
                                          style: TextStyle(
                                              color: isSelected
                                                  ? Colors.white
                                                  : Colors.black),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            SizedBox(height: 20),
                            Expanded(
                                child: ListView.builder(
                              itemCount: blogs.length,
                              itemBuilder: (context, index) {
                                final blog = blogs[index];
                                return GestureDetector(
                                    onTap: () {
                                      Get.to(() =>
                                      BlogDetailsScreen(blog: blog));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 104,
                                            height: 77,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              image: DecorationImage(
                                                image: NetworkImage(blog.image),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              width:
                                                  20), // Spacing between icon and text
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Modified Text widget
                                                Text(
                                                  blog.name['en'] ?? '',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  maxLines:
                                                      2, // Limit to 2 lines
                                                  overflow: TextOverflow
                                                      .ellipsis, // Add ellipsis for overflow
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  blog.description['en'] ?? '',
                                                  style: TextStyle(),
                                                  maxLines:
                                                      2, // Limit to 2 lines
                                                  overflow: TextOverflow
                                                      .ellipsis, // Add ellipsis for overflow
                                                ), // Spacing between title and hand clap

                                                SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    Icon(
                                                        Icons.waving_hand_sharp,
                                                        color: Colors.grey,
                                                        size: 12),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      '${blog.appreciations}',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ), // Spacing below hand clap row
                                                // Text(
                                                //   '10 min read', // Duration text
                                                //   style: TextStyle(
                                                //     fontSize: 12,
                                                //     color: Colors.grey,
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ));
                              },
                            )),
                          ],
                        ),
                      ),
                    ),
                  ]),
            )),
      ),
    );
  }
}
