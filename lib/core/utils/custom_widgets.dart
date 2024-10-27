import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';
import 'package:health_ed_flutter/core/utils/custom_snackbar.dart';

class CustomTextFieldWithLabel extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String hintText;
  final Widget? sufix;
  final bool? readOnly;
  final bool? isPassword;
  const CustomTextFieldWithLabel(
      {super.key,
      required this.label,
      this.controller,
      required this.hintText,
      this.sufix,
      this.readOnly = false,
      this.isPassword = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(label,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        SizedBox(height: 10),
        TextFormField(
          validator: (value) {
            if (controller!.text == '') {
              customSnackbar(
                  'Please enter a valid $label', ContentType.failure);
            } else {
              return null;
            }
          },
          obscureText: isPassword!,
          readOnly: readOnly!,
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: sufix,
            fillColor: Colors.white,
            filled: true
          ),
          controller: controller,

        ),
      ],
    );
  }
}

class CustomMobileTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String hintText;
  final Widget? sufix;
  final bool? readOnly;
  final bool? isPassword;
  const CustomMobileTextField(
      {super.key,
        required this.label,
        this.controller,
        required this.hintText,
        this.sufix,
        this.readOnly = false,
        this.isPassword = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Row(
          children: [
          TextFormField(
            validator: (value) {
              if (controller!.text == '') {
                customSnackbar(
                    'Please enter a valid $label', ContentType.failure);
              } else {
                return null;
              }
            },
            obscureText: isPassword!,
            readOnly: readOnly!,
            decoration: InputDecoration(
                hintText: hintText,
                suffixIcon: sufix,
                fillColor: Colors.white,
                filled: true
            ),
            controller: controller,

          ),
        ],)

      ],
    );
  }
}


class CustomTransparentContainer extends StatelessWidget {
  final Widget child;
  const CustomTransparentContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: Get.width,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.93),  // Apply opacity only to the background color
          borderRadius: BorderRadius.circular(25),
        ),
        child: child,
      ),
    );
  }
}


class AppBackButton extends StatelessWidget {
  final Color? color;
  const AppBackButton({
    super.key,
    this.color
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {},
        icon: CircleAvatar(
          backgroundColor: color != null?color: ColorPallete.grayBlue,
          child: Icon(
            Icons.navigate_before,
            color: Colors.black,
          ),
        ));
  }
}
class AppGreyBackButton extends StatelessWidget {
  const AppGreyBackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {},
        icon: CircleAvatar(
          backgroundColor: ColorPallete.grayBlue,
          child: Icon(
            size: 40,
            Icons.navigate_before,
            color:ColorPallete.primary,
          ),
        ));
  }
}

class CustomGradientButton extends StatelessWidget {
  final String label;
  final bool? isDisabled;
  final void Function()? onTap;
  const CustomGradientButton({
    super.key,
    required this.label,
    this.onTap,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 47,
        child: Center(
            child: Text(
          label,
          style: TextStyle(
            color: isDisabled! ? Colors.black : Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        )),
        decoration: BoxDecoration(
            gradient: isDisabled! ? null : ColorPallete.gradient,
            borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
