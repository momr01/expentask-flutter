// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:payments_management/constants/global_variables.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isLoading;
  const LoginButton({Key? key, required this.onTap, required this.isLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onTap,
      style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: GlobalVariables.secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          disabledBackgroundColor: Colors.grey.shade500),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isLoading ? const CircularProgressIndicator() : const SizedBox(),
          SizedBox(
            width: isLoading ? 10 : 0,
          ),
          Text(
            isLoading ? "INICIANDO SESIÓN..." : 'INGRESAR',
            style: TextStyle(
                color: isLoading ? GlobalVariables.primaryColor : Colors.black,
                fontSize: 25),
          ),
        ],
      ),
    );
  }
}
