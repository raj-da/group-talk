import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grouptalk/core/theme/app_colors.dart';

Widget googleBotton({required String text}) {
  return SizedBox(
    width: double.infinity,
    height: 48,
    child: OutlinedButton(onPressed: () {}, 
    
    style: OutlinedButton.styleFrom(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12)
      )
    ),
    child: Text(text)),
  );
}
