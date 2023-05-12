import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:fooddelievery/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  SharedPreferences? prefs;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
              fontSize: 16),
        ),
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(360),
                    child: Image.network(
                      'https://thumbs.dreamstime.com/b/nice-to-talk-smart-person-indoor-shot-attractive-interesting-caucasian-guy-smiling-broadly-nice-to-112345489.jpg',
                      width: 160,
                      height: 160,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Text(
                  'Your Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Text(
                  'Name',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.008,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: TextField(
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                        hintText: 'Name',
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.grey[200]),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Text(
                  'Email',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.008,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                        hintText: 'Email',
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.grey[200]),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Bounce(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: 45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Color(0xFFD96704)),
                        child: Center(
                          child: Text(
                            'Update',
                            style: TextStyle(
                              color: Colors.grey[200],
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      duration: const Duration(milliseconds: 110),
                      onPressed: () {
                        updateData();
                      }),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Align(alignment: Alignment.center, child: Text('OR')),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Bounce(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: 45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(width: 2, color: Colors.red)),
                        child: Center(
                          child: Text(
                            'Log out',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      duration: const Duration(milliseconds: 110),
                      onPressed: () {
                        FirebaseAuth.instance.signOut().whenComplete(() => {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()),
                                  (route) => false)
                            });
                      }),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                )
              ],
            ),
          )),
    );
  }

  getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? userEmail = sharedPreferences.getString('userEmail');
    final String? userName = sharedPreferences.getString('userName');

    nameController.text = userName!;
    emailController.text = userEmail!;
  }

  updateData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? userEmail = sharedPreferences.getString('userEmail');
    final String? userName = sharedPreferences.getString('userName');
    String userUid = '', tempEmail = userEmail!;
    String updatedUserName = '', updatedUserEmail = '';
    CollectionReference reference =
        await FirebaseFirestore.instance.collection('Users');

    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Users').get();

    for (int i = 0; i < snapshot.docs.length; i++) {
      if (snapshot.docs[i]['userEmail'] == tempEmail) {
        userUid = snapshot.docs[i].id;
        updatedUserEmail = snapshot.docs[i]['userName'];
        updatedUserName = snapshot.docs[i]['userEmail'];
      }
    }

    print(userUid);
    await reference.doc(userUid).update({
      'userEmail': emailController.text,
      'userName': nameController.text
    }).whenComplete(() async {
      await sharedPreferences.setString('userEmail', emailController.text);
      await sharedPreferences.setString('userName', nameController.text);
      setState(() {
        getData();
      });
      showSuccessSnackBar(successmsg: 'Updated Successfully');
    });
  }

  //Show Success Snack bar
  showSuccessSnackBar({required String successmsg}) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(successmsg),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.green,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    ));
  }
}
