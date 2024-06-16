import 'package:apartments/app/features/dashboard/views/screens/clients/all_clients_grid_view.dart';
import 'package:apartments/app/shared_components/responsive_builder.dart';
import 'package:flutter/material.dart';

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
    return const Column(
      children: [
        Text(
          'Adding new appartment',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        Text(
          'Please fill the form',
          style: TextStyle(fontSize: 15),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
