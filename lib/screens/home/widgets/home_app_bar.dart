import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/custom_widgets/custom_text.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget{
  const HomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: CustomText(
        text: "Home Screen",
        textColor: AppColor.textColor,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      centerTitle: true,
      backgroundColor: AppColor.background,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}