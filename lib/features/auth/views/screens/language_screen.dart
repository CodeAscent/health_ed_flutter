import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:health_ed_flutter/features/auth/views/screens/signup_screen.dart';
import '../../../../core/utils/custom_widgets.dart';
import '../../bloc/language/language_bloc.dart';
import '../../bloc/language/language_event.dart';
import '../../bloc/language/language_state.dart';
import 'login_screen.dart';

class LanguageScreen extends StatelessWidget {
  final List<String> languages = ['English', 'Hindi', 'Odia'];

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
              // Language Dropdown with shadow
              BlocBuilder<LanguageBloc, LanguageState>(
                builder: (context, state) {
                  String selectedLanguage = state is LanguageSelectedState
                      ? state.selectedLanguage
                      : 'Select language';
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),  // Add padding here
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3), // Shadow positioning
                            ),
                          ],
                        ),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: selectedLanguage == 'Select language' ? null : selectedLanguage,
                          hint: const Text('Select language'),
                          items: languages.map((String language) {
                            return DropdownMenuItem<String>(
                              value: language,
                              child: Text(language),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              context.read<LanguageBloc>().add(SelectLanguageEvent(value));
                            }
                          },
                          // Custom Dropdown Arrow
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.black,
                            size: 24,
                          ),
                          dropdownColor: Colors.white,
                          itemHeight: 50,
                          menuMaxHeight: 200,
                          elevation: 2,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const Spacer(),
              // Next Button
              CustomGradientButton(
                label: 'Continue',
                onTap: () {
                  Get.off(() =>LoginScreen());
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
