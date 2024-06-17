// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CustomerModel {
  final String? id;
  final String? name;
  final String? surname;
  final String? patronymic;
  final String? passport;
  final String? phoneNumber;
  final String? address;
  final String? birthday;
  final String? password;
  final String? username;
  final String? email;

  CustomerModel({
    this.id,
    this.name,
    this.surname,
    this.patronymic,
    this.passport,
    this.phoneNumber,
    this.address,
    this.birthday,
    this.password,
    this.username,
    this.email,
  });

  CustomerModel copyWith({
    String? id,
    String? name,
    String? surname,
    String? patronymic,
    String? passport,
    String? phoneNumber,
    String? address,
    String? birthday,
    String? password,
    String? username,
    String? email,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      patronymic: patronymic ?? this.patronymic,
      passport: passport ?? this.passport,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      birthday: birthday ?? this.birthday,
      password: password ?? this.password,
      username: username ?? this.username,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'surname': surname,
      'patronymic': patronymic,
      'passport': passport,
      'phoneNumber': phoneNumber,
      'address': address,
      'birthday': birthday,
      'password': password,
      'username': username,
      'email': email,
    };
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      id: map['id'] as String,
      name: map['name'] as String,
      surname: map['surname'] as String,
      patronymic: map['patronymic'] as String,
      passport: map['passport'] as String,
      phoneNumber: map['phoneNumber'] as String,
      address: map['address'] as String,
      birthday: map['birthday'] as String,
      // password: map['password'] as String : null,
      username: map['username'] as String,
      email: map['email'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerModel.fromJson(String source) =>
      CustomerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CustomerModel(id: $id, name: $name, surname: $surname, patronymic: $patronymic, passport: $passport, phoneNumber: $phoneNumber, address: $address, birthday: $birthday, password: $password, username: $username, email: $email)';
  }

  @override
  bool operator ==(covariant CustomerModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.surname == surname &&
        other.patronymic == patronymic &&
        other.passport == passport &&
        other.phoneNumber == phoneNumber &&
        other.address == address &&
        other.birthday == birthday &&
        other.password == password &&
        other.username == username &&
        other.email == email;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        surname.hashCode ^
        patronymic.hashCode ^
        passport.hashCode ^
        phoneNumber.hashCode ^
        address.hashCode ^
        birthday.hashCode ^
        password.hashCode ^
        username.hashCode ^
        email.hashCode;
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
