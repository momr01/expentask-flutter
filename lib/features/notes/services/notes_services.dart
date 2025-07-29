import 'package:flutter/material.dart';
import 'package:payments_management/constants/error_handling.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/constants/navigator_keys.dart';
import 'package:http/http.dart' as http;
import 'package:payments_management/constants/success_modal.dart';
import 'package:payments_management/constants/utils.dart';
import 'package:payments_management/models/note/note.dart';
import 'package:payments_management/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class NotesServices {
  Future<List<Note>> fetchAllNotes() async {
    final userProvider = Provider.of<UserProvider>(
        NavigatorKeys.navKey.currentContext!,
        listen: false);
    List<Note> notesList = [];

    try {
      http.Response res =
          await http.get(Uri.parse('$uri/api/notes/getAll'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token
      });

      httpErrorHandle(
          response: res,
          context: NavigatorKeys.navKey.currentContext!,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              notesList
                  // .add(Payment.fromJson(jsonEncode(jsonDecode(res.body)[i])));
                  .add(Note.fromJson(jsonDecode(res.body)[i]));
              //from json accepts string, jsondecode is an object
            }
          });
    } catch (e) {
      showSnackBar(NavigatorKeys.navKey.currentContext!, e.toString());
    }
    return notesList;
  }

  Future<void> editNote(
      {required String id,
      required String title,
      required String content,
      String? associatedType,
      String? associatedValue}) async {
    final userProvider = Provider.of<UserProvider>(
        NavigatorKeys.navKey.currentContext!,
        listen: false);

    Map body = {
      'title': title,
      'content': content,
      'associatedType': associatedType != null ?? associatedType,
      'associatedValue': associatedValue != null ?? associatedValue
    };

    try {
      http.Response res = await http.put(Uri.parse('$uri/api/notes/edit/$id'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token
          },
          body: jsonEncode(body));

      httpErrorHandle(
          response: res,
          context: NavigatorKeys.navKey.currentContext!,
          onSuccess: () {
            successModal(
                context: NavigatorKeys.navKey.currentContext!,
                description: 'La nota de modificó correctamente',
                // onPressed: () => Navigator.pushNamedAndRemoveUntil(
                //     context, BottomBar.routeName, arguments: 1, (route) => true),
                /* onPressed: () {
                  // fromSuccessToGroups(NavigatorKeys.navKey.currentContext!)
                  Navigator.pop(NavigatorKeys.navKey.currentContext!);
                  Navigator.pop(NavigatorKeys.navKey.currentContext!);
                });*/
                onPressed: () {
                  final context = NavigatorKeys.navKey.currentContext!;
                  Navigator.of(context)
                      .pop(true); // Devuelve resultado al modal anterior
                  Navigator.of(context).pop(
                      true); // Devuelve resultado al listado o pantalla principal
                });
          });
    } catch (e) {
      showSnackBar(NavigatorKeys.navKey.currentContext!, e.toString());
    }
  }
}
