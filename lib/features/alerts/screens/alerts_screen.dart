import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:payments_management/common/widgets/loader.dart';
import 'package:payments_management/common/widgets/main_title.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/features/alerts/services/alerts_services.dart';
import 'package:payments_management/features/alerts/widgets/card_alert.dart';
import 'package:payments_management/models/alert.dart';
import 'package:provider/provider.dart';

class AlertsScreen extends StatefulWidget {
  static const String routeName = '/alerts';
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  List<Alert>? alerts;

  final AlertsServices alertsServices = AlertsServices();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchAlerts();
  }

  @override
  void dispose() {
    super.dispose();
  }

  fetchAlerts() async {
    setState(() {
      _isLoading = true;
    });
    alerts = await alertsServices.fetchAlerts(context: context);
    setState(() {
      _isLoading = false;
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
            alerts == null
                ? const Loader()
                : alerts!.isEmpty
                    ? const Text('¡No existen alertas para mostrar!')
                    : Expanded(
                        child: ListView.builder(
                            itemBuilder: (context, index) {
                              return CardAlert(alert: alerts![index]);
                            },
                            itemCount: alerts!.length)),
          ],
        ),
      ),
    );
  }
}

/*
class AlertsViewModel extends ChangeNotifier {
  final AlertsServices _alertsServices = AlertsServices();

  List<Alert>? alerts;
  bool isLoading = false;

  Future<void> fetchAlerts(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    alerts = await _alertsServices.fetchAlerts(context: context);

    isLoading = false;
    notifyListeners();
  }
}

class AlertsProvider extends StatelessWidget {
  // final String paymentId;
  // final void Function(double resumen, List<Amount> registros)? onAceptar;
  // final bool onlySee;

  const AlertsProvider({
    super.key,
    // required this.paymentId,
    // //required this.onAceptar,
    // this.onAceptar,
    // this.onlySee = false
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AlertsViewModel(),
      child: AlertsScreen(
          // onAceptar: onlySee ? null : onAceptar,
          // onlySee: onlySee,
          ),
    );
  }
}

class AlertsScreen extends StatefulWidget {
  static const String routeName = '/alerts';
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final viewModel = Provider.of<AlertsViewModel>(context, listen: false);
      viewModel.fetchAlerts(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AlertsViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          body: ModalProgressHUD(
            color: GlobalVariables.greyBackgroundColor,
            opacity: 0.8,
            blur: 0.8,
            inAsyncCall: viewModel.isLoading,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 15, right: 15),
                  child: MainTitle(title: 'Alertas'),
                ),
                const SizedBox(height: 20),
                viewModel.alerts == null
                    ? const Loader()
                    : viewModel.alerts!.isEmpty
                        ? const Text('¡No existen alertas para mostrar!')
                        : Expanded(
                            child: ListView.builder(
                              itemCount: viewModel.alerts!.length,
                              itemBuilder: (context, index) {
                                return CardAlert(
                                    alert: viewModel.alerts![index]);
                              },
                            ),
                          ),
              ],
            ),
          ),
        );
      },
    );
  }
}
*/