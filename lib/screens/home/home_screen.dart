import 'package:flutter/material.dart';
import 'package:test_project/core/constants/app_colors.dart';
import 'package:test_project/core/custom_widgets/custom_text.dart';
import 'package:test_project/screens/home/widgets/home_app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: HomeAppBar(),
      body: Center(
        child: CustomText(
          text: "Home Screen",
          textColor: AppColor.textColor,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}


