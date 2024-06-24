// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class WorkingAreaModel {
  final String id;
  final CustomerCard customerCard;
  final String responsibleStaff;
  final String rate;
  final List<String> regions;
  final List<String> typesAppart;
  final String price;
  final String minFloor;
  final String maxFloor;
  final String residents;
  final String link;
  final String registration;
  final String checkIn;
  final String comments;
  final String task;
  final List<String> chat;

  WorkingAreaModel({
    required this.id,
    required this.customerCard,
    required this.responsibleStaff,
    required this.rate,
    required this.regions,
    required this.typesAppart,
    required this.price,
    required this.minFloor,
    required this.maxFloor,
    required this.residents,
    required this.link,
    required this.registration,
    required this.checkIn,
    required this.comments,
    required this.task,
    required this.chat,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'customerCard': customerCard.toJson(),
      'responsibleStaff': responsibleStaff,
      'rate': rate,
      'regions': regions,
      'typesAppart': typesAppart,
      'price': price,
      'minFloor': minFloor,
      'maxFloor': maxFloor,
      'residents': residents,
      'link': link,
      'registration': registration,
      'checkIn': checkIn,
      'comments': comments,
      'task': task,
      'chat': chat,
    };
  }

  factory WorkingAreaModel.fromMap(Map<String, dynamic> json) {
    return WorkingAreaModel(
      id: json['id'],
      customerCard: CustomerCard.fromJson(json['customerCard']),
      responsibleStaff: json['responsibleStaff'],
      rate: json['rate'],
      regions: List<String>.from(json['regions']),
      typesAppart: List<String>.from(json['typesAppart']),
      price: json['price'],
      minFloor: json['minFloor'],
      maxFloor: json['maxFloor'],
      residents: json['residents'],
      link: json['link'],
      registration: json['registration'],
      checkIn: json['checkIn'],
      comments: json['comments'],
      task: json['task'],
      chat: List<String>.from(json['chat']),
    );
  }

  String toJson() => json.encode(toMap());

  factory WorkingAreaModel.fromJson(String source) =>
      WorkingAreaModel.fromMap(jsonDecode(source) as Map<String, dynamic>);

  factory WorkingAreaModel.fromJsonToMap(Map<String, dynamic> map) {
    return WorkingAreaModel.fromMap(map);
  }
}

// List<WorkingAreaModel> apartFromJson(String str) => List<WorkingAreaModel>.from(
//     json.decode(str).map((x) => WorkingAreaModel.fromJson(x)));

class CustomerCard {
  final String id;
  final String name;
  final String passport;
  final String phoneNumber;
  final String role;
  final String status;

  CustomerCard({
    required this.id,
    required this.name,
    required this.passport,
    required this.phoneNumber,
    required this.role,
    required this.status,
  });

  factory CustomerCard.fromJson(Map<String, dynamic> json) {
    return CustomerCard(
      id: json['id'],
      name: json['name'],
      passport: json['passport'],
      phoneNumber: json['phoneNumber'],
      role: json['role'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'passport': passport,
      'phoneNumber': phoneNumber,
      'role': role,
      'status': status,
    };
  }

  factory CustomerCard.fromJsonToMap(Map<String, dynamic> map) {
    return CustomerCard.fromJson(map);
  }
}

class WorkingAreaModelList {
  final List<WorkingAreaModel> workingAreaModel;

  WorkingAreaModelList({
    required this.workingAreaModel,
  });

  factory WorkingAreaModelList.fromJson(List<dynamic> parsedJson) {
    List<WorkingAreaModel> listOfApp = [];

    listOfApp = parsedJson.map((i) => WorkingAreaModel.fromMap(i)).toList();
    return WorkingAreaModelList(workingAreaModel: listOfApp);
  }
}
