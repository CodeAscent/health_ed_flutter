import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:health_ed_flutter/core/local/local_storage.dart';
import 'package:health_ed_flutter/modules/auth/views/screens/planScreen.dart';
import 'package:health_ed_flutter/modules/home/events/dashboard_events.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';
import 'package:health_ed_flutter/modules/home/bloc/dashboard_bloc.dart';
import 'package:health_ed_flutter/modules/home/views/screens/all_activity_screen.dart';
import 'package:health_ed_flutter/modules/home/views/screens/all_quizzes_screen.dart';
import 'package:health_ed_flutter/modules/home/views/screens/blog_list_screen.dart';
import 'package:health_ed_flutter/modules/home/views/screens/home_screen.dart';
import 'package:health_ed_flutter/modules/profile%20/views/screens/ProfileScreen.dart';

import '../../../home/views/screens/ReportScreen.dart';
import '../../bloc/bottom_navigation_cubit.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> _screens = [
    PlanScreen(),
    HomeScreen(),
    BlogListScreen(),
    ProfileScreen(),
  ];
  @override
  void initState() {
    super.initState();
    Get.find<Rx<DashboardRefreshEvent>>(tag: 'dashboard_refresh')
        .trigger(DashboardRefreshEvent());
  }

  @override
  Widget build(BuildContext context) {
    var userData = LocalStorage.prefs.getString('userProfileData') != null
        ? jsonDecode(LocalStorage.prefs.getString('userProfileData')!)['user']
        : '';
    return BlocProvider(
      create: (_) => BottomNavigationCubit(),
      child: BlocBuilder<BottomNavigationCubit, BottomNavItem>(
        builder: (context, currentNavItem) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: BlocProvider.value(
              value: BlocProvider.of<DashboardBloc>(context),
              child: IndexedStack(
                index: currentNavItem.index,
                children: _screens,
              ),
            ),
            bottomNavigationBar: CustomBottomNavBar(
              userData: userData,
              pageIndex: currentNavItem.index,
              onTap: (index) {
                if (index == 0) {
                  Get.find<Rx<DashboardRefreshEvent>>(tag: 'dashboard_refresh')
                      .trigger(DashboardRefreshEvent());
                }
                final navItem = BottomNavItem.values[index];
                context.read<BottomNavigationCubit>().updateNavItem(navItem);
              },
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Container(
              margin: const EdgeInsets.only(top: 10),
              height: 64,
              width: 64,
              child: FloatingActionButton(
                backgroundColor: ColorPallete.primary,
                elevation: 0,
                onPressed: () {
                  if (userData['onboardingScore'] == 0) {
                    Get.snackbar(
                      'Assessment Incomplete',
                      'Please complete the assessment to continue.',
                      backgroundColor: Colors.orange.shade100,
                      colorText: Colors.black,
                    );
                  } else {
                    Get.to(() => AllQuizzesScreen());
                  }
                },
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                      width: 3, color: ColorPallete.whiteShade),
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
  final userData;

  const CustomBottomNavBar({
    Key? key,
    required this.pageIndex,
    required this.onTap,
    required this.userData,
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
            imagePath: pageIndex == 0
                ? 'assets/icons/home/home1.png'
                : 'assets/icons/home/home.png',
            label: "Home",
            isSelected: pageIndex == 0,
            onTap: () => {
              if (userData['onboardingScore'] == 0)
                {
                  Get.snackbar(
                    'Assessment Incomplete',
                    'Please complete the assessment to continue.',
                    backgroundColor: Colors.orange.shade100,
                    colorText: Colors.black,
                  )
                  // Prevent further navigation
                }
              else
                {onTap(0)}
            },
          ),
          navItem(
            imagePath: pageIndex == 1
                ? 'assets/icons/report/report1.png'
                : 'assets/icons/report/report.png',
            label: "Report",
            isSelected: pageIndex == 1,
            onTap: () => {
              if (userData['onboardingScore'] == 0)
                {
                  Get.snackbar(
                    'Assessment Incomplete',
                    'Please complete the assessment to continue.',
                    backgroundColor: Colors.orange.shade100,
                    colorText: Colors.black,
                  )
                  // Prevent further navigation
                }
              else
                {onTap(1)}
            },
          ),
          const SizedBox(width: 80), // Spacer for the middle FAB
          navItem(
            imagePath: pageIndex == 2
                ? 'assets/icons/blog/blog1.png'
                : 'assets/icons/blog/blog.png',
            label: "Blogs",
            isSelected: pageIndex == 2,
            onTap: () => {
              if (userData['onboardingScore'] == 0)
                {
                  Get.snackbar(
                    'Assessment Incomplete',
                    'Please complete the assessment to continue.',
                    backgroundColor: Colors.orange.shade100,
                    colorText: Colors.black,
                  )
                  // Prevent further navigation
                }
              else
                {onTap(2)}
            },
          ),
          navItem(
            imagePath: pageIndex == 3
                ? 'assets/icons/profile/profile1.png'
                : 'assets/icons/profile/profile.png',
            label: "Profile",
            isSelected: pageIndex == 3,
            onTap: () => {
              if (userData['onboardingScore'] == 0)
                {
                  Get.snackbar(
                    'Assessment Incomplete',
                    'Please complete the assessment to continue.',
                    backgroundColor: Colors.orange.shade100,
                    colorText: Colors.black,
                  )
                  // Prevent further navigation
                }
              else
                {onTap(3)}
            },
          ),
        ],
      ),
    );
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
                color:
                    isSelected ? ColorPallete.primary : ColorPallete.greyColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
