import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fooddelievery/screens/login.dart';

class PasswordSuccess extends StatefulWidget {
  const PasswordSuccess({super.key});

  @override
  State<PasswordSuccess> createState() => _PasswordSuccessState();
}

class _PasswordSuccessState extends State<PasswordSuccess> {
  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (context) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('lib/assets/Images/illustrations/success.png'),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            Text(
              'Success',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFFD96704),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Text(
              'Your password has been changed successfully',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 126, 124, 123),
              ),
            )
          ],
        ),
      ),
    );
  }
}
