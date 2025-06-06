import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';
import 'package:health_ed_flutter/modules/auth/views/screens/login_screen.dart';
import 'package:health_ed_flutter/modules/profile%20/views/screens/ReportPreviewScreen.dart';

import '../../../../core/local/local_storage.dart';
import '../../../../core/utils/custom_widgets.dart';
import '../../bloc/profile_cubit.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfilescreenState createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<ProfileScreen> {
  int _activeDayIndex = 0;

  void _downloadReport(String userId) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReportViewerPage(
          userId: userId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var userData = LocalStorage.prefs.getString('userProfileData') != null
        ? jsonDecode(LocalStorage.prefs.getString('userProfileData')!)['user']
        : '';
    return BlocProvider(
      create: (_) => ProfileCubit()..loadUserData(),
      child: SafeArea(
        child:
            BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state) {
          return Scaffold(
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Profile',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await LocalStorage.removeUserData();
                                  Get.offAll(() => LoginScreen());
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'Sign Out',
                                  style: TextStyle(
                                    color: ColorPallete.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(
                                    userData['gender'] == 'Male'
                                        ? 'assets/icons/boy.png'
                                        : 'assets/icons/girl.png',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          _buildTextField(
                            label: 'Name',
                            initialValue: userData['fullName'] ?? '',
                            onChanged: (value) =>
                                context.read<ProfileCubit>().updateName(value),
                            suffixIcon: Icons.check,
                          ),
                          SizedBox(height: 10),
                          _buildTextField(
                            label: 'Phone number',
                            initialValue: userData['mobile'] ?? '',
                            onChanged: (value) => context
                                .read<ProfileCubit>()
                                .updatePhoneNumber(value),
                            suffixIcon: Icons.check,
                          ),
                          SizedBox(height: 10),
                          _buildTextField(
                            label: 'Email',
                            initialValue: userData['email'] ?? '',
                            onChanged: (value) =>
                                context.read<ProfileCubit>().updateEmail(value),
                            suffixIcon: Icons.check,
                          ),
                          SizedBox(height: 10),
                          _buildTextField(
                            label: 'Gender',
                            initialValue: userData['gender'] ?? '',
                            onChanged: (value) =>
                                context.read<ProfileCubit>().updateEmail(value),
                            suffixIcon: Icons.check,
                          ),
                          SizedBox(height: 40),
                          Center(
                            child: TextButton.icon(
                              onPressed: () {
                                if (userData['onboardingScore'] == 0) {
                                  Get.snackbar(
                                    'Assessment Incomplete',
                                    'Please complete the assessment to continue.',
                                    backgroundColor: Colors.orange.shade100,
                                    colorText: Colors.black,
                                  );
                                  // Prevent further navigation
                                } else {
                                  _downloadReport(userData['_id']);
                                }
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              icon: Icon(Icons.download,
                                  color: ColorPallete.primary),
                              label: Text(
                                'Download Report',
                                style: TextStyle(
                                  color: ColorPallete.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    required ValueChanged<String> onChanged,
    IconData? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey[600]),
        ),
        SizedBox(height: 5),
        TextField(
          onChanged: onChanged,
          enabled: false,
          controller: TextEditingController()..text = initialValue,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: ColorPallete.primary, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: ColorPallete.greyShade1, width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: ColorPallete.greyShade1, width: 1),
            ),
            suffixIcon: suffixIcon != null
                ? Icon(suffixIcon, color: Colors.green)
                : null,
          ),
        ),
      ],
    );
  }
}
