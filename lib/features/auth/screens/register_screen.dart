import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/buttons/custom_button.dart';
import 'package:payments_management/common/widgets/custom_password_field.dart';
import 'package:payments_management/common/widgets/custom_textfield.dart';
import 'package:payments_management/common/widgets/modal_confirmation/modal_confirmation.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/features/auth/services/auth_services.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = '/register-screen';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _signUpFormKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final AuthServices authServices = AuthServices();

  void openModalConfirmation() async {
    showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (context) => ModalConfirmation(
              onTap: signUpUser,
              confirmText: 'REGISTRAR',
              confirmColor: Colors.blue,
              middleText: 'registrar',
              endText: 'los datos ingresados',
            ));
  }

  Future<void> signUpUser() async {
    await authServices.signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        name: _nameController.text);
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                    width: 40,
                  ),
                  Image.asset(
                    'assets/images/expentask-official.png',
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'REGISTRO',
                    style: TextStyle(
                        color: GlobalVariables.greyBackgroundColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Form(
                  key: _signUpFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nombre completo:',
                        style: TextStyle(
                            color: GlobalVariables.greyBackgroundColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        controller: _nameController,
                        hintText: 'Ingrese su nombre completo',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Email:',
                        style: TextStyle(
                            color: GlobalVariables.greyBackgroundColor,
                            fontSize: 15,
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
                        height: 20,
                      ),
                      const Text(
                        'Contraseña:',
                        style: TextStyle(
                            color: GlobalVariables.greyBackgroundColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomPasswordField(
                          controller: _passwordController,
                          text: 'Ingrese su contraseña'),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Repita contraseña:',
                        style: TextStyle(
                            color: GlobalVariables.greyBackgroundColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomPasswordField(
                          controller: _confirmPasswordController,
                          text: 'Vuelva a ingresar su contraseña'),
                      const SizedBox(
                        height: 40,
                      ),
                      CustomButton(
                          text: 'REGISTRARSE',
                          color: GlobalVariables.secondaryColor,
                          onTap: () {
                            if (_signUpFormKey.currentState!.validate()) {
                              openModalConfirmation();
                            }
                          }),
                    ],
                  )),
              const SizedBox(
                height: 30,
              ),
              RichText(
                text: TextSpan(
                    text: 'Ya tienes cuenta? ',
                    style: const TextStyle(
                        fontStyle: FontStyle.italic, fontSize: 15),
                    children: [
                      TextSpan(
                          text: 'INGRESA',
                          style: const TextStyle(
                              fontStyle: FontStyle.normal,
                              color: GlobalVariables.secondaryColor,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pop(context);
                            })
                    ]),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        )),
      ),
    );
  }
}
