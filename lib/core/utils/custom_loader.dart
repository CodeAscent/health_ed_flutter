import 'package:flutter/material.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
        color: ColorPallete.whiteShade,
        child: Center(
          child: LoadingAnimationWidget.inkDrop(
            size: 50,
            color: ColorPallete.primary,
          ),
        ));
  }
}
