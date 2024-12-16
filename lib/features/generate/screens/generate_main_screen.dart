// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:payments_management/common/widgets/main_title.dart';
import 'package:payments_management/constants/error_modal.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/features/form_edit_payment/services/form_edit_payment_services.dart';
import 'package:payments_management/features/generate/screens/generate_details_groups_screen.dart';
import 'package:payments_management/features/generate/screens/generate_details_individual_screen.dart';
import 'package:payments_management/features/generate/widgets/main_card_type.dart';
import 'package:payments_management/features/groups/services/groups_services.dart';
import 'package:payments_management/features/names/services/names_services.dart';
import 'package:payments_management/models/generate_payment.dart';
import 'package:payments_management/models/group/group.dart';
import 'package:payments_management/models/name/payment_name.dart';

class GenerateMainScreen extends StatefulWidget {
  static const String routeName = '/generate-payments-main';
  const GenerateMainScreen({super.key});

  @override
  State<GenerateMainScreen> createState() => _GenerateMainScreenState();
}

class _GenerateMainScreenState extends State<GenerateMainScreen> {
  List<PaymentName>? names;
  List<Group>? groups;
  List<GeneratePayment> _payments = [];

  // final FormEditPaymentServices formEditPaymentServices =
  //    FormEditPaymentServices();
  final NamesServices namesServices = NamesServices();
  final GroupsServices groupsServices = GroupsServices();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  fetchPaymentNames(String type) async {
    setState(() {
      _isLoading = true;
    });
    names = await namesServices.fetchPaymentNames();
    setState(() {
      if (names != null) {
        _payments = [];
        for (var name in names!) {
          _payments
              .add(GeneratePayment(id: name.id!, name: name.name, state: true));
        }
      }
      _isLoading = false;

      if (_payments.isNotEmpty) {
        switch (type) {
          case "individual":
            {
              navigateToIndividualList(context);
            }

            break;
          case "installments":
            {
              navigateToInstallmentsList(context);
            }
          // default:
        }
      } else {
        errorModal(
            context: context,
            description:
                'No existen nombres para generar pagos en forma masiva.');
      }
    });
  }

  fetchGroups() async {
    setState(() {
      _isLoading = true;
    });
    groups = await groupsServices.fetchActiveGroups();
    setState(() {
      // _payments = [];
      if (groups != null) {
        _payments = [];
        for (var group in groups!) {
          _payments.add(GeneratePayment(
              id: group.id!,
              name: group.name,
              state: true,
              namesList: group.paymentNames));
        }
      }
      _isLoading = false;

      if (_payments.isNotEmpty) {
        navigateToGroups(context);
      } else {
        errorModal(
            context: context,
            description:
                'No existen grupos para generar pagos en forma masiva.');
      }
    });
  }

  void navigateToGroups(BuildContext context) {
    Navigator.pushNamed(context, GenerateDetailsGroupsScreen.routeName,
        arguments: [_payments, 'Generar Pagos por Grupo']);
  }

  void navigateToIndividualList(BuildContext context) {
    Navigator.pushNamed(context, GenerateDetailsIndividualScreen.routeName,
        arguments: [_payments, 'Generación Individual de Pagos']);
  }

  void navigateToInstallmentsList(BuildContext context) {
    Navigator.pushNamed(context, GenerateDetailsIndividualScreen.routeName,
        arguments: [
          _payments,
          'Generación Individual de Cuotas',
          "installments"
        ]);
  }

  @override
  Widget build(BuildContext context) {
    List generationTypes = [
      {'title': 'Grupos', 'onTap': fetchGroups},
      {'title': 'Individual', 'onTap': () => fetchPaymentNames("individual")},
      {'title': 'Cuotas', 'onTap': () => fetchPaymentNames("installments")}
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: ModalProgressHUD(
        color: GlobalVariables.greyBackgroundColor,
        opacity: 0.8,
        blur: 0.8,
        inAsyncCall: _isLoading,
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
          child: Column(
            children: [
              const MainTitle(title: 'Generación Masiva de Pagos'),
              const SizedBox(
                height: 40,
              ),
              Flexible(
                // child: SizedBox(
                // height: 100,
                child: GridView.count(
                    primary: false,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    crossAxisCount: 2,
                    //children: _foundGroups
                    children: generationTypes
                        .map(
                          (e) =>
                              // SizedBox(
                              //height: 20,
                              //child:
                              MainCardType(
                                  title: e['title'], onTap: e['onTap']),
                          // )
                        )
                        .toList()),
                // child: ListView.separated(
                //   separatorBuilder: (context, index) => const SizedBox(
                //     width: 20,
                //   ),
                //   scrollDirection: Axis.horizontal,
                //   itemBuilder: (context, index) {
                //     return MainCardType(
                //       title: generationTypes[index]['title'],
                //       onTap: generationTypes[index]['onTap'],
                //     );
                //   },
                //   itemCount: generationTypes.length,
                // ),
                //)
              )
            ],
          ),
        ),
      ),
    );
  }
}
