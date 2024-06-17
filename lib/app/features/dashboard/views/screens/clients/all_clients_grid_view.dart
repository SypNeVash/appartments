import 'package:apartments/app/api/client_api.dart';
import 'package:apartments/app/constans/app_constants.dart';
import 'package:apartments/app/models/customers_model.dart';
import 'package:apartments/app/utils/animations/show_up_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_pagination/flutter_web_pagination.dart';

import 'clients components/all_clients_grid_comp.dart';
import 'clients components/all_clients_screen.dart';

class AllClientsList extends StatefulWidget {
  const AllClientsList({super.key});

  @override
  State<AllClientsList> createState() => _AllClientsListState();
}

class _AllClientsListState extends State<AllClientsList> {
  ApiClient fetchClientDataFromAzure = ApiClient();

  final int _limit = 10; // Number of items per page
  int _currentPage = 1;
  late Future<CustomerModelList> _futureClientModelList;

  @override
  void initState() {
    _futureClientModelList =
        fetchClientDataFromAzure.fetchClientDataFromAzure(_currentPage, _limit);
    super.initState();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
      print(_currentPage);
      _futureClientModelList = fetchClientDataFromAzure
          .fetchClientDataFromAzure(_currentPage, _limit);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CustomerModelList>(
        future: _futureClientModelList,
        builder: (context, AsyncSnapshot<CustomerModelList> snapshot) {
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
                if (snapshot.data!.customerModel.length <= 1) ...[
                  const FormsLists(),
                  const Center(child: Text('No Kvartira found')),
                ] else ...[
                  const FormsLists(),
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.customerModel.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: kSpacing / 2),
                          child: ShowUp(
                            delay: 400,
                            child: CustomerCard(
                                customer: snapshot.data!.customerModel[index]),
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
                    currentPage: _currentPage,
                    totalPage: 10,
                    displayItemCount: 3,
                    onPageChanged: _onPageChanged,
                  ),
                ),
                const SizedBox(height: 25),
              ],
            );
          } else {
            return const Center(child: Text('No data found'));
          }
        });
  }
}
