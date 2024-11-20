import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/auth/registeretion/custom_textForm_field.dart';
import 'package:todo/auth/registeretion/register_screen.dart';
import 'package:todo/firebase_utils.dart';
import 'package:todo/home/home_screen.dart';

import '../../dailog_utils.dart';
import '../../provider/auth_user_provider.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.white,
          child: Image.asset(
            'assets/images/background@3x.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fill,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text('Login'),
          ),
          body: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * .3),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Welcome back!',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontSize: 22),
                    ),
                  ),
                  CustomTextformField(
                    label: 'Enter your email',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'please enter your email';
                      }
                      final bool emailValid = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+$",
                      ).hasMatch(text);
                      if (!emailValid) {
                        return 'please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  CustomTextformField(
                    label: 'Password',
                    controller: passwordController,
                    obscureText: true,
                    keyboardType: TextInputType.phone,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'please enter a password';
                      }
                      if (text.length < 6) {
                        return 'Password should be at least 6 digits';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          login();
                        },
                        child: const Text('Login')),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(RegisterScreen.routeName);
                      },
                      child: const Text('OR Create Account'))
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> login() async {
    if (formKey.currentState?.validate() == true) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        DialogUtils.showMessage(
          context,
          message: 'No Internet Connection. Please check your network.',
          title: 'Error',
          posAcitonName: 'OK',
        );
        return;
      }

      DialogUtils.showLoading(context: context, message: 'Loading...');

      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);

        var user =
            await FirebaseUtils.readFromFirestore(credential.user?.uid ?? '');
        if (user == null) {
          return;
        }
        var authProvider =
            Provider.of<AuthUserProvider>(context, listen: false);
        authProvider.updateUser(user);
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(context,
            message: 'Login Successfully', title: 'success', posAction: () {
          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        }, posAcitonName: 'OK');
        print(credential.user?.uid ?? '');
      } on FirebaseAuthException catch (e) {
        DialogUtils.hideLoading(context);
        if (e.code == 'invalid-credential') {
          DialogUtils.showMessage(context,
              message: 'The supplied auth credential is incorrect.',
              title: 'Error',
              posAcitonName: 'OK');
        } else {
          DialogUtils.showMessage(context,
              message: e.message ?? 'An error occurred',
              title: 'Error',
              posAcitonName: 'OK');
        }
      } catch (e) {
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(context,
            posAcitonName: 'OK', message: e.toString());
        print(e.toString());
      }
    }
  }
}
