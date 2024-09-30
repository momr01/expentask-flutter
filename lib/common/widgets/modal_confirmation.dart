// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/buttons/custom_button_options.dart';
import 'package:payments_management/constants/global_variables.dart';

class ModalConfirmation extends StatefulWidget {
  final VoidCallback onTap;
  final String confirmText;
  final Color confirmColor;
  final String middleText;
  final String endText;
  const ModalConfirmation({
    Key? key,
    required this.onTap,
    required this.confirmText,
    required this.confirmColor,
    required this.middleText,
    required this.endText,
  }) : super(key: key);

  @override
  State<ModalConfirmation> createState() => _ModalConfirmationState();
}

class _ModalConfirmationState extends State<ModalConfirmation> {
  bool _isLoading = false;

  void handleConfirm() async {
    setState(() {
      _isLoading = true;
    });
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        insetPadding: const EdgeInsets.all(10),
        content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: _isLoading
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            CircularProgressIndicator(), // Muestra el loading si está activo
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'Enviando datos...',
                              style: TextStyle(
                                  color: GlobalVariables.primaryColor,
                                  fontSize: 25),
                            )
                          ])
                    : RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: '¿Está seguro de',
                            style: const TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: ' ${widget.middleText} ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: GlobalVariables.primaryColor),
                              ),
                              TextSpan(
                                text: '${widget.endText}?',
                              ),
                            ])))),
        actions: <Widget>[
          _isLoading
              ? const SizedBox()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      // _isLoading
                      //     ? const CircularProgressIndicator() // Muestra el loading si está activo
                      //     :
                      CustomButtonOptions(
                        text: widget.confirmText.toUpperCase(),
                        //onTap: widget.onTap,
                        onTap: handleConfirm,
                        color: widget.confirmColor,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      CustomButtonOptions(
                        text: 'CANCELAR',
                        onTap: () {
                          Navigator.pop(context);
                        },
                        color: GlobalVariables.cancelButtonColor,
                      )
                    ]),
          const SizedBox(
            height: 30,
          )
        ]);
  }
}
