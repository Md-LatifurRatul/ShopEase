import 'package:e_commerce_project/controllers/services/auth_exception.dart';
import 'package:e_commerce_project/controllers/services/firebase_auth_service.dart';
import 'package:e_commerce_project/screens/authentication/sign_up_screen.dart';
import 'package:e_commerce_project/screens/home/home_screen.dart';
import 'package:e_commerce_project/widgets/custom_auth_elevated_button.dart';
import 'package:e_commerce_project/widgets/login_header.dart';
import 'package:e_commerce_project/widgets/toast_meesage.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  final _firebaseAuthService = FirebaseAuthService();

  Future<void> _signInUser() async {
    try {
      final user = await _firebaseAuthService.signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      print(user);
      if (mounted) {
        ToastMeesage.showToastMessage(context, "Sign in success");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (copntext) => const HomeScreen()),
        );
      }
    } on AuthException catch (e) {
      print("Sign in error: ${e.message}");

      if (mounted) {
        ToastMeesage.showToastMessage(context, "Sign in failed: ${e.message}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,

        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.center,
            colors: [Colors.cyan[500]!, Colors.cyan[300]!, Colors.cyan[500]!],
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 80),

            LoginHeader(),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),

                child: inputWrapper(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget inputWrapper() {
    return Padding(
      padding: EdgeInsets.all(30),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 48),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: loginInputField(),
              ),

              SizedBox(height: 40),

              // Text("Forgot Password?", style: TextStyle(color: Colors.grey)),
              SizedBox(height: 40),
              CustomAuthElevatedButton(
                buttonName: "Login",
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _signInUser();
                  }
                },
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't Have Account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      );
                    },
                    child: const Text("Sign-up"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget loginInputField() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),

          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
          ),
          child: TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              hintText: "Enter your email",

              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return "Please Enter your email";
              }
              return null;
            },
          ),
        ),

        Container(
          padding: EdgeInsets.all(10),

          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
          ),
          child: TextFormField(
            keyboardType: TextInputType.visiblePassword,
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              hintText: "Enter your password",
              suffixIcon: IconButton(
                onPressed: () {
                  _changeObsecure(_obscurePassword);
                },
                icon: _changeObsecureIcon(_obscurePassword),
              ),

              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return "Please Enter your password";
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Icon _changeObsecureIcon(bool value) {
    return value
        ? const Icon(Icons.visibility_outlined)
        : const Icon(Icons.visibility_off_outlined);
  }

  void _changeObsecure(bool value) {
    setState(() {
      _obscurePassword = !value;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
