import 'package:apartments/app/api/client_api.dart';
import 'package:apartments/app/models/customers_model.dart';

import 'package:flutter/material.dart';

import 'appartment_provider.dart';

class ClientProvider extends ChangeNotifier {
  List<CustomerModel> _clients = [];
  bool _isLoading = false;
  String _errorMessage = '';
  int _currentPage = 1;
  Future<List<CustomerModel>>? _futureClientModelList;
  bool _isSearchActive = false;
  List<FilterCondition> _currentFilters = [];

  List<CustomerModel> get clients => _clients;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  int get currentPage => _currentPage;
  Future<List<CustomerModel>>? get futureClientModelList =>
      _futureClientModelList;

  Future<List<CustomerModel>> fetchClients(int page) async {
    try {
      _isLoading = true;
      notifyListeners();

      final result = await ApiClient().fetchClientDataFromAzure(page);
      _clients = result.customerModel;
      _currentPage = page;
      _isSearchActive = false;

      _futureClientModelList = Future.value(_clients);

      _isLoading = false;
      _errorMessage = '';

      notifyListeners();
      return _clients;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to fetch clients: $e';
      notifyListeners();
      return [];
    }
  }

  Future<List<CustomerModel>> searchClients(
      List<FilterCondition> filters, int page) async {
    try {
      _isLoading = true;
      notifyListeners();

      final result = await ApiClient.searchClients(filters, page);
      _clients = result.customerModel;
      _currentPage = page;
      _isSearchActive = true;
      _currentFilters = filters;
      _futureClientModelList = Future.value(_clients);

      _isLoading = false;
      _errorMessage = '';

      notifyListeners();
      return _clients;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to search clients: $e';
      notifyListeners();
      return [];
    }
  }

  void onPageChanged(int page) {
    if (_isSearchActive) {
      searchClients(_currentFilters, page);
    } else {
      fetchClients(page);
    }
  }
}
