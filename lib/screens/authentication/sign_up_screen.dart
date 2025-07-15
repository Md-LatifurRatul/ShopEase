import 'package:e_commerce_project/controllers/services/auth_exception.dart';
import 'package:e_commerce_project/controllers/services/firebase_auth_service.dart';
import 'package:e_commerce_project/screens/authentication/login_screen.dart';
import 'package:e_commerce_project/widgets/custom_auth_elevated_button.dart';
import 'package:e_commerce_project/widgets/toast_meesage.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final FocusNode _focusEmailNode = FocusNode();
  final FocusNode _focusPasswordNode = FocusNode();
  final FocusNode _focusConfirmPasswordNode = FocusNode();

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _firebaseAuthService = FirebaseAuthService();

  bool _obscurePassword = true;
  bool _obscurefinalPassword = true;

  Future<void> _signUpUser() async {
    try {
      final user = await _firebaseAuthService.createUserWithEmailAndPassword(
        _emailNameController.text.trim(),
        _passwordController.text.trim(),
      );
      await user!.updateDisplayName(_userNameController.text);
      print(user);
      await _firebaseAuthService.signOut();
      if (mounted) {
        ToastMeesage.showToastMessage(context, "Sign up success");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (copntext) => const LoginScreen()),
        );
      }
    } on AuthException catch (e) {
      print("Sign up error: ${e.message}");

      if (mounted) {
        ToastMeesage.showToastMessage(context, "Sign up failed: ${e.message}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(28),

        child: AppBar(
          automaticallyImplyLeading: true,

          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 80),
                Text(
                  "Register",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 10),

                Text(
                  "Create your account",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 35),

                _buildUserNameField(),
                const SizedBox(height: 10),
                _buildEmailField(),
                const SizedBox(height: 10),
                _buildPasswordField(),
                const SizedBox(height: 10),
                _buildConfirmPasswordField(),
                const SizedBox(height: 50),

                Column(
                  children: [
                    CustomAuthElevatedButton(
                      buttonName: "Register",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _signUpUser();
                        }
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: const Text("Login"),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: _obscurefinalPassword,
      focusNode: _focusConfirmPasswordNode,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        labelText: "Confirm Password",
        prefixIcon: const Icon(Icons.password_outlined),
        suffixIcon: IconButton(
          onPressed: () {
            _changefinalObsecure(_obscurefinalPassword);
          },
          icon: _changeObsecureIcon(_obscurefinalPassword),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return "Please enter password.";
        } else if (value != _passwordController.text) {
          return "Password doesn't match.";
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      focusNode: _focusPasswordNode,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        labelText: "Password",
        prefixIcon: const Icon(Icons.password_outlined),
        suffixIcon: IconButton(
          onPressed: () {
            _changeObsecure(_obscurePassword);
          },
          icon: _changeObsecureIcon(_obscurePassword),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return "Please enter password.";
        } else if (value.length < 8) {
          return "Password must be at least 8 character.";
        }
        return null;
      },
      onEditingComplete: () => _focusConfirmPasswordNode.requestFocus(),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailNameController,
      focusNode: _focusEmailNode,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: "Email",
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return "Please enter email.";
        }
        return null;
      },
      onEditingComplete: () => _focusPasswordNode.requestFocus(),
    );
  }

  Widget _buildUserNameField() {
    return TextFormField(
      controller: _userNameController,

      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        labelText: "Username",
        prefixIcon: const Icon(Icons.person_outline),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),

      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return "Please enter your username";
        }
        return null;
      },
      onEditingComplete: () => _focusEmailNode.requestFocus(),
    );
  }

  void _changeObsecure(bool value) {
    setState(() {
      _obscurePassword = !value;
    });
  }

  void _changefinalObsecure(bool value) {
    setState(() {
      _obscurefinalPassword = !value;
    });
  }

  Icon _changeObsecureIcon(bool value) {
    return value
        ? const Icon(Icons.visibility_outlined)
        : const Icon(Icons.visibility_off_outlined);
  }

  @override
  void dispose() {
    _focusEmailNode.dispose();
    _focusPasswordNode.dispose();
    _focusConfirmPasswordNode.dispose();
    _userNameController.dispose();
    _emailNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
