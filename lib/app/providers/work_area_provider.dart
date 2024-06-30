import 'package:apartments/app/api/work_are_api.dart';
import 'package:apartments/app/models/work_area_model.dart';
import 'package:flutter/material.dart';

import 'appartment_provider.dart';

class WorkAreaProvider extends ChangeNotifier {
  List<WorkingAreaModel> _workingarealist = [];
  bool _isLoading = false;
  String _errorMessage = '';
  int _currentPage = 1;
  Future<List<WorkingAreaModel>>? _futureWorkingAreaModelList;
  bool _isSearchActive = false;
  List<FilterCondition> _currentFilters = [];

  List<WorkingAreaModel> get apartments => _workingarealist;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  int get currentPage => _currentPage;
  Future<List<WorkingAreaModel>>? get futureWorkingModelList =>
      _futureWorkingAreaModelList;

  Future<List<WorkingAreaModel>> fetchWorkingAreaList(int page) async {
    try {
      _isLoading = true;
      notifyListeners();

      final result = await WorkAreApi().fetchWorkinAreData(page);
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

  Future<List<WorkingAreaModel>> searchWorkArea(
      List<FilterCondition> filters, int page) async {
    try {
      _isLoading = true;
      notifyListeners();
      _currentFilters = filters;

      final result = await WorkAreApi.searchWorkArea(filters, page);
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

  void onPageChanged(int page) {
      searchWorkArea(_currentFilters, page);
  }
}
