import 'package:flutter/material.dart';

Future<List<T>> fetchData<T>({
  //required BuildContext context,
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

  // onStart(); // Marca inicio de carga
  // try {
  //   final items =
  //       await fetchFunction() ?? <T>[]; // Siempre devuelve lista, nunca null
  //   onSuccess(items);
  //   return items;
  // } catch (e, stack) {
  //   // Para debug y tests: evita que falle silenciosamente
  //   debugPrint('Error en fetchData: $e\n$stack');
  //   onSuccess(<T>[]); // Para no dejarlo null en tests
  //   return <T>[];
  // } finally {
  //   onComplete(); // Marca fin de carga
  // }
}

/*
Future<List<T>> fetchData<T>({
  required Future<List<T>> Function() fetchFunction,
  required ValueSetter<List<T>> onSuccess,
  required VoidCallback onStart,
  required VoidCallback onComplete,
}) async {
  onStart();
  try {
    final items = await fetchFunction();
    onSuccess(items);
    return items;
  } catch (e, st) {
    // Esto evita que los tests mueran y deja traza
    debugPrint('Error en fetchData: $e\n$st');
    onSuccess(<T>[]);
    return <T>[];
  } finally {
    onComplete();
  }
}
*/