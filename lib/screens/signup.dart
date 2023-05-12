import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fooddelievery/screens/bottomnavigation.dart';
import 'package:fooddelievery/screens/location/asklocation.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //Declaring the user
  User? user;

  //Initializing firebase auth
  FirebaseAuth auth = FirebaseAuth.instance;

  //Declaring the controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //Declaring the variables
  bool showLoader = false,
      isTextFieldReadOnly = false,
      hidePasswordText = true,
      isEmailExists = false,
      passwordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            splashRadius: 20,
            color: Colors.grey[700],
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Sign Up',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[900]),
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
              Image.asset('lib/assets/Images/illustrations/Register.png'),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Text(
                'Sign Up',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[900]),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Text(
                'Make your profile to taste 1000 of restaurants',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600]),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: TextField(
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                      hintText: 'Name',
                      prefixIcon: const Icon(
                        Icons.person_2,
                        color: Color(0xFFF28705),
                      ),
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.grey[200]),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                      hintText: 'Email',
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Color(0xFFF28705),
                      ),
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.grey[200]),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: TextField(
                  controller: passwordController,
                  keyboardType: TextInputType.emailAddress,
                  textAlignVertical: TextAlignVertical.center,
                  obscureText: hidePasswordText,
                  decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Color(0xFFF28705),
                      ),
                      suffixIcon: IconButton(
                          onPressed: () {
                            getPasswordVisible();
                          },
                          color: Colors.grey[400],
                          icon: Icon(passwordVisible == true
                              ? Icons.visibility
                              : Icons.visibility_off)),
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.grey[200]),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Bounce(
                  duration: const Duration(milliseconds: 110),
                  onPressed: () {
                    validateAndCreateAccount();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xFFD96704),
                    ),
                    child: Center(
                        child: showLoader == true
                            ? const SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Sign up Now',
                                style: TextStyle(
                                  color: Colors.grey[200],
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Divider(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    'or sign up with',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Divider(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Bounce(
                    onPressed: () {
                      showSuccessSnackBar(successmsg: 'Coming soon');
                    },
                    duration: const Duration(milliseconds: 110),
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 45,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Icon(
                              Icons.g_mobiledata,
                              size: 35,
                              color: Colors.red,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                'Sign in with Google',
                                style: TextStyle(color: Colors.black),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  //Validating the user's data
  validateAndCreateAccount() {
    String userName = nameController.text,
        email = emailController.text,
        password = passwordController.text;
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);

    if (userName.trim().toString() == '' ||
        password.trim().toString().length < 8) {
      showErrorSnackBar(
          errormsg: 'Your inputs does not match our credential rules');
    } else if (emailValid == false) {
      showErrorSnackBar(errormsg: 'Email is not valid');
    } else {
      signUpData(userName: userName, email: email, password: password);
    }
  }

  //SignUp data to the firebase
  signUpData(
      {required String userName,
      required String email,
      required String password}) async {
    setState(() {
      showLoader = true;
      isTextFieldReadOnly = true;
    });
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        setState(() {
          showLoader = false;
          isEmailExists = true;
          isTextFieldReadOnly = false;
        });
        if (isEmailExists == true) {
          showErrorSnackBar(errormsg: 'Your email is already exists');
        }
      }
    } catch (e) {
      setState(() {
        showLoader = false;
        isTextFieldReadOnly = false;
      });
      showErrorSnackBar(errormsg: e.toString());
    }

    if (isEmailExists == false) {
      addUser(userName: userName, email: email);
    }

    isEmailExists = false;
  }

  //Add user-data to the cloud firestore
  addUser({required String userName, required String email}) {
    CollectionReference reference =
        FirebaseFirestore.instance.collection('Users');

    reference
        .add({'userName': userName, 'userEmail': email})
        .whenComplete(() => {
              showLoader = false,
              isTextFieldReadOnly = false,
              showSuccessSnackBar(
                  successmsg: 'Your account has been created successfully'),
              openHome(),
            })
        .whenComplete(() =>
            addDataToSharedPreferences(userName: userName, userEmail: email));
  }

  addDataToSharedPreferences(
      {required String userName, required String userEmail}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('userName', '$userName');
    await prefs.setString('userEmail', '$userEmail');
  }

  //For Location
  openHome() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _permissionGranted = await location.hasPermission();

    if (_permissionGranted == PermissionStatus.granted) {
      return Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavigation()),
          (route) => false);
    } else {
      return Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AskLocation()),
          (route) => false);
    }
  }

  //Show Error Snack bar
  showErrorSnackBar({required String errormsg}) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(errormsg),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.red,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    ));
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

  //Method for show password
  getPasswordVisible() {
    setState(() {
      if (passwordVisible == false) {
        passwordVisible = true;
      } else {
        passwordVisible = false;
      }

      if (passwordVisible == true) {
        hidePasswordText = false;
      } else {
        hidePasswordText = true;
      }
    });
  }

  // //Method for signing with google
  // Future<User?> signInWithGoogle() async {
  //   User? user;
  //   final GoogleSignInAccount? googleSignInAccount =
  //       await GoogleSignIn().signIn();

  //   if (googleSignInAccount != null) {
  //     final GoogleSignInAuthentication? googleAuth =
  //         await googleSignInAccount.authentication;

  //     final crendential = GoogleAuthProvider.credential(
  //         accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

  //     try {
  //       final UserCredential userCredential =
  //           await auth.signInWithCredential(crendential).whenComplete(() => {
  //                 Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                         builder: (context) => const BottomNavigation()))
  //               });

  //       user = userCredential.user;
  //     } on FirebaseAuthException catch (e) {
  //       if (e.code == 'account-exists-with-different-credential') {
  //         showErrorSnackBar(errormsg: 'Credentials are not appropriate');
  //       } else if (e.code == 'invalid-credential') {
  //         showErrorSnackBar(errormsg: 'Invalid Credentials');
  //       }
  //     } catch (e) {
  //       showErrorSnackBar(errormsg: '$e');
  //     }
  //   }

  //   return user;
  // }
}
