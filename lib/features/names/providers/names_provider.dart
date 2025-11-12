/*class NamesProvider extends ChangeNotifier {
  final NamesServices _namesServices = NamesServices();

  List<PaymentName>? _names;
  bool _isLoading = false;
  bool _isFetched = false; // 👈 para evitar múltiples llamadas

  List<PaymentName>? get names => _names;
  bool get isLoading => _isLoading;

  Future<void> fetchNames({bool forceRefresh = false}) async {
    if (_isFetched && !forceRefresh) return; // 👈 evita llamada repetida

    _isLoading = true;
    notifyListeners();

    try {
      _names = await _namesServices.fetchPaymentNames();
      _isFetched = true;
    } catch (e) {
      debugPrint('Error al cargar nombres: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addName(PaymentName name) {
    _names?.add(name);
    notifyListeners();
  }

  void clearCache() {
    _names = null;
    _isFetched = false;
  }
}*/

import 'package:flutter/material.dart';
import 'package:payments_management/features/names/services/names_services.dart';
import 'package:payments_management/models/name/payment_name.dart';

class NamesProvider with ChangeNotifier {
  final NamesServices _namesServices = NamesServices();

  List<PaymentName> _names = [];
  List<PaymentName> _filteredNames = [];
  bool _isLoading = false;
  bool _initialized = false; // 👈 controla si ya se cargaron los datos

  List<PaymentName> get names => _names;
  List<PaymentName> get filteredNames => _filteredNames;
  bool get isLoading => _isLoading;

  double _scrollOffset = 0.0;
  double get scrollOffset => _scrollOffset;

  void setScrollOffset(double offset) {
    _scrollOffset = offset;
  }

  Future<void> fetchNames({bool forceRefresh = false}) async {
    // 👇 Solo carga si no se cargó antes o si se fuerza
    if (_initialized && !forceRefresh) return;

    _isLoading = true;
    notifyListeners();

    try {
      final fetched = await _namesServices.fetchPaymentNames();
      _names = fetched;
      _filteredNames = fetched;
      _initialized = true;
    } catch (e) {
      debugPrint("Error al obtener nombres: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

/*  void filter(String keyword) {
    if (keyword.isEmpty) {
      _filteredNames = _names;
    } else {
      _filteredNames = _names
          .where(
              (name) => name.name.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }*/

  Future<void> refresh() async {
    // ✅ NO se resetea el scroll
    // final savedOffset = _scrollOffset; // 👈 guardamos la posición actual

    // ✅ Guardamos el scroll y búsqueda actuales
    final savedOffset = _scrollOffset;
    final savedSearch = _lastSearch;

    _initialized = false; // 👈 permite volver a cargar
    await fetchNames(forceRefresh: true);

    // 👇 restauramos la posición guardada
    _scrollOffset = savedOffset;

    // ✅ Restauramos el filtro si había texto en el buscador
    if (savedSearch.isNotEmpty) {
      _filteredNames = _names
          .where((name) =>
              name.name.toLowerCase().contains(savedSearch.toLowerCase()))
          .toList();
    } else {
      _filteredNames = _names;
    }

    notifyListeners();

    //notifyListeners();
  }

  String _lastSearch = '';
  String get lastSearch => _lastSearch;

  void filter(String keyword) {
    _lastSearch = keyword; // 👈 guardamos el texto actual
    if (keyword.isEmpty) {
      _filteredNames = _names;
    } else {
      _filteredNames = _names
          .where(
              (name) => name.name.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  /// 👇 Nueva función: reaplica el último filtro guardado
  void applyLastSearch() {
    if (_lastSearch.isEmpty) {
      _filteredNames = _names;
    } else {
      _filteredNames = _names
          .where((name) =>
              name.name.toLowerCase().contains(_lastSearch.toLowerCase()))
          .toList();
    }
  }

  void clearFilter() {
    _lastSearch = '';
    _filteredNames = _names;
    notifyListeners();
  }
}
