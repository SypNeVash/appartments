import 'package:apartments/app/features/dashboard/views/screens/users/add_new_user.dart';
import 'package:apartments/app/features/dashboard/views/screens/users/all_admin_users_list.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class UsersDashboard extends StatefulWidget {
  const UsersDashboard({super.key});

  @override
  State<UsersDashboard> createState() => _UsersDashboardState();
}

class _UsersDashboardState extends State<UsersDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(EvaIcons.arrowBack),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddNewUsers()),
                );
              },
              child: const Row(
                children: [
                  Text(
                    'Додати',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(EvaIcons.plus),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Column(
            children: [
              Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  child: const Column(
                    children: [
                      FormsListForUsersDashboard(),
                      AllUsersFromAdminScreen()
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class FormsListForUsersDashboard extends StatelessWidget {
  const FormsListForUsersDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'All users',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}
