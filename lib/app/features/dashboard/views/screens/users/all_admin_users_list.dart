import 'package:apartments/app/api/admin_panel_api.dart';
import 'package:apartments/app/constans/app_constants.dart';
import 'package:apartments/app/models/admin_panel_model.dart';
import 'package:apartments/app/providers/admin_panel_provider.dart';
import 'package:apartments/app/utils/animations/show_up_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_pagination/flutter_web_pagination.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AllUsersFromAdminScreen extends StatefulWidget {
  const AllUsersFromAdminScreen({Key? key}) : super(key: key);

  @override
  State<AllUsersFromAdminScreen> createState() =>
      AllUsersFromAdminScreenState();
}

class AllUsersFromAdminScreenState extends State<AllUsersFromAdminScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminPanelProvider>(context, listen: false)
          .fetchAdminPanelList(1);
    });
  }

  void _showAlertDialog(String userName) async {
    Get.defaultDialog(
      title: "Wait!",
      middleText: "Please confirm",
      textConfirm: "Yes",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        final deleted = await AdminPanelApi().deleteAdminPanelItems(userName);
        if (deleted == true) {
          showSnackBarForConfirmation();
        } else {
          showSnackBarForError();
        }
        Get.back();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Provider.of<AdminPanelProvider>(context, listen: false)
              .fetchAdminPanelList(1);
        }); // Close the dialog
      },
      textCancel: "Back",
      onCancel: () {
        // Perform any action on cancel, if needed
      },
    );
  }

  showSnackBarForConfirmation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          'Sucessfully deleted',
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  showSnackBarForError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Try again'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminPanelProvider>(
      builder: (context, provider, child) {
        return FutureBuilder<List<AdminPanelModel>>(
          future: provider.futureWorkingModelList,
          builder: (BuildContext context,
              AsyncSnapshot<List<AdminPanelModel>> snapshot) {
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
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color.fromARGB(255, 146, 162, 190)
                                            .withOpacity(0.5),
                                    spreadRadius: -5,
                                    blurRadius: 5,
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                                color: Colors.white),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data![index].username,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        snapshot.data![index].fullName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(
                                                255, 106, 106, 106),
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () => _showAlertDialog(snapshot
                                      .data![index].username
                                      .toString()),
                                  child: const FaIcon(
                                    FontAwesomeIcons.trashCan,
                                    color: Colors.blue,
                                    size: 18,
                                  ),
                                )
                              ],
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
                      totalPage: 1000,
                      displayItemCount: 4,
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
