import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:health_ed_flutter/core/style/text_style.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';
import 'package:health_ed_flutter/core/utils/custom_constants.dart';
import 'package:health_ed_flutter/core/utils/custom_loader.dart';
import 'package:health_ed_flutter/core/utils/custom_snackbar.dart';
import 'package:health_ed_flutter/core/utils/custom_widgets.dart';
import 'package:health_ed_flutter/modules/auth/bloc/auth_bloc.dart';
import 'package:health_ed_flutter/modules/auth/views/screens/assessment_screen.dart';
import 'package:health_ed_flutter/modules/auth/views/screens/login_screen.dart';
import 'package:health_ed_flutter/modules/auth/views/screens/question_screen.dart';
import 'package:logger/logger.dart';

import '../../models/request/RegistrationRequest.dart';
import '../../repository/auth_repository.dart';
import '../../models/response/StateResponse.dart';
import '../../models/response/CityResponse.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthRepository _authRepository = AuthRepository();
  final formKey = GlobalKey<FormState>();
  final _fullname = TextEditingController();
  final _dob = TextEditingController();
  final _gender = TextEditingController();
  final _familyType = TextEditingController();
  final _email = TextEditingController();
  final _fatherOccupation = TextEditingController();
  final _motherOccupation = TextEditingController();
  final _siblings = TextEditingController();
  final _childLanguage = TextEditingController();
  final _homeLanguage = TextEditingController();
  final _state = TextEditingController();
  final _city = TextEditingController();
  final _speechTherapy = TextEditingController(text: 'No');
  final _medium = TextEditingController(text: 'Online');
  final _unformattedDob = TextEditingController();
  int? stateId;

  List<StateData> states = [];
  List<CityData> cities = [];

  @override
  void initState() {
    super.initState();
    _fetchStates();
  }

  Future<void> _fetchStates() async {
    try {
      final response = await _authRepository.getAllStates();
      setState(() {
        states = response.data;
      });
    } catch (e) {
      customSnackbar("Failed to fetch states $e", ContentType.failure);
    }
  }

  bool validateForm() {
    if (_fullname.text.isEmpty) {
      customSnackbar("Full Name is required", ContentType.failure);
      return false;
    }
    if (_dob.text.isEmpty) {
      customSnackbar("Date of Birth is required", ContentType.failure);
      return false;
    }
    if (_gender.text.isEmpty) {
      customSnackbar("Gender is required", ContentType.failure);
      return false;
    }
    if (_familyType.text.isEmpty) {
      customSnackbar("Family Type is required", ContentType.failure);
      return false;
    }
    if (_fatherOccupation.text.isEmpty) {
      customSnackbar("Father's Occupation is required", ContentType.failure);
      return false;
    }
    if (_motherOccupation.text.isEmpty) {
      customSnackbar("Mother's Occupation is required", ContentType.failure);
      return false;
    }
    if (_siblings.text.isEmpty) {
      customSnackbar("Number of Siblings is required", ContentType.failure);
      return false;
    }
    if (_childLanguage.text.isEmpty) {
      customSnackbar("Child's Language is required", ContentType.failure);
      return false;
    }
    if (_homeLanguage.text.isEmpty) {
      customSnackbar("Home Language is required", ContentType.failure);
      return false;
    }
    if (_state.text.isEmpty) {
      customSnackbar("State is required", ContentType.failure);
      return false;
    }
    if (_city.text.isEmpty) {
      customSnackbar("City is required", ContentType.failure);
      return false;
    }
    if (_speechTherapy.text.isEmpty) {
      customSnackbar(
          "Speech Therapy selection is required", ContentType.failure);
      return false;
    }
    if (_medium.text.isEmpty) {
      customSnackbar("Medium is required", ContentType.failure);
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            customSnackbar(state.message, ContentType.failure);
          }
          if (state is AuthRegisterSuccess) {
            customSnackbar(state.message, ContentType.success);
            Get.to(() => AssessmentScreen());
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return CustomLoader();
          }

          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        'assets/bg/auth_bg.png',
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppBackButton(
                          color: Colors.white,
                        ),
                        CustomTransparentContainer(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Create Account',
                                  style: AppTextStyles.h2,
                                ),
                                Text(
                                  'Join us & start your learning journey',
                                  style: AppTextStyles.h7,
                                ),
                                CustomTextFieldWithLabel(
                                  controller: _fullname,
                                  label: 'Full Name',
                                  hintText: 'Enter your full name',
                                ),
                                CustomTextFieldWithLabel(
                                  controller: _email,
                                  label: 'Email',
                                  hintText: 'Enter your email',
                                ),
                                CustomTextFieldWithLabel(
                                  controller: _dob,
                                  label: 'Date of Birth',
                                  hintText: 'DD/MM/YYYY',
                                  readOnly: true,
                                  onTap: () async {
                                    final date = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime.now());
                                    if (date != null) {
                                      _unformattedDob.text = date.toString();
                                      _dob.text =
                                          customDateFormat(date.toString());
                                    }
                                  },
                                  sufix: Icon(Icons.calendar_month),
                                ),
                                CustomTextFieldWithLabel(
                                  controller: _gender,
                                  label: 'Gender',
                                  hintText: 'Select your gender',
                                  readOnly: true,
                                  onTap: () => _showGenderPicker(context),
                                  sufix: Icon(Icons.arrow_downward),
                                ),
                                CustomTextFieldWithLabel(
                                  controller: _familyType,
                                  label: 'Family Type',
                                  hintText: 'Select Your Family Type',
                                  readOnly: true,
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return StatefulBuilder(
                                            builder: (context, setState) {
                                          return AlertDialog(
                                            title: Row(
                                              children: [
                                                Text('Family Type'),
                                                Spacer(),
                                                IconButton(
                                                  onPressed: () => Get.back(),
                                                  icon: Icon(
                                                      CupertinoIcons.xmark,
                                                      size: 35),
                                                ),
                                              ],
                                            ),
                                            content: SizedBox(
                                              width: double.maxFinite,
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: ['Nuclear', 'Joint']
                                                      .map((option) {
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 5.0),
                                                      child:
                                                          CustomGradientButton(
                                                        onTap: () {
                                                          setState(() {
                                                            _familyType.text =
                                                                option;
                                                          });
                                                          Get.back();
                                                        },
                                                        label: option,
                                                        isDisabled:
                                                            _familyType.text !=
                                                                option,
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                      },
                                    );
                                  },
                                  sufix: Icon(Icons.arrow_downward),
                                ),
                                // New fields added below
                                CustomTextFieldWithLabel(
                                  controller: _fatherOccupation,
                                  label: 'Father Occupation',
                                  hintText: 'Select occupation',
                                  readOnly: true,
                                  sufix: Icon(Icons.arrow_downward),
                                  onTap: () => customPicker(
                                    context: context,
                                    title: 'Father Occupation',
                                    options: [
                                      'Employed',
                                      'Self-employed',
                                      'Unemployed'
                                    ],
                                    controller: _fatherOccupation,
                                  ),
                                ),
                                CustomTextFieldWithLabel(
                                  controller: _motherOccupation,
                                  label: 'Mother Occupation',
                                  hintText: 'Select occupation',
                                  readOnly: true,
                                  sufix: Icon(Icons.arrow_downward),
                                  onTap: () => customPicker(
                                    context: context,
                                    title: 'Mother Occupation',
                                    options: [
                                      'Employed',
                                      'Self-employed',
                                      'Homemaker'
                                    ],
                                    controller: _motherOccupation,
                                  ),
                                ),
                                CustomTextFieldWithLabel(
                                  controller: _siblings,
                                  label: 'No. of Siblings',
                                  hintText: 'Select number',
                                  readOnly: true,
                                  sufix: Icon(Icons.arrow_downward),
                                  onTap: () => customPicker(
                                    context: context,
                                    title: 'No. of Siblings',
                                    options: ['0', '1', '2', '3', '4'],
                                    controller: _siblings,
                                  ),
                                ),
                                CustomTextFieldWithLabel(
                                  controller: _childLanguage,
                                  label: 'Languages Spokenby the Child',
                                  hintText: 'Select language',
                                  readOnly: true,
                                  sufix: Icon(Icons.arrow_downward),
                                  onTap: () => customPicker(
                                    context: context,
                                    title: 'Languages Spoken\nby the Child',
                                    options: ['English', 'Hindi', 'Other'],
                                    controller: _childLanguage,
                                  ),
                                ),
                                CustomTextFieldWithLabel(
                                  controller: _homeLanguage,
                                  label: 'Languages Spoken at Home',
                                  hintText: 'Select language',
                                  readOnly: true,
                                  sufix: Icon(Icons.arrow_downward),
                                  onTap: () => customPicker(
                                    context: context,
                                    title: 'Languages Spoken\nat Home',
                                    options: ['English', 'Hindi', 'Other'],
                                    controller: _homeLanguage,
                                  ),
                                ),
                                CustomTextFieldWithLabel(
                                  controller: _state,
                                  label: 'Current State',
                                  hintText: 'Select your state',
                                  readOnly: true,
                                  sufix: Icon(Icons.arrow_downward),
                                  onTap: () => customPicker(
                                    context: context,
                                    title: 'Current State',
                                    options: states
                                        .map((state) => state.state.toString())
                                        .toList(),
                                    controller: _state,
                                    onSelect: (value) {
                                      final selectedState = states.firstWhere(
                                          (element) => element.state == value);
                                      stateId = selectedState.stateId;
                                      _fetchCities(selectedState.stateId);
                                    },
                                  ),
                                ),
                                CustomTextFieldWithLabel(
                                  controller: _city,
                                  label: 'Current City/District',
                                  hintText: 'Select your city',
                                  readOnly: true,
                                  sufix: Icon(Icons.arrow_downward),
                                  onTap: () {
                                    if (stateId == null) {
                                      customSnackbar(
                                          "Please select a state first",
                                          ContentType.failure);
                                      return;
                                    }
                                    customPicker(
                                      context: context,
                                      title: 'Current City/District',
                                      options: cities
                                          .map((city) => city.city)
                                          .toList(),
                                      controller: _city,
                                    );
                                  },
                                ),
                                CustomTextFieldWithLabel(
                                  controller: _speechTherapy,
                                  label: 'Speech Therapy',
                                  hintText: 'Yes or No',
                                  readOnly: true,
                                  sufix: Icon(Icons.arrow_downward),
                                  onTap: () => customPicker(
                                    context: context,
                                    title: 'Speech Therapy',
                                    options: ['Yes', 'No'],
                                    controller: _speechTherapy,
                                  ),
                                ),
                                CustomTextFieldWithLabel(
                                  controller: _medium,
                                  label: 'Medium',
                                  hintText: 'Select medium',
                                  readOnly: true,
                                  sufix: Icon(Icons.arrow_downward),
                                  onTap: () => customPicker(
                                    context: context,
                                    title: 'Medium',
                                    options: ['Online', 'Offline'],
                                    controller: _medium,
                                  ),
                                ),
                                SizedBox(height: 30),
                                CustomGradientButton(
                                  label: 'Continue',
                                  onTap: () {
                                    if (validateForm()) {
                                      final registrationRequest =
                                          RegistrationRequest(
                                        fullName: _fullname.text,
                                        familyType: _familyType.text,
                                        email: _email.text,
                                        dateOfBirth: _unformattedDob.text,
                                        fatherOccupation:
                                            _fatherOccupation.text,
                                        motherOccupation:
                                            _motherOccupation.text,
                                        noOfSiblings:
                                            int.tryParse(_siblings.text) ?? 0,
                                        languageSpokenByChild:
                                            _childLanguage.text,
                                        languageSpokenAtHome:
                                            _homeLanguage.text,
                                        currentCityDistrict: _city.text,
                                        currentState: _state.text,
                                        isChildTakingSpeechTherapy:
                                            _speechTherapy.text == 'Yes',
                                        medium: _medium.text,
                                        gender: _gender.text,
                                        preferredLanguage: 'en',
                                      );
                                      context.read<AuthBloc>().add(
                                          AuthRegistrationRequested(
                                              registrationRequest));
                                    }
                                  },
                                ),
                                SizedBox(height: 10),
                                Center(
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'Already have an account? ',
                                      style: TextStyle(color: Colors.black),
                                      children: [
                                        TextSpan(
                                          text: 'Login',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            color: ColorPallete.primary,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Get.to(() => LoginScreen());
                                            },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 40),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  )),
            ),
          );
        },
      ),
    );
  }

  void customPicker({
    required BuildContext context,
    required String title,
    required List<String> options,
    required TextEditingController controller,
    Function(String)? onSelect,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Row(
              children: [
                Text(title),
                Spacer(),
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    CupertinoIcons.xmark,
                    size: 35,
                  ),
                ),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite, // Ensures dialog takes full width
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize
                      .min, // Allow the column to take up minimum height
                  children: options.map((option) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: CustomGradientButton(
                        onTap: () {
                          setState(() {
                            controller.text = option;
                          });
                          onSelect?.call(option);
                          Get.back(); // Close the dialog on selection
                        },
                        label: option,
                        isDisabled: controller.text != option,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        });
      },
    );
  }

  TextStyle kCustomHeadingTS() {
    return TextStyle(fontSize: 25, fontWeight: FontWeight.w800);
  }

  void _showGenderPicker(BuildContext context) {
    customPicker(
      context: context,
      title: 'Gender',
      options: ['Male', 'Female', 'Other'],
      controller: _gender,
    );
  }

  Future<void> _fetchCities(int stateId) async {
    try {
      final response = await _authRepository.getCitiesByStateId(stateId);
      setState(() {
        cities = response.data;
      });
    } catch (e) {
      customSnackbar("Failed to fetch cities", ContentType.failure);
    }
  }
}
