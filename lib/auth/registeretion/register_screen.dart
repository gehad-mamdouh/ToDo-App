import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/auth/registeretion/custom_textForm_field.dart';
import 'package:todo/dailog_utils.dart';
import 'package:todo/firebase_utils.dart';
import 'package:todo/home/home_screen.dart';
import 'package:todo/models/my_user.dart';
import 'package:todo/provider/auth_user_provider.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'register_screen';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

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
            title: Text('Sign up'),
          ),
          body: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * .3),
                  CustomTextformField(
                    label: 'Enter your name',
                    controller: nameController,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  CustomTextformField(
                    label: 'Enter your email',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please enter your email';
                      }
                      final bool emailValid = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+$",
                      ).hasMatch(text);
                      if (!emailValid) {
                        return 'Please enter a valid email';
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
                        return 'Please enter a password';
                      }
                      if (text.length < 6) {
                        return 'Password should be at least 6 digits';
                      }
                      return null;
                    },
                  ),
                  CustomTextformField(
                    label: 'Confirm password',
                    controller: confirmPasswordController,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (text != passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        register();
                      },
                      child: Text('Create Account'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void register() async {
    if (formKey.currentState?.validate() == true) {
      DialogUtils.showLoading(context: context, message: 'Loading...');
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(
          context,
          message: 'No Internet connection. Please check your connection.',
          title: 'Error',
          posAcitonName: 'OK',
        );
        return;
      }

      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        MyUser myUser = MyUser(
            id: credential.user?.uid ?? '',
            name: nameController.text,
            email: emailController.text);
        var authProvider =
            Provider.of<AuthUserProvider>(context, listen: false);
        authProvider.updateUser(myUser);
        await FirebaseUtils.addUserToFireStore(myUser);
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(
          context,
          message: 'Registered successfully',
          title: 'Success',
          posAcitonName: 'OK',
          posAction: () {
            Navigator.pushReplacementNamed(context, HomeScreen.routeName);
          },
        );
        print(credential.user?.uid ?? '');
      } on FirebaseAuthException catch (e) {
        DialogUtils.hideLoading(context);
        if (e.code == 'weak-password') {
          DialogUtils.showMessage(
            context,
            message: 'The password provided is too weak',
            title: 'Error',
            posAcitonName: 'OK',
          );
        } else if (e.code == 'email-already-in-use') {
          DialogUtils.showMessage(
            context,
            message: 'The account already exists for that email.',
            title: 'Error',
            posAcitonName: 'OK',
          );
        } else if (e.code == 'network-request-failed') {
          DialogUtils.showMessage(
            context,
            message: 'Network error.',
            title: 'Error',
            posAcitonName: 'OK',
          );
        }
      } catch (e) {
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(
          context,
          message: e.toString(),
          title: 'Error',
          posAcitonName: 'OK',
        );
        print(e);
      }
    }
  }
}
