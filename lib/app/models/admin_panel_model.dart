// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AdminPanelModel {
  final String username;
  final String password;
  final String fullName;
  final String role;
  AdminPanelModel({
    required this.username,
    required this.password,
    required this.fullName,
    required this.role,
  });

  AdminPanelModel copyWith({
    String? username,
    String? password,
    String? fullName,
    String? role,
  }) {
    return AdminPanelModel(
      username: username ?? this.username,
      password: password ?? this.password,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'password': password,
      'fullName': fullName,
      'role': role,
    };
  }

  factory AdminPanelModel.fromMap(Map<String, dynamic> map) {
    return AdminPanelModel(
      username: map['username'] as String,
      password: map['password'] as String,
      fullName: map['fullName'] as String,
      role: map['role'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AdminPanelModel.fromJson(String source) =>
      AdminPanelModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AdminPanelModel(username: $username, password: $password, fullName: $fullName, role: $role)';
  }

  @override
  bool operator ==(covariant AdminPanelModel other) {
    if (identical(this, other)) return true;

    return other.username == username &&
        other.password == password &&
        other.fullName == fullName &&
        other.role == role;
  }

  @override
  int get hashCode {
    return username.hashCode ^
        password.hashCode ^
        fullName.hashCode ^
        role.hashCode;
  }
}

class AdminPanelModelList {
  final List<AdminPanelModel> workingAreaModel;

  AdminPanelModelList({
    required this.workingAreaModel,
  });

  factory AdminPanelModelList.fromJson(List<dynamic> parsedJson) {
    List<AdminPanelModel> listOfApp = [];

    listOfApp = parsedJson.map((i) => AdminPanelModel.fromMap(i)).toList();
    return AdminPanelModelList(workingAreaModel: listOfApp);
  }
}
