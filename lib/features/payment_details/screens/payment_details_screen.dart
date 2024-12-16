import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/bottom_bar.dart';
import 'package:payments_management/common/widgets/buttons/custom_button_green_disabled.dart';
import 'package:payments_management/common/widgets/buttons/custom_button_icons.dart';
import 'package:payments_management/common/widgets/custom_app_bar.dart';
import 'package:payments_management/common/widgets/loader.dart';
import 'package:payments_management/common/widgets/modals/modal_confirmation/modal_confirmation.dart';
import 'package:payments_management/constants/error_modal.dart';
import 'package:payments_management/constants/navigator_keys.dart';
import 'package:payments_management/features/form_edit_payment/screens/form_edit_payment_screen.dart';
import 'package:payments_management/features/form_edit_payment/services/form_edit_payment_services.dart';
import 'package:payments_management/features/names/services/names_services.dart';
import 'package:payments_management/features/payment_details/services/payment_details_services.dart';
import 'package:payments_management/features/payment_details/widgets/header_payment.dart';
import 'package:payments_management/features/payment_details/widgets/task_card.dart';
import 'package:payments_management/features/tasks/services/tasks_services.dart';
import 'package:payments_management/models/form_edit_payment_arguments.dart';
import 'package:payments_management/models/name/payment_name.dart';
import 'package:payments_management/models/payment/payment.dart';
import 'package:payments_management/models/task_code/task_code.dart';

class PaymentDetailsScreen extends StatefulWidget {
  static const String routeName = '/payment-details';
  final String paymentId;

  const PaymentDetailsScreen({super.key, required this.paymentId});

  @override
  State<PaymentDetailsScreen> createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  Payment? payment;
  final PaymentDetailsServices paymentDetailsServices =
      PaymentDetailsServices();

  /*final FormEditPaymentServices formEditPaymentServices =
      FormEditPaymentServices();*/
  final NamesServices namesServices = NamesServices();
  final TasksServices tasksServices = TasksServices();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(backDeviceInterceptor);
    fetchPayment();
  }

  @override
  void dispose() {
    super.dispose();
    BackButtonInterceptor.remove(backDeviceInterceptor);
  }

  bool backDeviceInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    return true;
  }

  List<Function> sortOptions = [
    // (a, b) => b.isCompleted.toString().compareTo(a.isCompleted.toString()),
    (a, b) => a.instalmentNumber.compareTo(b.instalmentNumber),
    // (a, b) => a.deadline.compareTo(b.deadline),
    (a, b) => a.code.name.compareTo(b.code.name),
  ];

  fetchPayment() async {
    payment =
        await paymentDetailsServices.fetchPayment(paymentId: widget.paymentId);
    setState(() {
      payment?.id != ""
          ? payment!.tasks.sort((a, b) {
              for (var compare in sortOptions) {
                int result = compare(a, b);
                if (result != 0) return result;
              }
              return 0; // Si todos los comparadores devuelven 0, los elementos son iguales
            })
          : null;
    });
  }

  Future<void> disablePayment() async {
    await paymentDetailsServices.disablePayment(paymentId: widget.paymentId);
  }

  void openDeleteConfirmation(BuildContext context) async {
    showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (context) => ModalConfirmation(
              onTap: disablePayment,
              confirmText: 'eliminar',
              confirmColor: Colors.red,
              middleText: 'eliminar',
              endText: 'el pago',
            ));
  }

  void navigateToFormEditPayment(BuildContext context, Payment payment,
      List<PaymentName> names, List<TaskCode> taskCodes) {
    Navigator.pushNamed(context, FormEditPayment.routeName,
        arguments: FormEditPaymentArguments(payment, names, taskCodes));
  }

  void _navigateBackToHomeScreen() {
    Navigator.pushNamedAndRemoveUntil(
        context, BottomBar.routeName, arguments: 0, (route) => false);
  }

  void _editPaymentForm() async {
    setState(() {
      isLoading = true;
    });
    List<PaymentName> names = [];
    List<TaskCode> taskCodes = [];

    names = await namesServices.fetchPaymentNames();

    if (names.isEmpty) {
      errorModal(
        context: NavigatorKeys.navKey.currentContext!,
        description: "Debe crear al menos un nombre, antes de editar un pago.",
        onTap: () {
          Navigator.pushNamedAndRemoveUntil(
              context, BottomBar.routeName, arguments: 0, (route) => true);
        },
      );
    } else {
      taskCodes = await tasksServices.fetchUsableTaskCodes();
      if (taskCodes.isEmpty) {
        errorModal(
          context: NavigatorKeys.navKey.currentContext!,
          description:
              "Debe crear al menos un código, antes de editar un pago.",
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(
                context, BottomBar.routeName, arguments: 0, (route) => true);
          },
        );
      } else {
        navigateToFormEditPayment(
            NavigatorKeys.navKey.currentContext!, payment!, names, taskCodes);
      }
    }
    // navigateToFormEditPayment(context, payment!);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    /* return PopScope(
      canPop: true,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          await Navigator.pushNamedAndRemoveUntil(
              context, BottomBar.routeName, arguments: 0, (route) => false);
        }
      },*/
    // onPopInvoked: (didPop) async {
    //   await Navigator.pushNamedAndRemoveUntil(
    //       context, BottomBar.routeName, arguments: 0, (route) => false);
    // },
    // onWillPop: () async {
    //   await Navigator.pushNamedAndRemoveUntil(
    //       context, BottomBar.routeName, (route) => false);
    //   return true;
    // },

    /*
      canPop: true,
      onPopInvoked: (bool didPop) {
        _navigateBackToHomeScreen();
      },*/
    // return NavigatorPopHandler(
    //  onPop: _navigateBackToHomeScreen,
    //child: Scaffold(
    return Scaffold(
        appBar: customAppBar(context,
            isMainPage: false, onBack: _navigateBackToHomeScreen),
        body: payment == null
            ? const Loader()
            : payment!.amount < 0
                ? const SizedBox()
                : Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    child: Column(children: [
                      HeaderPayment(payment: payment!),
                      const SizedBox(height: 30),
                      Expanded(
                          child: ListView.builder(
                              itemCount: payment!.tasks.length,
                              itemBuilder: (context, index) {
                                if (payment!.tasks[index].isActive) {
                                  return TaskCard(task: payment!.tasks[index]);
                                } else {
                                  return const SizedBox();
                                }
                              })),
                      const SizedBox(height: 30),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            isLoading
                                ? const CustomButtonGreenDisabled()
                                : CustomButtonIcons(
                                    delete: false, onTap: _editPaymentForm),
                            CustomButtonIcons(
                              delete: true,
                              onTap: () => openDeleteConfirmation(context),
                            ),
                          ]),
                    ]))
        //),
        );
  }
}
