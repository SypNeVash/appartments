import 'package:flutter/material.dart';

import '../api/work_are_api.dart';
import '../models/customers_model.dart';
import '../models/get_all_appart_model.dart';
import '../models/work_area_model.dart';

class SearchPanelProvider extends ChangeNotifier {
  List<CustomerModel> _clients = [];
  bool _isLoading = false;
  String _errorMessage = '';
  Future<List<CustomerModel>>? _futureCustomerModelList;
  Future<List<WorkingAreaModel>>? _futureWorkAreaModelList;
  Future<List<ApartmentModel>>? _futureAppsModelList;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  Future<List<CustomerModel>>? get futureCustomerSearchModel =>
      _futureCustomerModelList;
  Future<List<WorkingAreaModel>>? get futureWorkAreaSearchModel =>
      _futureWorkAreaModelList;
  Future<List<ApartmentModel>>? get futureAppsSearchModel =>
      _futureAppsModelList;


  Future<List<CustomerModel>> fetchList(String phone) async {
    try {
      _isLoading = true;
      notifyListeners();

      final result = await WorkAreApi().searchAllData(phone);
      _futureCustomerModelList = Future.value(result.cards?.customerModel ?? []);
      _futureWorkAreaModelList = Future.value(result.workArea?.workingAreaModel ?? []);
      _futureAppsModelList =  Future.value(result.apps?.apartmentModel ?? []);

      _isLoading = false;
      _errorMessage = '';

      notifyListeners();
      return result.cards?.customerModel ?? [];
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to fetch apartments: $e';
      notifyListeners();
      return [];
    }
  }


  void onPageChanged(int page) {
    
  }
}
