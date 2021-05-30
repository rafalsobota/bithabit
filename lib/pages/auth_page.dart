import 'dart:ui';

import 'package:bithabit/models/http_exception.dart';
import 'package:bithabit/pages/home_page.dart';
import 'package:bithabit/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

enum AuthMode { login, signup }

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

const shape = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(
    Radius.circular(8),
  ),
);

class _AuthPageState extends State<AuthPage> {
  // final buttonStyle =
  //     ElevatedButton.styleFrom(visualDensity: VisualDensity.standard);

  final mainButtonStyle = ElevatedButton.styleFrom(
    elevation: 0,
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
    shape: shape,
  );

  final secondaryButtonStyle = OutlinedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
    shape: shape,
  );

  final inputPadding = const EdgeInsets.only(top: 8.0, left: 8, right: 8);

  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  final emailRegexp = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

  AuthMode _authMode = AuthMode.login;

  String _email = '';
  String _password = '';

  bool _isLoading = false;

  Widget _loginActions() {
    return ButtonBar(
      children: [
        OutlinedButton(
          onPressed: () {
            setState(() {
              _authMode = AuthMode.signup;
            });
          },
          child: const Text('Signup Instead'),
          style: secondaryButtonStyle,
        ),
        _isLoading
            ? ElevatedButton.icon(
                onPressed: () {},
                label: const Text('Login'),
                icon: const SizedBox(
                  height: 15,
                  child: FittedBox(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                ),
                style: mainButtonStyle,
              )
            : ElevatedButton(
                onPressed: _submit,
                child: const Text('Login'),
                style: mainButtonStyle,
              ),
      ],
    );
  }

  Widget _signupActions() {
    return ButtonBar(
      children: [
        OutlinedButton(
          onPressed: () {
            setState(() {
              _authMode = AuthMode.login;
            });
          },
          child: const Text('Login Instead'),
          style: secondaryButtonStyle,
        ),
        ElevatedButton(
          onPressed: () {
            _submit();
          },
          child: const Text('Signup'),
          style: mainButtonStyle,
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occured'),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.login) {
        // Log user in
        await context.read<Auth>().login(_email, _password);
      } else {
        // Sign user up
        await context.read<Auth>().signup(_email, _password);
      }

      setState(() {
        _isLoading = false;
      });

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';

      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address.';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }

      _showErrorDialog(errorMessage);
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
      print(error);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 64.0),
                  child: const Text(
                    'Bithabit',
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 40),
                  ),
                ),
                Container(
                  constraints: const BoxConstraints(maxWidth: 350),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: inputPadding,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: InputBorder.none,
                            filled: true,
                          ),
                          autofocus: true,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null) {
                              return 'Please enter your email address';
                            }
                            if (!emailRegexp.hasMatch(value)) {
                              return 'Please enter valid email address';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _email = value ?? '';
                          },
                        ),
                      ),
                      Padding(
                        padding: inputPadding,
                        child: TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            border: InputBorder.none,
                            filled: true,
                            // fillColor: Colors.red,
                          ),
                          obscureText: true,
                          textInputAction: _authMode == AuthMode.login
                              ? TextInputAction.send
                              : TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter password';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _password = value ?? '';
                          },
                          onFieldSubmitted: (value) {
                            _submit();
                          },
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        constraints: BoxConstraints(
                            maxHeight: _authMode == AuthMode.login ? 0 : 100),
                        padding: inputPadding,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: _authMode == AuthMode.login ? 0 : 1,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Confirm Password',
                              border: InputBorder.none,
                              filled: true,
                              // fillColor: Colors.red,
                            ),
                            obscureText: true,
                            textInputAction: TextInputAction.send,
                            validator: _authMode == AuthMode.login
                                ? null
                                : (value) {
                                    if (value == null) {
                                      return 'Please enter password again';
                                    }
                                    if (value != _passwordController.text) {
                                      return 'Please enter the same password again';
                                    }
                                    return null;
                                  },
                            onFieldSubmitted: (value) {
                              _submit();
                            },
                          ),
                        ),
                      ),
                      _authMode == AuthMode.login
                          ? _loginActions()
                          : _signupActions(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
