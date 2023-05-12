import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:fooddelievery/screens/passwordsuccess.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  //Initializing the controller
  TextEditingController forgotpswdemailController = TextEditingController();

  //Initializing the firebase auth
  FirebaseAuth auth = FirebaseAuth.instance;

  //Declaring the variables
  bool showLoader = false;
  String status = '';
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
          'Forgot Password',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[900]),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                    ),
                    Image.asset(
                        'lib/assets/Images/illustrations/ForgotPswd.png'),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    const Text(
                      'Forgot your password?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Text(
                      "Enter your registered email to retrieve your password",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600]),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: TextField(
                        controller: forgotpswdemailController,
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
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Bounce(
                        duration: const Duration(milliseconds: 110),
                        onPressed: () {
                          validateData(email: forgotpswdemailController.text);
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
                                      'Next',
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
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                  ],
                ))
          ]),
        ),
      ),
    );
  }

  validateData({required String email}) {
    final validBool = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);

    if (validBool == false) {
      showErrorSnackBar(errormsg: 'Email is not valid');
    } else {
      forgetPassword(email: email);
    }
  }

  //ForgotPassword Method with Firebase
  forgetPassword({required String email}) {
    setState(() {
      showLoader = true;
    });
    auth.sendPasswordResetEmail(email: email).whenComplete(() => {
          showSuccessSnackBar(successmsg: 'Sent Successfully'),
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const PasswordSuccess()),
              (route) => false)
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
}
