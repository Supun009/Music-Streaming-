import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music/core/Loader/loader.dart';
import 'package:music/core/theme/app_pallete.dart';
import 'package:music/core/utills/utills.dart';
import 'package:music/features/auth/view/pages/login_page.dart';
import 'package:music/features/auth/view/widgets/auh_gradient_button.dart';
import 'package:music/core/widgets/custom_field.dart';
import 'package:music/features/auth/viewmodel/auth_view_model.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authViewModelProvider)?.isLoading == true;

    ref.listen(authViewModelProvider, (_, next) {
      next?.when(
        data: (data) {
          showSnackBar(context, 'Account created succesfully, please login');
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ));
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
              child: SingleChildScrollView(
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 50,
                        ),
                      ),

                      const SizedBox(height: 30),
                      //name filed
                      CustomFied(
                        hintText: 'Name',
                        controller: _nameController,
                      ),
                      const SizedBox(height: 15),
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
                            ref.read(authViewModelProvider.notifier).signUp(
                                  name: _nameController.text,
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                );
                          }
                        },
                        text: 'Sign up',
                      ),

                      const SizedBox(height: 20),
                      //rich text
                      RichText(
                          text: TextSpan(
                              text: 'Aleady have an account?  ',
                              style: Theme.of(context).textTheme.titleMedium,
                              children: const [
                            TextSpan(
                                text: 'Sign in',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Pallete.gradient1))
                          ]))
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
