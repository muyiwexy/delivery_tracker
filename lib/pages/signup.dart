import 'package:delivery_tracker/auth/app_provider.dart';
import 'package:delivery_tracker/pages/component/registrationloader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // new form key

  clientSignup() async {
    if (_formKey.currentState!.validate()) {
      // check if form is valid
      final state = Provider.of<AppProvider>(context, listen: false);
      state.signup(_emailController.text, _passwordController.text,
          _nameController.text, context);
    }
  }

  @override
  Widget build(BuildContext context) => Consumer<AppProvider>(
        builder: (context, state, child) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blueGrey,
                  Colors.deepOrange,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomLeft,
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                child: Center(
                  child: IntrinsicHeight(
                    child: Container(
                      constraints: const BoxConstraints(
                        maxWidth: 500,
                      ),
                      width: MediaQuery.of(context).size.width * 0.8,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 229, 226, 226),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Sign up',
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            CupertinoTextFormFieldRow(
                              controller: _nameController,
                              placeholder: 'Name',
                              keyboardType: TextInputType.emailAddress,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.6),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              validator: (value) {
                                // validate password field
                                if (value!.isEmpty) {
                                  return 'Name should not be empty';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 5),
                            CupertinoTextFormFieldRow(
                              controller: _emailController,
                              placeholder: 'Email',
                              keyboardType: TextInputType.emailAddress,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.6),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              validator: (value) {
                                // validate email field
                                if (value!.isEmpty || !value.contains('@')) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 5),
                            CupertinoTextFormFieldRow(
                              controller: _passwordController,
                              placeholder: 'Password',
                              obscureText: true,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.6),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              validator: (value) {
                                // validate password field
                                if (value!.isEmpty || value.length < 8) {
                                  return 'Password must be at least 8 characters long';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: clientSignup,
                              style: const ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll<Color>(
                                          Colors.deepOrange)),
                              child: state.isLoading == true
                                  ? SizedBox(
                                      height: 24.0,
                                      width: 24.0,
                                      child: registrationloader(),
                                    )
                                  : const Text(
                                      'Sign up',
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            RichText(
                              text: TextSpan(
                                text: "Already have an account? ",
                                style: const TextStyle(color: Colors.black),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Sign in',
                                    style: const TextStyle(color: Colors.blue),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // Handle sign-in button press
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginPage()),
                                        );
                                      },
                                  ),
                                  const TextSpan(text: ' to continue.'),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
}