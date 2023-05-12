import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:fooddelievery/screens/bottomnavigation.dart';
import 'package:fooddelievery/screens/forgotpswd.dart';
import 'package:fooddelievery/screens/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Declaring the user
  User? user;

  //Initializing firebase auth
  FirebaseAuth auth = FirebaseAuth.instance;

  //Declaring the controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //Declaring the variables
  bool showLoader = false,
      isTextFieldReadOnly = false,
      hidePasswordText = true,
      passwordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            splashRadius: 20,
            color: Colors.grey[700],
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const OnBoardingScreen()),
                  (route) => false);
            },
            icon: const Icon(Icons.arrow_back)),
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Login',
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
              Image.asset('lib/assets/Images/illustrations/Login.png'),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Text(
                'Sign In to continue',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[900]),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Text(
                'Enter your credentials to get the access of your account',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600]),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  textAlignVertical: TextAlignVertical.center,
                  readOnly: isTextFieldReadOnly,
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
                  readOnly: isTextFieldReadOnly,
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
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ForgotPassword()));
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                          color: Color(0xFFD96704),
                          fontWeight: FontWeight.w500),
                    )),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Bounce(
                  duration: const Duration(milliseconds: 110),
                  onPressed: () {
                    validateAndLoginData();
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
                                'Login Now',
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
                    'or sign in with',
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

  //Validate email and password field
  validateAndLoginData() {
    String email = emailController.text, password = passwordController.text;

    bool validEmail = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);

    if (validEmail == false) {
      showErrorSnackBar(
          errormsg: 'E-mail is not valid, check your email and try again');
    } else if (password.trim().length < 8) {
      showErrorSnackBar(
          errormsg: 'Password length should be more than 8 characters');
    } else {
      signInData(email: email, password: password);
    }
  }

  //Signing Data with Firebase
  signInData({required String email, required String password}) async {
    setState(() {
      showLoader = true;
      isTextFieldReadOnly = true;
    });
    try {
      UserCredential userCredential = await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .whenComplete(() => fetchData(email: email));
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showErrorSnackBar(
            errormsg: 'There is no acount, Try again with diffenent email');
        setState(() {
          showLoader = false;
          isTextFieldReadOnly = false;
        });
      } else if (e.code == 'wrong-password') {
        showErrorSnackBar(errormsg: 'Check your password and try again');
        setState(() {
          showLoader = false;
          isTextFieldReadOnly = false;
        });
      }
    } catch (e) {
      showErrorSnackBar(errormsg: e.toString());
      setState(() {
        showLoader = false;
        isTextFieldReadOnly = false;
      });
    }

    if (user != null) {
      showSuccessSnackBar(successmsg: 'Signed In Successfully');
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavigation()),
          (route) => false);
    }
  }

  //Fetching user data
  fetchData({required String email}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Users').get();

    for (int i = 0; i < snapshot.docs.length; i++) {
      if (snapshot.docs[i]['userEmail'] == email) {
        await prefs.setString('userEmail', snapshot.docs[i]['userEmail']);
        await prefs.setString('userName', snapshot.docs[i]['userName']);
      }
    }
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
