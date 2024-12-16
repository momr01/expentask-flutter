import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomCurrencyTextfield extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final bool? isAmount;
  final bool? centeredText;
  final int? maxLines;
  final Color? fillColor;
  final Widget? suffixIcon;
  final bool modal;
  final VoidCallback? onTap;

  const CustomCurrencyTextfield({
    Key? key,
    required this.controller,
    this.hintText,
    this.isAmount,
    this.centeredText,
    this.maxLines,
    this.fillColor,
    this.suffixIcon,
    this.modal = false,
    this.onTap,
  }) : super(key: key);

  @override
  State<CustomCurrencyTextfield> createState() =>
      _CustomCurrencyTextfieldState();
}

class _CustomCurrencyTextfieldState extends State<CustomCurrencyTextfield> {
  final TextEditingController _formattedController = TextEditingController();
  final NumberFormat _currencyFormat =
      NumberFormat.currency(locale: 'en_US', symbol: '\$');

  @override
  void initState() {
    super.initState();
    // Inicializar el texto formateado.
    _updateFormattedText(widget.controller.text);
  }

  void _updateFormattedText(String rawValue) {
    final unformattedValue = rawValue.replaceAll(RegExp(r'[^\d.]'), '');
    final doubleValue = double.tryParse(unformattedValue) ?? 0;
    final formattedText = _currencyFormat.format(doubleValue);

    // Actualizar el controlador visible con el texto formateado.
    _formattedController.value = TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(
        offset: _calculateCursorPosition(rawValue, formattedText),
      ),
    );

    // Mantener el valor sin formato en el controlador original.
    widget.controller.text = unformattedValue;
  }

  int _calculateCursorPosition(String rawValue, String formattedText) {
    int rawCursorIndex = _formattedController.selection.baseOffset;

    // Calcular la nueva posición del cursor basado en la diferencia entre el texto crudo y formateado.
    final int difference = formattedText.length - rawValue.length;
    return (rawCursorIndex + difference).clamp(0, formattedText.length);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlign:
          widget.centeredText == true ? TextAlign.center : TextAlign.start,
      controller: _formattedController,
      keyboardType: widget.isAmount == true ? TextInputType.number : null,
      decoration: InputDecoration(
        suffixIcon: widget.suffixIcon,
        hintText: widget.hintText,
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black38),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black38),
        ),
        filled: true,
        fillColor: widget.fillColor ?? Colors.grey.shade200,
        isDense: true,
        errorStyle: TextStyle(
          color: widget.modal ? Colors.red : Colors.yellow,
          fontSize: 14,
        ),
      ),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return widget.hintText;
        }
        return null;
      },
      maxLines: widget.maxLines,
      onTap: widget.onTap,
      onChanged: (newValue) {
        _updateFormattedText(newValue);
      },
    );
  }
}
