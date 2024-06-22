// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CustomerModel {
  final String? id;
  final String? name;
  final String? passport;
  final String? phoneNumber;
  final String? status;

  CustomerModel(
      {this.id,
      this.name,
      this.passport,
      this.phoneNumber,
      this.status});

  CustomerModel copyWith(
      {String? id,
      String? name,
      String? passport,
      String? phoneNumber,
      String? status}) {
    return CustomerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      passport: passport ?? this.passport,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'passport': passport,
      'phoneNumber': phoneNumber,
      'status': status
    };
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      id: map['id'] as String,
      name: map['name'] as String,
      passport: map['passport'] as String,
      phoneNumber: map['phoneNumber'] as String,
      status: map['status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerModel.fromJson(String source) =>
      CustomerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory CustomerModel.fromJsonToMap(Map<String, dynamic> map) {
    return CustomerModel.fromMap(map);
  }

  @override
  String toString() {
    return 'CustomerModel(id: $id, name: $name, passport: $passport, phoneNumber: $phoneNumber, status:$status)';
  }

  @override
  bool operator ==(covariant CustomerModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.passport == passport &&
        other.phoneNumber == phoneNumber &&
        other.status== status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        passport.hashCode ^
        phoneNumber.hashCode ^
        status.hashCode;
  }
}

class CustomerModelList {
  final List<CustomerModel> customerModel;

  CustomerModelList({
    required this.customerModel,
  });

  factory CustomerModelList.fromJsons(List<dynamic> parsedJson) {
    List<CustomerModel> listOfApp = [];

    listOfApp = parsedJson.map((i) => CustomerModel.fromMap(i)).toList();
    return CustomerModelList(customerModel: listOfApp);
  }
}
