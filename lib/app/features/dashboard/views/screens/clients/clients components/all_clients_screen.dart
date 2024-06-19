import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// class AllClientsScreen extends StatefulWidget {
//   const AllClientsScreen({Key? key}) : super(key: key);

//   @override
//   State<AllClientsScreen> createState() => _AllClientsScreenState();
// }

// class _AllClientsScreenState extends State<AllClientsScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: SafeArea(
//             child: ResponsiveBuilder(mobileBuilder: (context, constraints) {
//       return const SingleChildScrollView(
//           child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
//         child: Column(
//           children: [FormsLists(), AllClientsList()],
//         ),
//       ));
//     }, tabletBuilder: (context, constraints) {
//       return SingleChildScrollView(
//           controller: ScrollController(),
//           child: Container(
//               constraints: const BoxConstraints(maxWidth: 400),
//               child: const Column(
//                 children: [FormsLists(), AllClientsList()],
//               )));
//     }, desktopBuilder: (context, constraints) {
//       return SingleChildScrollView(
//           scrollDirection: Axis.vertical,
//           controller: ScrollController(),
//           child: Center(
//             child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 55,
//                 ),
//                 child: const Column(
//                   children: [
//                     Text(' wdwdwdwdwdw'),
//                     Expanded(child: FormsLists()),
//                     AllClientsList(),
//                   ],
//                 )),
//           ));
//     })));
//   }
// }

class FormsLists extends StatelessWidget {
  const FormsLists({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 28.0),
      child: Column(
        children: [
          const TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(EvaIcons.search),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(width: .1),
              ),
              hintText: 'Search for clients',
            ),
            textInputAction: TextInputAction.search,
            style: TextStyle(color: Colors.black),
          ),
          const SizedBox(
            height: 20,
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: () {
                  Get.toNamed('/addingNewClient');
                },
                child: const Text(
                  '+ Add new client',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              )),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
