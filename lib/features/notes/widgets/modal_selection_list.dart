import 'package:flutter/material.dart';
import 'package:payments_management/features/historical/services/historical_services.dart';
import 'package:payments_management/features/names/services/names_services.dart';
import 'package:payments_management/models/name/payment_name.dart';
import 'package:payments_management/models/payment/payment.dart';

class ModalSelectionList extends StatefulWidget {
  final String type; // 'PAGO' o 'NOMBRE'
  const ModalSelectionList({
    super.key,
    required this.type,
  });

  @override
  State<ModalSelectionList> createState() => _SelectDialogState();
}

class _SelectDialogState extends State<ModalSelectionList> {
  final HistoricalServices historicalServices = HistoricalServices();
  final NamesServices namesServices = NamesServices();
  String _search = '';
  List<Payment> _payments = [];
  List<PaymentName> _names = [];
  bool _paymentsLoading = true;
  bool _namesLoading = true;

  Future<void> _loadPayments() async {
    setState(() => _paymentsLoading = true);
    final data = await historicalServices.fetchAllPayments();
    setState(() {
      _payments = data;
      _paymentsLoading = false;
    });
  }

  Future<void> _loadNames() async {
    setState(() => _namesLoading = true);
    final data = await namesServices.fetchPaymentNames();
    setState(() {
      _names = data;
      _namesLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPayments();
    _loadNames();
  }

  @override
  Widget build(BuildContext context) {
    final isPago = widget.type == 'PAGO';

    // final isLoading = isPago ? _paymentsLoading : _namesLoading;
    List<dynamic> items = isPago ? _payments : _names;

    final filtered = isPago
        ? items
            .where((item) =>
                item.name.name.toLowerCase().contains(_search.toLowerCase()))
            .toList()
        : items
            .where((item) =>
                item.name.toLowerCase().contains(_search.toLowerCase()))
            .toList();

    return AlertDialog(
      title: Text('Seleccionar ${widget.type}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(hintText: 'Buscar...'),
            onChanged: (value) => setState(() => _search = value),
          ),
          const SizedBox(height: 10),
          Flexible(
            child: SizedBox(
              //  Expanded(
              width: double.maxFinite,
              height: 300,
              child: _paymentsLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (ctx, i) => ListTile(
                        title: Text(widget.type == "PAGO"
                            ? '${filtered[i].name.name} - ${filtered[i].period}'
                            : filtered[i].name),
                        onTap: () => Navigator.pop(context, {
                          'id': filtered[i].id,
                          'name': widget.type == "PAGO"
                              ? '${filtered[i].name.name} - ${filtered[i].period}'
                              : filtered[i].name,
                        }),
                      ),
                    ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
