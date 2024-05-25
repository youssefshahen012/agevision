import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theming/styles.dart';

class TermsAndConditionsText extends StatelessWidget {
  const TermsAndConditionsText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: 'By logging, you agree to our',
              style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold)
          ),
          TextSpan(
            text: ' Terms & Conditions',
              style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold)
          ),
          TextSpan(
            text: ' and',
            style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold)
                .copyWith(height: 4.h),
          ),
          TextSpan(
            text: ' PrivacyPolicy.',
              style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold)
          ),
        ],
      ),
    );
  }
}
