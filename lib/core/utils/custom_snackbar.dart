import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

customSnackbar(String message, ContentType type) async {
  toastification.dismissAll();

  toastification.show(
    type: ToastificationType.error,
    style: ToastificationStyle.flatColored,
    autoCloseDuration: const Duration(seconds: 5),
    title: Text(
      type == ContentType.failure ? "Failure" : "Success",
      style: TextStyle(fontWeight: FontWeight.w800, color: Colors.black),
    ),
    description: RichText(
        text: TextSpan(text: message, style: TextStyle(color: Colors.black))),
    alignment: Alignment.topRight,
    direction: TextDirection.ltr,
    animationDuration: const Duration(milliseconds: 300),

    icon: type == ContentType.failure
        ? const Icon(Icons.error)
        : const Icon(CupertinoIcons.check_mark),

    showIcon: true, // show or hide the icon
    primaryColor: type == ContentType.failure ? Colors.red : Colors.green,
    backgroundColor: type == ContentType.failure ? Colors.red : Colors.green,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    borderRadius: BorderRadius.circular(12),

    showProgressBar: false,
    pauseOnHover: true,
    dragToClose: true,
    applyBlurEffect: true,
  );
}

enum ContentType { failure, success }
