import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:payments_management/common/widgets/loader.dart';
import 'package:payments_management/common/widgets/main_title.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/features/alerts/services/alerts_services.dart';
import 'package:payments_management/features/alerts/widgets/card_alert.dart';
import 'package:payments_management/models/alert.dart';

class AlertsScreen extends StatefulWidget {
  static const String routeName = '/alerts';
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  List<Alert>? alerts;
  List<Alert>? filteredAlerts;

  final AlertsServices alertsServices = AlertsServices();

  bool _isLoading = false;
  String selectedFilter = 'Todos';

  @override
  void initState() {
    super.initState();
    fetchAlerts();
  }

  @override
  void dispose() {
    super.dispose();
  }

/*
  fetchAlerts() async {
    setState(() {
      _isLoading = true;
    });
    alerts = await alertsServices.fetchAlerts(context: context);
    setState(() {
      _isLoading = false;
    });
  }*/
  fetchAlerts() async {
    setState(() => _isLoading = true);
    alerts = await alertsServices.fetchAlerts(context: context);
    filteredAlerts = alerts; // inicialmente sin filtro
    setState(() => _isLoading = false);
  }

  void applyFilter(String filter) {
    if (alerts == null) return;

    setState(() {
      selectedFilter = filter;
      switch (filter) {
        case 'Por vencer':
          filteredAlerts = alerts!.where((a) => a.daysNumber < 0).toList();
          break;
        case 'Vencen hoy':
          filteredAlerts = alerts!.where((a) => a.daysNumber == 0).toList();
          break;
        case 'Vencidos':
          filteredAlerts = alerts!.where((a) => a.daysNumber > 0).toList();
          break;
        case 'Cuotas':
          filteredAlerts = alerts!.where((a) => a.hasInstallments).toList();
          break;
        default:
          filteredAlerts = alerts;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        color: GlobalVariables.greyBackgroundColor,
        opacity: 0.8,
        blur: 0.8,
        inAsyncCall: _isLoading,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20, left: 15, right: 15),
              child: MainTitle(title: 'Alertas'),
            ),
            const SizedBox(
              height: 20,
            ),
            // 🔹 Row de botones de filtro
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  for (final filter in [
                    'Todos',
                    'Por vencer',
                    'Vencen hoy',
                    'Vencidos',
                    'Cuotas',
                  ])
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(filter),
                        selected: selectedFilter == filter,
                        onSelected: (_) => applyFilter(filter),
                        selectedColor: Theme.of(context).colorScheme.primary,
                        labelStyle: TextStyle(
                          color: selectedFilter == filter
                              ? Colors.white
                              : Colors.black,
                        ),
                        checkmarkColor: Colors.white,
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            /*   alerts == null
                ? const Loader()
                : alerts!.isEmpty
                    ? const Text('¡No existen alertas para mostrar!')
                    : Expanded(
                        child: ListView.builder(
                            itemBuilder: (context, index) {
                              return CardAlert(alert: alerts![index]);
                            },
                            itemCount: alerts!.length)),*/
            alerts == null
                ? const Expanded(child: Center(child: Loader()))
                : filteredAlerts!.isEmpty
                    ? const Expanded(
                        child: Center(
                          child: Text('¡No existen alertas para mostrar!'),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return CardAlert(alert: filteredAlerts![index]);
                          },
                          itemCount: filteredAlerts!.length,
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
