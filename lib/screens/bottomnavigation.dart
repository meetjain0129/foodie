import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:fooddelievery/screens/addtocart.dart';
import 'package:fooddelievery/screens/home.dart';
import 'package:fooddelievery/screens/userprofile.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  // DatabaseHelper databaseHelper = DatabaseHelper();
  @override
  void initState() {
    // databaseHelper.createDB();
    super.initState();
  }

  int currentIndex = 0;
  List screenList = const [HomeScreen(), UserProfile()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screenList[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          enableFeedback: true,
          backgroundColor: Colors.white,
          elevation: 40,
          selectedItemColor: const Color(0xFFD96704),
          unselectedItemColor: Color.fromARGB(255, 158, 158, 158),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          iconSize: 28,
          selectedFontSize: 11,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          currentIndex: currentIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.restaurant,
                ),
                label: 'Restaurants'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ]),
      floatingActionButton: Bounce(
        duration: const Duration(milliseconds: 110),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddToCart()));
        },
        child: Material(
          elevation: 20,
          color: Color(0xFFD96704),
          borderRadius: BorderRadius.circular(360),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(360)),
            child: Center(
              child: Icon(
                Icons.shopping_bag,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
