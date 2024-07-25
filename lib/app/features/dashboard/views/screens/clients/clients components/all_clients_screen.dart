import 'package:apartments/app/constans/app_constants.dart';
import 'package:apartments/app/features/dashboard/views/screens/clients/add_new_clients.dart';
import 'package:apartments/app/features/dashboard/views/screens/dashboard_screen.dart';
import 'package:apartments/app/shared_components/search_field.dart';
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
  final bool? openDrawer;
  const FormsLists({this.openDrawer, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find<DashboardController>();

    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 25, right: 25),
      child: Column(
        children: [
          Row(
            children: [
              if (openDrawer != null || openDrawer == true)
                Padding(
                  padding: const EdgeInsets.only(right: kSpacing / 2),
                  child: IconButton(
                    onPressed: controller.openDrawer,
                    icon: const Icon(Icons.menu),
                  ),
                ),
              Expanded(
                child: SearchField(
                  onSearch: controller.searchTask,
                  hintText: "Пошук .. ",
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddingNewClients()),
                  );
                },
                child: const Text(
                  '+ Додати нового клієнта',
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
