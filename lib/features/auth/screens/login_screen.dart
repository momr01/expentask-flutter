import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/buttons/custom_button.dart';
import 'package:payments_management/common/widgets/custom_password_field.dart';
import 'package:payments_management/common/widgets/custom_textfield.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/features/auth/screens/register_screen.dart';
import 'package:payments_management/features/auth/services/auth_services.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login-screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _signInFormKey = GlobalKey<FormState>();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthServices authServices = AuthServices();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void signInUser() async {
    setState(() {
      isLoading = true;
    });
    await authServices.signInUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
    );
    setState(() {
      isLoading = false;
    });
  }

  void validateForm() {
    if (_signInFormKey.currentState!.validate()) {
      signInUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: GlobalVariables.primaryColor,
        body: SingleChildScrollView(
          child: SafeArea(
              child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  children: [
                    Image.asset(
                      'assets/images/expentask-logo.png',
                      width: 80,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Image.asset(
                      'assets/images/expentask-official.png',
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Form(
                    key: _signInFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Email:',
                          style: TextStyle(
                              color: GlobalVariables.greyBackgroundColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                          controller: _emailController,
                          hintText: 'Ingrese su correo electrónico',
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Text(
                          'Contraseña:',
                          style: TextStyle(
                              color: GlobalVariables.greyBackgroundColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // CustomTextField(
                        //   controller: _passwordController,
                        //   hintText: 'Ingrese su contraseña',
                        // ),
                        CustomPasswordField(
                            controller: _passwordController,
                            text: 'Ingrese su contraseña'),

                        const SizedBox(
                          height: 40,
                        ),
                        CustomButton(
                          text: isLoading ? "INICIANDO SESIÓN..." : 'INGRESAR',
                          color: GlobalVariables.secondaryColor,
                          onTap: () {
                            if (_signInFormKey.currentState!.validate()) {
                              signInUser();
                            }
                          },
                          isDisabled: isLoading ? true : false,
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 30,
                ),
                RichText(
                  text: TextSpan(
                      text: 'No tienes cuenta? ',
                      style: const TextStyle(
                          fontStyle: FontStyle.italic, fontSize: 15),
                      children: [
                        TextSpan(
                            text: 'REGISTRATE',
                            style: const TextStyle(
                                fontStyle: FontStyle.normal,
                                color: GlobalVariables.secondaryColor,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(
                                    context, RegisterScreen.routeName);
                              })
                      ]),
                )
              ],
            ),
          )),
        ));
  }
}
