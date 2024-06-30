import 'dart:convert';

class CustomerModel {
  final String? id;
  final String? name;
  final String? passport;
  final String? phoneNumber;
  final String? role;
  final String? status;
  final String? comment;

  CustomerModel({
    this.id,
    this.name,
    this.passport,
    this.phoneNumber,
    this.role,
    this.status,
    this.comment,
  });

  CustomerModel copyWith({
    String? id,
    String? name,
    String? passport,
    String? phoneNumber,
    String? role,
    String? status,
    String? comment,
  }) {
    return CustomerModel(
        id: id ?? this.id,
        name: name ?? this.name,
        passport: passport ?? this.passport,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        role: role ?? this.role,
        status: status ?? this.status,
        comment: comment ?? this.comment);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'passport': passport,
      'phoneNumber': phoneNumber,
      'role': role,
      'status': status,
      'comment': comment,
    };
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      id: map['id'],
      name: map['name'],
      passport: map['passport'],
      phoneNumber: map['phoneNumber'],
      role: map['role'],
      status: map['status'],
      comment: map['comment'],
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
    return 'CustomerModel(id: $id, name: $name, passport: $passport, phoneNumber: $phoneNumber, comment: $comment, status:$status, role:$role)';
  }

  @override
  bool operator ==(covariant CustomerModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.passport == passport &&
        other.phoneNumber == phoneNumber &&
        other.status == status &&
        other.role == role &&
        other.comment == comment;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        passport.hashCode ^
        phoneNumber.hashCode ^
        comment.hashCode ^
        role.hashCode ^
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
