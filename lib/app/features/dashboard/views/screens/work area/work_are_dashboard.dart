import 'package:apartments/app/constans/app_constants.dart';
import 'package:apartments/app/features/dashboard/views/screens/dashboard_screen.dart';
import 'package:apartments/app/features/dashboard/views/screens/work%20area/work%20are%20components/customer_card_for_working_area.dart';
import 'package:apartments/app/models/work_area_model.dart';
import 'package:apartments/app/providers/work_area_provider.dart';
import 'package:apartments/app/shared_components/search_field.dart';
import 'package:apartments/app/utils/animations/show_up_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_pagination/flutter_web_pagination.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

// class WorkingAreaDashboard extends StatefulWidget {
//   const WorkingAreaDashboard({super.key});

//   @override
//   State<WorkingAreaDashboard> createState() => _WorkingAreaDashboardState();
// }

// class _WorkingAreaDashboardState extends State<WorkingAreaDashboard> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: ResponsiveBuilder(
//           mobileBuilder: (context, constraints) {
//             return const SingleChildScrollView(
//               child: const Column(),
//             );
//           },
//           tabletBuilder: (context, constraints) {
//             return const SingleChildScrollView();
//           },
//           desktopBuilder: (context, constraints) {
//             return const SingleChildScrollView();
//           },
//         ),
//       ),
//     );
//   }
// }

class WorkingAreaDashboard extends StatefulWidget {
  final bool? openDrawer;

  const WorkingAreaDashboard({this.openDrawer, super.key});

  @override
  State<WorkingAreaDashboard> createState() => _WorkingAreaDashboardState();
}

class _WorkingAreaDashboardState extends State<WorkingAreaDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FormsLists(
            openDrawer: widget.openDrawer,
          ),
          const WorkingAreaList(),
        ],
      ),
    );
  }
}

class WorkingAreaList extends StatefulWidget {
  const WorkingAreaList({super.key});

  @override
  State<WorkingAreaList> createState() => _WorkingAreaListState();
}

class _WorkingAreaListState extends State<WorkingAreaList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WorkAreaProvider>(context, listen: false)
          .fetchWorkingAreaList(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkAreaProvider>(builder: (context, provider, child) {
      return FutureBuilder<List<WorkingAreaModel>>(
          future: provider.futureWorkingModelList,
          builder: (context, AsyncSnapshot<List<WorkingAreaModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: SizedBox(
                      height: 35,
                      width: 35,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return Column(
                children: [
                  if (snapshot.data!.isEmpty) ...[
                    const Center(child: Text('No Client Found')),
                  ] else ...[
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: kSpacing, vertical: kSpacing / 2),
                            child: ShowUp(
                              delay: 400,
                              child: CustomerCardForWorkingAre(
                                  workingAreaModel: snapshot.data![index]),
                            ),
                          );
                        }),
                  ],
                  const SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: WebPagination(
                      currentPage: provider.currentPage,
                      totalPage: 10,
                      displayItemCount: 3,
                      onPageChanged: (page) => provider.onPageChanged(page),
                    ),
                  ),
                  const SizedBox(height: 25),
                ],
              );
            } else {
              return const Center(child: Text('Loading data'));
            }
          });
    });
  }
}

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
                  hintText: "Search .. ",
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
                  Get.toNamed('/addingNewWorkArea');
                },
                child: const Text(
                  '+ New Work Are',
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
