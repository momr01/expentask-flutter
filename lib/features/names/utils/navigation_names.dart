import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/bottom_bar.dart';
import 'package:payments_management/features/names/providers/names_provider.dart';
import 'package:provider/provider.dart';

/*void fromSuccessEditToNames(context) async {
  Navigator.pushNamedAndRemoveUntil(
      context, BottomBar.routeName, arguments: 1, (route) => false);
  // Navigator.popUntil(
  //     context,
  //    BottomBar.routeName, arguments: 1);

  // Navigator.popAndPushNamed(context, BottomBar.routeName, arguments: 1);
  //Provider.of<NamesProvider>(context, listen: false).refresh();

  await Provider.of<NamesProvider>(context, listen: false).refresh();
}*/

void fromSuccessEditToNames(
    BuildContext context, TextEditingController searchController) async {
  final provider = Provider.of<NamesProvider>(context, listen: false);

  // 👇 Guardamos el texto actual antes de refrescar
  provider.filter(searchController.text);

  // 👇 Refrescamos y mantenemos filtro + scroll
  await provider.refresh();

  // 👇 Reaplicamos el filtro anterior tras el refresh
  provider.applyLastSearch();

  // 👇 Navegamos a la pestaña de Nombres
  Navigator.pushNamedAndRemoveUntil(
    context,
    BottomBar.routeName,
    arguments: 1,
    (route) => false,
  );

  // Refrescamos datos
// await provider.refresh();

  // // 👇 Refrescamos y mantenemos filtro + scroll
  // await provider.refresh();

  // // 👇 Reaplicamos el filtro anterior tras el refresh
  // provider.applyLastSearch();
}
