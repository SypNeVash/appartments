// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:apartments/app/models/work_area_model.dart';

import 'customers_model.dart';
import 'get_all_appart_model.dart';

class SearchPanelModel {
  final WorkingAreaModelList? workArea;
  final CustomerModelList? cards;
  final ApartmentModelList? apps;

  SearchPanelModel({
    this.apps,
    this.cards,
    this.workArea,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
    };
  }

  factory SearchPanelModel.fromMap(Map<String, dynamic> json) {
    return SearchPanelModel(
      apps: ApartmentModelList.fromJson(json["rentObjects"]),
      cards: CustomerModelList.fromJsons(json["customerCards"]),
      workArea: WorkingAreaModelList.fromJson(json["workAreas"]),
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchPanelModel.fromJson(dynamic source) =>
      SearchPanelModel.fromMap(jsonDecode(source) as Map<String, dynamic>);

  factory SearchPanelModel.fromJsonToMap(Map<String, dynamic> map) {
    return SearchPanelModel.fromMap(map);
  }
}

class SearchPanelModelList {
  final List<SearchPanelModel> workingAreaModel;

  SearchPanelModelList({
    required this.workingAreaModel,
  });

  factory SearchPanelModelList.fromJson(List<dynamic> parsedJson) {
    List<SearchPanelModel> listOfApp = [];

    listOfApp = parsedJson.map((i) => SearchPanelModel.fromMap(i)).toList();
    return SearchPanelModelList(workingAreaModel: listOfApp);
  }
}
