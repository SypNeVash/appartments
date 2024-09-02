import 'package:apartments/app/models/customers_model.dart';
import 'package:apartments/app/models/work_area_model.dart';
import 'package:apartments/app/providers/search_panel_provider.dart';
import 'package:apartments/app/shared_components/responsive_builder.dart';
import 'package:apartments/app/shared_components/search_field.dart';
import 'package:apartments/app/utils/animations/show_up_animation.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../constans/app_constants.dart';
import '../../../../../models/get_all_appart_model.dart';
import '../../../../../shared_components/card_task.dart';
import '../../../../../utils/services/shared_preferences.dart';
import '../apartment_details.dart';
import '../work area/work are components/customer_card_for_working_area.dart' as cd;
import 'clients components/all_clients_grid_comp.dart' as cg;

class SearchClients extends StatefulWidget {
  final String? searchValue;
  
  const SearchClients( this.searchValue, {Key? key}) : super(key: key);


  @override
  State<SearchClients> createState() => _SearchClientsState(searchValue);
}

class _SearchClientsState extends State<SearchClients> {
  final String? searchValue;  

  _SearchClientsState( this.searchValue);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SearchPanelProvider>(context, listen: false).fetchList(searchValue ?? "qqqqqq");
    });
  }

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
          centerTitle: true,
        ),
        body: SafeArea(
            child: ResponsiveBuilder(mobileBuilder: (context, constraints) {
          return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                child: Center(
                  child: Container(
                      constraints: const BoxConstraints(maxWidth: 800),
                      padding: const EdgeInsets.only(top: 10),
                      child: SearchField()),
                ),
              ));
        }, tabletBuilder: (context, constraints) {
          return SingleChildScrollView(
              controller: ScrollController(),
              physics: const BouncingScrollPhysics(),
              child: Center(
                child: Container(
                    constraints: const BoxConstraints(maxWidth: 800),
                    padding: const EdgeInsets.only(top: 10),
                    child: TextField()),
              ));
        }, desktopBuilder: (context, constraints) {
          return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              controller: ScrollController(),
              child: Center(
                child: Container(
                    constraints: const BoxConstraints(maxWidth: 800),
                    padding: const EdgeInsets.only(top: 20, bottom: 35),
                    child: const Column(
                      children: [
                        AllClientsSearchList(),
                        AllAppsSearchList(),
                        AllWorkAreaSearchList()
                      ],
                    )),
              ));
        })));
  }
}


class AllClientsSearchList extends StatefulWidget {
  const AllClientsSearchList({super.key});

  @override
  State<AllClientsSearchList> createState() => _AllClientsSearchListState();
}

class _AllClientsSearchListState extends State<AllClientsSearchList> {

  _AllClientsSearchListState();

   @override
  Widget build(BuildContext context) {
    return Consumer<SearchPanelProvider>(builder: (context, provider, child) {
      return FutureBuilder<List<CustomerModel>>(
          future: provider.futureCustomerSearchModel,
          builder: (context, AsyncSnapshot<List<CustomerModel>> snapshot) {
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
                    const Center(child: Text('Не знайдено клієнта')),
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
                              child:
                                  cg.CustomerCard(customer: snapshot.data![index]),
                            ),
                          );
                        }),
                  ],
                  const SizedBox(
                    height: 25,
                  ),
                  const SizedBox(height: 25),
                ],
              );
            } else {
              return Center(child: Text(snapshot.data.toString()));
            }
          });
    });
  }
}

class AllAppsSearchList extends StatefulWidget {
  const AllAppsSearchList({super.key});

  @override
  State<AllAppsSearchList> createState() => _AllAppsSearchListState();
}

class _AllAppsSearchListState extends State<AllAppsSearchList> {

  _AllAppsSearchListState();

   @override
  Widget build(BuildContext context) {
    return Consumer<SearchPanelProvider>(builder: (context, provider, child) {
      return FutureBuilder<List<ApartmentModel>>(
          future: provider.futureAppsSearchModel,
          builder: (BuildContext context,
              AsyncSnapshot<List<ApartmentModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SizedBox(
                  height: 35,
                  width: 35,
                  child: Padding(
                    padding: EdgeInsets.all(2.0),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Помилка: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return Column(
                children: [
                  if (snapshot.data!.isEmpty) ...[
                    const Text('Аппартаменти не були знайдені'),
                  ] else ...[
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) => Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: kSpacing / 2),
                        child: ShowUp(
                          delay: 400,
                          child: InkWell(
                            hoverColor: Colors.transparent,
                            onTap: () async {
                              await SPHelper.saveIDAptSharedPreference(
                                  snapshot.data![index].id.toString());
                              // Get.toNamed(
                              //   '/apartmentdetail',
                              // );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ApartmentDetail()),
                              );
                            },
                            child: CardTask(
                              data: snapshot.data![index],
                              primary: const Color.fromARGB(255, 105, 188, 255),
                              onPrimary: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(
                    height: 25,
                  ),
                  const SizedBox(height: 25),
                ],
              );
            } else {
              return Center(child: Text(snapshot.data.toString()));
            }
          });
    });
  }
}

class AllWorkAreaSearchList extends StatefulWidget {
  const AllWorkAreaSearchList({super.key});

  @override
  State<AllWorkAreaSearchList> createState() => _AllWorkAreaSearchListState();
}

class _AllWorkAreaSearchListState extends State<AllWorkAreaSearchList> {

  _AllWorkAreaSearchListState();

   @override
  Widget build(BuildContext context) {
    return Consumer<SearchPanelProvider>(builder: (context, provider, child) {
      return FutureBuilder<List<WorkingAreaModel>>(
          future: provider.futureWorkAreaSearchModel,
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
                    const Center(
                        child: Text('Робочі простіри не були знайдені')),
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
                              child: cd.CustomerCardForWorkingAre(
                                  workingAreaModel: snapshot.data![index]),
                            ),
                          );
                        }),
                  ],
                  const SizedBox(
                    height: 25,
                  ),
                  const SizedBox(height: 25),
                ],
              );
            } else {
              return Center(child: Text(snapshot.data.toString()));
            }
          });
    });
  }
}