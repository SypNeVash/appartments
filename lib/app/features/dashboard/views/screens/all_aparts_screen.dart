import 'package:apartments/app/constans/app_constants.dart';
import 'package:apartments/app/features/dashboard/views/screens/apartment_details.dart';
import 'package:apartments/app/models/get_all_appart_model.dart';
import 'package:apartments/app/providers/appartment_provider.dart';
import 'package:apartments/app/shared_components/card_task.dart';
import 'package:apartments/app/utils/animations/show_up_animation.dart';
import 'package:apartments/app/utils/services/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_pagination/flutter_web_pagination.dart';
import 'package:provider/provider.dart';

class AllApartmentsScreen extends StatefulWidget {
  const AllApartmentsScreen({Key? key}) : super(key: key);

  @override
  State<AllApartmentsScreen> createState() => AllApartmentsScreenState();
}

class AllApartmentsScreenState extends State<AllApartmentsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ApartmentProvider>(context, listen: false).fetchApartments(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApartmentProvider>(
      builder: (context, provider, child) {
        return FutureBuilder<List<ApartmentModel>>(
          future: provider.futureApartmentModelList,
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
                  const SizedBox(height: 25),
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
              return const Center(child: Text('Завантаження'));
            }
          },
        );
      },
    );
  }
}
