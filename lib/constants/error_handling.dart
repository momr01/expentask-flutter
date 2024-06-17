import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:payments_management/constants/error_modal.dart';

void httpErrorHandle({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 201:
      onSuccess();
      break;
    case 204:
      onSuccess();
      break;
    //case 400:
    //showSnackBar(context, jsonDecode(response.body)['msg']);
    // errorModal(context: context, description: response.body);
    // break;
    //case 500:
    //showSnackBar(context, jsonDecode(response.body)['error']);
    // errorModal(context: context, description: response.body);
    // break;
    //case 409:
    //  errorModal(context: context, description: response.body);
    // break;
    default:
      //showSnackBar(context, response.body);
      errorModal(context: context, description: response.body);
      break;
  }
}
