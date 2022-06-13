import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:services_catalog/authentication/add_user_page.dart';
import 'package:services_catalog/fire_base/fire_base.dart';

import 'package:services_catalog/text_field.dart';


class AuthenticationScreen extends StatefulWidget {
  static const String id = "authentication";

  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;

  set loading(bool value) => setState(() {
    _loading = value;
  });

  bool get loading => _loading;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Authentication"),
      ),
      // backgroundColor: widget.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),

        child: Column(
          children: [
            MyTextField(
              controller: _emailController,
              hintText: "something@email.com",
              labelText: "Email",
              keyboardType: TextInputType.emailAddress,
            ),

            SizedBox(height: MediaQuery.of(context).size.height / 35),

            MyTextField(
              controller: _passwordController,
              hintText: "password",
              labelText: "Password",
              obscureText: true,
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 30),

            TextButton(
              onPressed: trySignIn,
              child: const Text("Sign In"),
            ),

            TextButton(
              onPressed: tryRegister,
              child: const Text("Register"),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 35),

            if (_loading) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  static final _fireAuthErrorMapping = {
    "weak-password": "The password provided is too weak",
    "email-already-in-use": "The account already exists for that email",
    "invalid-email": "Invalid email format",
  };

  void trySignIn() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;
    loading = true;
    final success = await signIn(email, password);
    loading = false;
    if(!success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid login")));
      return;
    }
    Navigator.of(context).pop();
  }

  void tryRegister() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    loading = true;
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      loading = false;
      String message = _fireAuthErrorMapping[e.code] ?? "Unspecified error occurred";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      return;
    }

    loading = false;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => AddUserPage()),
    );
  }
}