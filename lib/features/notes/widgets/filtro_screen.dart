import 'package:flutter/material.dart';

class FiltroScreen extends StatelessWidget {
  final String current;
  final void Function(String) onSelect;

  const FiltroScreen({Key? key, required this.current, required this.onSelect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.list),
          title: const Text('TODO'),
          selected: current == 'TODO',
          onTap: () {
            onSelect('TODO');
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.payments),
          title: const Text('PAGOS'),
          selected: current == 'PAGO',
          onTap: () {
            onSelect('PAGO');
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('NOMBRES'),
          selected: current == 'NOMBRE',
          onTap: () {
            onSelect('NOMBRE');
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
