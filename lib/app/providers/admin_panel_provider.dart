import 'package:apartments/app/api/admin_panel_api.dart';
import 'package:apartments/app/features/dashboard/views/screens/users/users%20components/filter_condition_for_users.dart';
import 'package:apartments/app/models/admin_panel_model.dart';
import 'package:flutter/material.dart';

class AdminPanelProvider extends ChangeNotifier {
  List<AdminPanelModel> _workingarealist = [];
  bool _isLoading = false;
  String _errorMessage = '';
  int _currentPage = 1;
  Future<List<AdminPanelModel>>? _futureWorkingAreaModelList;
  bool _isSearchActive = false;
  List<FilterCondition> _currentFilters = [];

  List<AdminPanelModel> get apartments => _workingarealist;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  int get currentPage => _currentPage;
  Future<List<AdminPanelModel>>? get futureWorkingModelList =>
      _futureWorkingAreaModelList;

  Future<List<AdminPanelModel>> fetchAdminPanelList(int page) async {
    try {
      _isLoading = true;
      notifyListeners();

      final result = await AdminPanelApi().fetchAdminPanelData(page);
      _workingarealist = result.workingAreaModel;
      _currentPage = page;
      _isSearchActive = false;
      _futureWorkingAreaModelList = Future.value(_workingarealist);

      _isLoading = false;
      _errorMessage = '';

      notifyListeners();
      return _workingarealist;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to fetch apartments: $e';
      notifyListeners();
      return [];
    }
  }

  Future<List<AdminPanelModel>> searchAdminPanel(
      List<FilterCondition> filters, int page) async {
    try {
      _isLoading = true;
      notifyListeners();

      final result = await AdminPanelApi.searchApartments(filters, page);
      _workingarealist = result.workingAreaModel;
      _currentPage = page;
      _isSearchActive = true;
      _currentFilters = filters;
      _futureWorkingAreaModelList = Future.value(_workingarealist);

      _isLoading = false;
      _errorMessage = '';

      notifyListeners();
      return _workingarealist;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to search work area: $e';
      notifyListeners();
      return [];
    }
  }

  void onPageChanged(int page) {
    if (_isSearchActive) {
      searchAdminPanel(_currentFilters, page);
    } else {
      fetchAdminPanelList(page);
    }
  }
}

class FilterCondition {
  final String property;
  final String value;
  final String condition;

  FilterCondition({
    required this.property,
    required this.value,
    required this.condition,
  });

  Map<String, dynamic> toJson() {
    return {
      'property': property,
      'value': value,
      'condition': condition,
    };
  }
}
