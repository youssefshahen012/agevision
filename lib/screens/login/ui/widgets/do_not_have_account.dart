import 'package:flutter/material.dart';

import '../../../../helpers/extensions.dart';
import '../../../../routing/routes.dart';
import '../../../../theming/styles.dart';

class DoNotHaveAccountText extends StatelessWidget {
  const DoNotHaveAccountText({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(Routes.signupScreen);
      },
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an account ?',
              style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: ' Sign Up',
              style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
