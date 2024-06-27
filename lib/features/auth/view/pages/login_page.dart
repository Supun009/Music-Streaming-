import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music/core/theme/app_pallete.dart';
import 'package:music/core/utills/utills.dart';
import 'package:music/features/auth/view/widgets/auh_gradient_button.dart';
import 'package:music/core/widgets/custom_field.dart';
import 'package:music/features/home/view/pages/home_page.dart';

import '../../../../core/Loader/loader.dart';
import '../../viewmodel/auth_view_model.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
    // _formkey.currentState.validate();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authViewModelProvider)?.isLoading == true;

    ref.listen(authViewModelProvider, (_, next) {
      next?.when(
        data: (data) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
            (_) => false,
          );
        },
        error: (error, st) {
          showSnackBar(context, error.toString());
        },
        loading: () {},
      );
    });

    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Login',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                      ),
                    ),

                    const SizedBox(height: 30),

                    //email field
                    CustomFied(
                      hintText: 'Email',
                      controller: _emailController,
                    ),
                    const SizedBox(height: 15),

                    //password field
                    CustomFied(
                      hintText: 'Password',
                      controller: _passwordController,
                      obscureText: true,
                    ),

                    const SizedBox(height: 20),

                    //sign up button
                    AuthGradientButton(
                      onTap: () async {
                        if (_formkey.currentState!.validate()) {
                          ref.read(authViewModelProvider.notifier).login(
                                email: _emailController.text,
                                password: _passwordController.text,
                              );
                        }
                      },
                      text: "Log in",
                    ),

                    const SizedBox(height: 20),
                    //rich text
                    RichText(
                        text: TextSpan(
                            text: 'Don\'t have an account?  ',
                            style: Theme.of(context).textTheme.titleMedium,
                            children: const [
                          TextSpan(
                              text: 'Sign up',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Pallete.gradient1))
                        ]))
                  ],
                ),
              ),
            ),
    );
  }
}
