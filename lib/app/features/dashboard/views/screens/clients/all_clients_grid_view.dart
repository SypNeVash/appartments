import 'package:apartments/app/models/customers_model.dart';
import 'package:flutter/material.dart';

import 'clients components/all_clients_grid_comp.dart';

class AllClientsList extends StatefulWidget {
  const AllClientsList({super.key});

  @override
  State<AllClientsList> createState() => _AllClientsListState();
}

class _AllClientsListState extends State<AllClientsList> {
  final List<CustomerModel> customers = [
    CustomerModel(
      id: '1',
      name: 'John',
      surname: 'Doe',
      patronymic: 'Johnovich',
      passport: '123456',
      phoneNumber: '123-456-7890',
      address: '123 Main St',
      birthday: '1980-01-01',
      password: 'password123',
      username: 'johndoe',
      email: 'john.doe@example.com',
    ),
    CustomerModel(
      id: '1',
      name: 'John',
      surname: 'Doe',
      patronymic: 'Johnovich',
      passport: '123456',
      phoneNumber: '123-456-7890',
      address: '123 Main St',
      birthday: '1980-01-01',
      password: 'password123',
      username: 'johndoe',
      email: 'john.doe@example.com',
    ),
    CustomerModel(
      id: '1',
      name: 'John',
      surname: 'Doe',
      patronymic: 'Johnovich',
      passport: '123456',
      phoneNumber: '123-456-7890',
      address: '123 Main St',
      birthday: '1980-01-01',
      password: 'password123',
      username: 'johndoe',
      email: 'john.doe@example.com',
    ),
    CustomerModel(
      id: '1',
      name: 'John',
      surname: 'Doe',
      patronymic: 'Johnovich',
      passport: '123456',
      phoneNumber: '123-456-7890',
      address: '123 Main St',
      birthday: '1980-01-01',
      password: 'password123',
      username: 'johndoe',
      email: 'john.doe@example.com',
    ),
    CustomerModel(
      id: '1',
      name: 'John',
      surname: 'Doe',
      patronymic: 'Johnovich',
      passport: '123456',
      phoneNumber: '123-456-7890',
      address: '123 Main St',
      birthday: '1980-01-01',
      password: 'password123',
      username: 'johndoe',
      email: 'john.doe@example.com',
    ),
    CustomerModel(
      id: '1',
      name: 'John',
      surname: 'Doe',
      patronymic: 'Johnovich',
      passport: '123456',
      phoneNumber: '123-456-7890',
      address: '123 Main St',
      birthday: '1980-01-01',
      password: 'password123',
      username: 'johndoe',
      email: 'john.doe@example.com',
    ),
    CustomerModel(
      id: '1',
      name: 'John',
      surname: 'Doe',
      patronymic: 'Johnovich',
      passport: '123456',
      phoneNumber: '123-456-7890',
      address: '123 Main St',
      birthday: '1980-01-01',
      password: 'password123',
      username: 'johndoe',
      email: 'john.doe@example.com',
    ),
    CustomerModel(
      id: '1',
      name: 'John',
      surname: 'Doe',
      patronymic: 'Johnovich',
      passport: '123456',
      phoneNumber: '123-456-7890',
      address: '123 Main St',
      birthday: '1980-01-01',
      password: 'password123',
      username: 'johndoe',
      email: 'john.doe@example.com',
    ),
    CustomerModel(
      id: '1',
      name: 'John',
      surname: 'Doe',
      patronymic: 'Johnovich',
      passport: '123456',
      phoneNumber: '123-456-7890',
      address: '123 Main St',
      birthday: '1980-01-01',
      password: 'password123',
      username: 'johndoe',
      email: 'john.doe@example.com',
    ),
    CustomerModel(
      id: '1',
      name: 'John',
      surname: 'Doe',
      patronymic: 'Johnovich',
      passport: '123456',
      phoneNumber: '123-456-7890',
      address: '123 Main St',
      birthday: '1980-01-01',
      password: 'password123',
      username: 'johndoe',
      email: 'john.doe@example.com',
    ),
    // Add more customers here...
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: CustomerGrid(customers: customers),
    );
  }
}
