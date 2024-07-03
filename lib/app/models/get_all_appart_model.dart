// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ApartmentModel {
  final String? id;
  final String? contactPerson;
  final String? address;
  final String? city;
  final String? region;
  final String? square;
  final double? price;
  final String? type;
  final String? description;
  final String? comment;
  final String? phone;
  final String? floor;
  final String? maxFloor;
  final String? status;
  final String? createdData;
  final String? updatedUser;
  final List? photos;
  final int? secondId;
  final String? lastUpdate;

  ApartmentModel({
    this.id,
    this.contactPerson,
    this.address,
    this.city,
    this.region,
    this.square,
    this.price,
    this.type,
    this.description,
    this.comment,
    this.phone,
    this.floor,
    this.maxFloor,
    this.createdData,
    this.status,
    this.updatedUser,
    this.photos,
    this.secondId,
    this.lastUpdate
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'contactPerson': contactPerson,
      'address': address,
      'city': city,
      'region': region,
      'square': square,
      'price': price,
      'type': type,
      'description': description,
      'comment': comment,
      'phone': phone,
      'floor': floor,
      'maxFloor': maxFloor,
      'photos': photos,
      'status': status,
      'createdData': createdData,
      'updatedUser': updatedUser,
      'secondId': secondId,
      'lastUpdate': lastUpdate
    };
  }

  factory ApartmentModel.fromMap(Map<String, dynamic> map) {
    return ApartmentModel(
      id: map['id'] as String,
      contactPerson: map['contactPerson'] as String,
      address: map['address'] as String,
      city: map['city'] as String,
      region: map['region'] as String,
      square: map['square'] as String,
      price: map['price'] as double,
      type: map['type'] as String,
      description: map['description'] as String,
      comment: map['comment'] as String,
      phone: map['phone'] as String,
      floor: map['floor'] as String,
      maxFloor: map['maxFloor'] as String,
      photos: List.from((map['photos'] as List)),
      status: map['status'] as String,
      createdData: map['createdData'] as String,
      updatedUser: map['updatedUser'] as String,
      secondId: map['secondId'] as int,
      lastUpdate: map['lastUpdate'] as String
    );
  }

  String toJson() => json.encode(toMap());

  factory ApartmentModel.fromJson(String source) =>
      ApartmentModel.fromMap(jsonDecode(source) as Map<String, dynamic>);

  factory ApartmentModel.fromJsonToMap(Map<String, dynamic> map) {
    return ApartmentModel.fromMap(map);
  }
}

// List<ApartmentModel> apartFromJson(String str) => List<ApartmentModel>.from(
//     json.decode(str).map((x) => ApartmentModel.fromJson(x)));

class ApartmentModelList {
  final List<ApartmentModel> apartmentModel;

  ApartmentModelList({
    required this.apartmentModel,
  });

  factory ApartmentModelList.fromJson(List<dynamic> parsedJson) {
    List<ApartmentModel> listOfApp = [];

    listOfApp = parsedJson.map((i) => ApartmentModel.fromMap(i)).toList();
    return ApartmentModelList(apartmentModel: listOfApp);
  }
}
