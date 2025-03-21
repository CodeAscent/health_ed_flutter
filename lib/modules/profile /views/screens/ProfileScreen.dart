import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';
import 'package:health_ed_flutter/modules/auth/views/screens/language_screen.dart';
import 'package:health_ed_flutter/modules/auth/views/screens/login_screen.dart';

import '../../../../core/local/local_storage.dart';
import '../../../../core/utils/custom_widgets.dart';
import '../../bloc/profile_cubit.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit()..loadUserData(),
      child: SafeArea(
        child: BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state) {
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
        Get.offAll(() => LanguageScreen());
      },
      style: TextButton.styleFrom(
        backgroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                            alignment: Alignment.centerLeft,
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.grey[300],
                                  child: Icon(
                                    Icons.person,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: ColorPallete.primary,
                                  child: Icon(
                                    Icons.edit_note_sharp,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          _buildTextField(
                            label: 'Name',
                            initialValue: state.name,
                            onChanged: (value) => context.read<ProfileCubit>().updateName(value),
                          ),
                          SizedBox(height: 10),
                          _buildTextField(
                            label: 'Phone number',
                            initialValue: state.phoneNumber,
                            onChanged: (value) => context.read<ProfileCubit>().updatePhoneNumber(value),
                            suffixIcon: state.isPhoneValid ? Icons.check : null,
                          ),
                          SizedBox(height: 10),
                          _buildTextField(
                            label: 'Email',
                            initialValue: state.email,
                            onChanged: (value) => context.read<ProfileCubit>().updateEmail(value),
                            suffixIcon: state.isEmailValid ? Icons.check : null,
                          ),
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
