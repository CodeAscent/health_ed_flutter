import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';
import '../../../../core/utils/custom_widgets.dart';
import '../../bloc/language/language_bloc.dart';
import '../../bloc/language/language_event.dart';
import '../../bloc/language/language_state.dart';
import 'login_screen.dart';

class LanguageScreen extends StatelessWidget {
  final List<String> languages = ['English', 'हिंदी', 'ଓଡ଼ିଆ'];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LanguageBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              // Title
              const Text(
                'Choose Language',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // Description
              const Text(
                'Select your preferred language to continue',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),
              // Icon
              Align(
                child: Image.asset(
                  'assets/images/language_icon.png',
                  height: 200,
                ),
              ),
              const SizedBox(height: 40),
              // Radio Group for Languages
              BlocBuilder<LanguageBloc, LanguageState>(
                builder: (context, state) {
                  String selectedLanguage = state is LanguageSelectedState
                      ? state.selectedLanguage
                      : languages[0]; // Default to the first language
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: languages.map((language) {
                      return RadioListTile<String>(
                        title: Text(language),
                        value: language,
                        groupValue: selectedLanguage,
                        onChanged: (value) {
                          if (value != null) {
                            context.read<LanguageBloc>().add(SelectLanguageEvent(value));
                          }
                        },
                        activeColor: ColorPallete.ceruleanBlue, // Change the active radio button color
                      );
                    }).toList(),
                  );
                },
              ),
              const Spacer(),
              // Next Button
              CustomGradientButton(
                label: 'Continue',
                onTap: () {
                  Get.off(() => LoginScreen());
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
