import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:health_ed_flutter/core/utils/custom_constants.dart';
import 'package:health_ed_flutter/core/utils/custom_loader.dart';
import 'package:health_ed_flutter/core/utils/custom_snackbar.dart';
import 'package:health_ed_flutter/core/utils/custom_widgets.dart';
import 'package:health_ed_flutter/features/auth/bloc/auth_bloc.dart';
import 'package:health_ed_flutter/features/auth/views/screens/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formKey = GlobalKey<FormState>();
  final _fullname = TextEditingController();
  final _dob = TextEditingController();
  final _gender = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _email = TextEditingController();
  final _unformattedDob = TextEditingController();
  bool showPassword = false;

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
            Get.to(() => LoginScreen());
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return CustomLoader();
          }

          return Scaffold(
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
                        AppBackButton(),
                        CustomTransparentContainer(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Create Account',
                                  style: kCustomHeadingTS(),
                                ),
                                Text('Join us & start your learning journey'),
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
                                  label: 'Birthdate',
                                  hintText: 'DD/MM/YYYY',
                                  readOnly: true,
                                  sufix: kCustomDatePicker(context),
                                ),
                                CustomTextFieldWithLabel(
                                  controller: _gender,
                                  label: 'Gender',
                                  hintText: 'Select your gender',
                                  readOnly: true,
                                  sufix: kGenderPicker(context),
                                ),
                                CustomTextFieldWithLabel(
                                  isPassword: !showPassword,
                                  controller: _password,
                                  label: 'Password',
                                  hintText: 'Enter your password',
                                  sufix: kShowPassword(),
                                ),
                                CustomTextFieldWithLabel(
                                  isPassword: !showPassword,
                                  controller: _confirmPassword,
                                  label: 'Confirm Password',
                                  hintText: 'Confirm your password',
                                  sufix: kShowPassword(),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                CustomGradientButton(
                                  label: 'Continue',
                                  onTap: () {
                                    if (formKey.currentState!.validate()) {
                                      if (_password.text !=
                                          _confirmPassword.text) {
                                        customSnackbar(
                                            'Passwords does not match',
                                            ContentType.failure);
                                        return;
                                      } else {
                                        context.read<AuthBloc>().add(
                                              AuthRegistrationRequested(
                                                email: _email.text,
                                                password: _password.text,
                                                fullName: _fullname.text,
                                                gender: _gender.text,
                                                dob: _unformattedDob
                                                    .text, // Ensure this is properly formatted (e.g., DD/MM/YYYY)
                                              ),
                                            );
                                      }
                                    }
                                  },
                                ),
                                SizedBox(height: 10),
                                Center(
                                  child: Text.rich(
                                    TextSpan(
                                        text: 'Already have an account? ',
                                        children: [
                                          TextSpan(
                                            text: 'Login',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w900),
                                            onEnter: (event) {},
                                          )
                                        ]),
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
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

  IconButton kShowPassword() {
    return IconButton(
        onPressed: () {
          setState(() {
            showPassword = !showPassword;
          });
        },
        icon:
            showPassword ? Icon(Icons.visibility) : Icon(Icons.visibility_off));
  }

  IconButton kCustomDatePicker(BuildContext context) {
    return IconButton(
        onPressed: () async {
          final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now());
          if (date != null) {
            _unformattedDob.text = date.toString();
            _dob.text = customDateFormat(date.toString());
          }
        },
        icon: Icon(Icons.calendar_month));
  }

  IconButton kGenderPicker(BuildContext context) {
    return IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                  title: Row(
                    children: [
                      Text('Gender'),
                      Spacer(),
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            CupertinoIcons.xmark,
                            size: 35,
                          ))
                    ],
                  ),
                  content: SizedBox(
                    height: 180,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomGradientButton(
                          onTap: () {
                            setState(() {
                              _gender.text = 'MALE';
                            });
                          },
                          label: 'MALE',
                          isDisabled: _gender.text != 'MALE',
                        ),
                        SizedBox(height: 10),
                        CustomGradientButton(
                          onTap: () {
                            setState(() {
                              _gender.text = 'FEMALE';
                            });
                          },
                          label: 'FEMALE',
                          isDisabled: _gender.text != 'FEMALE',
                        )
                      ],
                    ),
                  ),
                );
              });
            },
          );
        },
        icon: Icon(Icons.arrow_downward));
  }

  TextStyle kCustomHeadingTS() {
    return TextStyle(fontSize: 25, fontWeight: FontWeight.w800);
  }
}
