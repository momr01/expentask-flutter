import 'package:flutter/material.dart';

Future<List<T>> fetchData<T>({
  required BuildContext context,
  required Future<List<T>> Function() fetchFunction,
  required ValueSetter<List<T>> onSuccess,
  required VoidCallback onStart,
  required VoidCallback onComplete,
}) async {
  onStart(); // Inicia la carga
  try {
    final items = await fetchFunction();
    onSuccess(items); // Notificamos los resultados obtenidos
  } finally {
    onComplete(); // Finaliza la carga
  }
  return [];
}
