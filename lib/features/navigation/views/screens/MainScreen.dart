import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';
import 'package:health_ed_flutter/features/home/views/screens/all_activity_screen.dart';
import 'package:health_ed_flutter/features/home/views/screens/all_quizzes_screen.dart';
import 'package:health_ed_flutter/features/home/views/screens/blog_list_screen.dart';
import 'package:health_ed_flutter/features/home/views/screens/home_screen.dart';
import 'package:health_ed_flutter/features/profile%20/views/screens/ProfileScreen.dart';

import '../../../home/views/screens/ReportScreen.dart';
import '../../bloc/bottom_navigation_cubit.dart';

class MainScreen extends StatelessWidget {
  final List<Widget> _screens = [
    HomeScreen(),
    BlogListScreen(),
    ReportScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BottomNavigationCubit(),
      child: BlocBuilder<BottomNavigationCubit, BottomNavItem>(
        builder: (context, currentNavItem) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: IndexedStack(
              index: currentNavItem.index,
              children: _screens,
            ),
            bottomNavigationBar: CustomBottomNavBar(
              pageIndex: currentNavItem.index,
              onTap: (index) {
                final navItem = BottomNavItem.values[index];
                context.read<BottomNavigationCubit>().updateNavItem(navItem);
              },
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Container(
              margin: const EdgeInsets.only(top: 10),
              height: 64,
              width: 64,
              child: FloatingActionButton(
                backgroundColor: ColorPallete.primary,
                elevation: 0,
                onPressed: () =>Get.to(()=>AllQuizzesScreen()),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 3, color: ColorPallete.whiteShade),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Text(
                  "Q",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 35,
                    fontFamily: 'Gilroy',
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


class CustomBottomNavBar extends StatelessWidget {
  final int pageIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.pageIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 0,
      height: 70,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          navItem(
            imagePath: pageIndex == 0?'assets/icons/home/home1.png':'assets/icons/home/home.png',
            label: "Home",
            isSelected: pageIndex == 0,
            onTap: () => onTap(0),
          ),
          navItem(
            imagePath: pageIndex == 1?'assets/icons/blog/blog1.png':'assets/icons/blog/blog.png',
            label: "Blogs",
            isSelected: pageIndex == 1,
            onTap: () => onTap(1),
          ),
          const SizedBox(width: 80), // Spacer for the middle FAB
          navItem(
            imagePath: pageIndex == 2?'assets/icons/report/report1.png':'assets/icons/report/report.png',
            label: "Report",
            isSelected: pageIndex == 2,
            onTap: () => onTap(2),
          ),
          navItem(
            imagePath: pageIndex == 3?'assets/icons/profile/profile1.png':'assets/icons/profile/profile.png',
            label: "Profile",
            isSelected: pageIndex == 3,
            onTap: () => onTap(3),
          ),
        ],
      ),
    )
    ;
  }

  Widget navItem({
    required String imagePath,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              imagePath,
              height: 24, // Adjust size as needed
              width: 24,
            ),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? ColorPallete.primary : ColorPallete.greyColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

