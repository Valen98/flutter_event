import 'package:event/components/my_button.dart';
import 'package:event/components/my_text_field.dart';
import 'package:event/services/auth/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final displayNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void singUp() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password does not match'),
        ),
      );
      return;
    }

    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Loading.."),
        duration: Duration(milliseconds: 300),
      ));

      await authService.signUpWithEmailAndPassword(emailController.text,
          passwordController.text, displayNameController.text);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User created and logged in.")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo
              const Center(
                child: Icon(
                  Icons.event,
                  size: 80,
                  color: Color(0xff533AC7),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              //Welcome message
              const Text(
                "Lets create an account",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              // display name
              MyTextField(
                controller: displayNameController,
                hintText: 'Display name',
                obscureText: false,
                readOnly: false,
              ),

              const SizedBox(
                height: 10,
              ),

              //email textfield
              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
                readOnly: false,
              ),
              //password
              const SizedBox(
                height: 10,
              ),
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
                readOnly: false,
              ),
              const SizedBox(
                height: 10,
              ),

              //confirm password
              MyTextField(
                controller: confirmPasswordController,
                hintText: 'Confirm password',
                obscureText: true,
                readOnly: false,
              ),
              const SizedBox(
                height: 25,
              ),

              //sign up button
              MyButton(
                  onTap: singUp,
                  bgColor: const Color(0xff212325),
                  text: 'Sign In'),

              const SizedBox(
                height: 50,
              ),
              //Not a memeber?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already a member?'),
                  const SizedBox(
                    width: 4,
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      'Login now',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
