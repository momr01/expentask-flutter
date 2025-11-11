import 'package:flutter/material.dart';
import 'package:payments_management/features/payment_details/screens/payment_details_screen.dart';

void fromSuccessUpdateToPaymentDetails(context, String idPayment) {
  Navigator.popUntil(
      context,
      ModalRoute.withName(
        PaymentDetailsScreen.routeName,
      ));

  Navigator.popAndPushNamed(context, PaymentDetailsScreen.routeName,
      arguments: idPayment
      // arguments: {
      //   'idPayment': idPayment,
      //   'refresh': true,
      // },
      //arguments: [idPayment, true]
      //},
      );
}

void cancelUpdateForm(context) {
  Navigator.pop(context);
}
