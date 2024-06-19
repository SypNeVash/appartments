import 'package:apartments/app/api/client_api.dart';
import 'package:apartments/app/constans/app_constants.dart';
import 'package:apartments/app/models/customers_model.dart';
import 'package:apartments/app/providers/clients_provider.dart';
import 'package:apartments/app/utils/animations/show_up_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_pagination/flutter_web_pagination.dart';
import 'package:provider/provider.dart';

import 'clients components/all_clients_grid_comp.dart';
import 'clients components/all_clients_screen.dart';

class AllClientsList extends StatefulWidget {
  const AllClientsList({super.key});

  @override
  State<AllClientsList> createState() => _AllClientsListState();
}

class _AllClientsListState extends State<AllClientsList> {
  ApiClient fetchClientDataFromAzure = ApiClient();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ClientProvider>(context, listen: false).fetchClients(1);
    });
  }

  // @override
  // void initState() {
  //   _futureClientModelList =
  //       fetchClientDataFromAzure.fetchClientDataFromAzure(_currentPage);
  //   super.initState();
  // }

  // void _onPageChanged(int page) {
  //   setState(() {
  //     _currentPage = page;
  //     _futureClientModelList =
  //         fetchClientDataFromAzure.fetchClientDataFromAzure(
  //       _currentPage,
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<ClientProvider>(builder: (context, provider, child) {
      return FutureBuilder<List<CustomerModel>>(
          future: provider.futureClientModelList,
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
                  if (snapshot.data!.length <= 1) ...[
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
                              child:
                                  CustomerCard(customer: snapshot.data![index]),
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
                      onPageChanged: provider.fetchClients,
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

class AllClientsMain extends StatelessWidget {
  const AllClientsMain({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [FormsLists(), AllClientsList()],
    );
  }
}
