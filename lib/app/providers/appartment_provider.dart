import 'dart:collection';
import 'dart:typed_data';

import 'package:apartments/app/api/all_apartments_api.dart';

import 'package:apartments/app/models/get_all_appart_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AppartDetailsListener with ChangeNotifier {
  ApartmentModel? apartmentModel;

  bool? useDifferentFormat;
  List? allPortfolioImagesWithNotifier = [];
  int pageIndex = 0;
  String phoneNumberFilter = '';
  List<XFile> xfileList = [];
  List<Uint8List?> unitfileList = [];
  List<ApartmentModel> portfolioModelList = [];
  ApartmentModel? get getApartModel => apartmentModel;
  List<XFile> get getXfileList => xfileList;
  List<Uint8List?> get getunitfileList => unitfileList;
  UnmodifiableListView<ApartmentModel> get getPortfolioModelList =>
      UnmodifiableListView(portfolioModelList);
  get getuseDifferentFormat => useDifferentFormat;
  get getAllPortfolioImagesWithNotifier => allPortfolioImagesWithNotifier;
  int get getPageIndex => pageIndex;
  get getphoneNumberForFilter => phoneNumberFilter;

  set setApartmentModel(ApartmentModel apartmentModels) {
    apartmentModel = apartmentModels;
    notifyListeners();
  }

  set setUseDifferentFormat(bool differentFormat) {
    useDifferentFormat = differentFormat;
    notifyListeners();
  }

  setXfileList(dynamic xfileListData) {
    xfileList.addAll(xfileListData);
    notifyListeners();
  }

  setunitfileList(Uint8List ufileListData) {
    ufileListData.addAll(ufileListData);
    notifyListeners();
  }

  set setPortFolioModelList(List<ApartmentModel> portfolioModelLists) {
    portfolioModelList = portfolioModelLists;
    notifyListeners();
  }

  set setAllPortfolioImagesWithNotifier(List? imagesList) {
    allPortfolioImagesWithNotifier = imagesList;
    notifyListeners();
  }

  set setPageIndex(int pageInd) {
    pageIndex = pageInd;
    notifyListeners();
  }

  set setPhoneNumberForFilter(String phoneNumber) {
    phoneNumberFilter = phoneNumber;
    notifyListeners();
  }

  bool? mobile;
  get getMobile => mobile;
  set setMobile(bool? mobileOrNot) {
    mobile = mobileOrNot;
    notifyListeners();
  }
}

// class ApartmentProvider extends ChangeNotifier {
//   RemoteApi remoteApi = RemoteApi();
//   final int limit = 10;
//   int currentPage = 1;
//   Future<ApartmentModelList>? _futureApartmentModelList;

//   Future<ApartmentModelList>? get getfutureApartmentModelList =>
//       _futureApartmentModelList;

//   void fetchApartments(int page) {
//     currentPage = page;
//     _futureApartmentModelList =
//         remoteApi.fetchDataFromAzure(currentPage, limit);
//     notifyListeners();
//   }
// }

class ApartmentProvider extends ChangeNotifier {
  List<ApartmentModel> _apartments = [];
  bool _isLoading = false;
  String _errorMessage = '';
  int _currentPage = 1;
  Future<List<ApartmentModel>>? _futureApartmentModelList;
  bool _isSearchActive = false;
  List<FilterCondition> _currentFilters = [];

  List<ApartmentModel> get apartments => _apartments;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  int get currentPage => _currentPage;
  Future<List<ApartmentModel>>? get futureApartmentModelList =>
      _futureApartmentModelList;

  Future<List<ApartmentModel>> fetchApartments(int page) async {
    try {
      _isLoading = true;
      notifyListeners();

      final result = await RemoteApi().fetchDataFromAzure(page);
      _apartments = result.apartmentModel;
      _currentPage = page;
      _isSearchActive = false;
      _futureApartmentModelList = Future.value(_apartments);

      _isLoading = false;
      _errorMessage = '';

      notifyListeners();
      return _apartments;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to fetch apartments: $e';
      notifyListeners();
      return [];
    }
  }

  Future<List<ApartmentModel>> searchApartments(
      List<FilterCondition> filters, int page) async {
    try {
      _isLoading = true;
      notifyListeners();

      final result = await RemoteApi.searchApartments(filters, page);
      _apartments = result.apartmentModel;
      _currentPage = page;
      _isSearchActive = true;
      _currentFilters = filters;
      _futureApartmentModelList = Future.value(_apartments);

      _isLoading = false;
      _errorMessage = '';

      notifyListeners();
      return _apartments;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to search apartments: $e';
      notifyListeners();
      return [];
    }
  }

  void onPageChanged(int page) {
    if (_isSearchActive) {
      searchApartments(_currentFilters, page);
    } else {
      fetchApartments(page);
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
