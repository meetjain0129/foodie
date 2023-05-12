import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fooddelievery/screens/bottomnavigation.dart';
import 'package:fooddelievery/screens/onboarding.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      user != null
          ? Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const BottomNavigation()),
              (context) => false)
          : Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const OnBoardingScreen()),
              (context) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: const Color(0xFFD96704),
        child: const Center(
          child: Text(
            'Foodie',
            style: TextStyle(
                fontSize: 24, color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
