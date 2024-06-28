import 'package:apartments/app/constans/app_constants.dart';
import 'package:apartments/app/features/dashboard/views/screens/clients/crud_client_api.dart';
import 'package:apartments/app/features/dashboard/views/screens/clients/edit_clients_dat.dart';
import 'package:apartments/app/models/customers_model.dart';
import 'package:apartments/app/providers/clients_provider.dart';
import 'package:apartments/app/utils/animations/show_up_animation.dart';
import 'package:apartments/app/utils/services/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CustomerGrid extends StatefulWidget {
  final List<CustomerModel> customers;

  const CustomerGrid({
    Key? key,
    required this.customers,
  }) : super(key: key);

  @override
  State<CustomerGrid> createState() => _CustomerGridState();
}

class _CustomerGridState extends State<CustomerGrid> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.customers.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: kSpacing / 2),
            child: ShowUp(
              delay: 400,
              child: CustomerCard(customer: widget.customers[index]),
            ),
          );
        });
    // return LayoutBuilder(
    //   builder: (context, constraints) {
    //     return StaggeredGridView.countBuilder(
    //       physics: const NeverScrollableScrollPhysics(),
    //       shrinkWrap: true,
    //       scrollDirection: Axis.vertical,
    //       crossAxisCount: _getCrossAxisCount(constraints.maxWidth),
    //       itemCount: widget.customers.length,
    //       itemBuilder: (context, index) {
    //         return CustomerCard(customer: widget.customers[index]);
    //       },
    //       staggeredTileBuilder: (index) => const StaggeredTile.count(
    //         1,
    //         1.2,
    //       ),
    //       mainAxisSpacing: 10,
    //       crossAxisSpacing: 10,
    //     );
    //   },
    // );
  }

  // ignore: unused_element
  int _getCrossAxisCount(double width) {
    if (width < 400) {
      return 2;
    } else if (width < 900) {
      return 3;
    } else {
      return 4;
    }
  }
}

class CustomerCard extends StatefulWidget {
  final CustomerModel customer;

  const CustomerCard({
    Key? key,
    required this.customer,
  }) : super(key: key);

  @override
  State<CustomerCard> createState() => _CustomerCardState();
}

class _CustomerCardState extends State<CustomerCard> {
  void _showAlertDialog(String apartmentId) async {
    Get.defaultDialog(
      title: "Wait!",
      middleText: "Please confirm",
      textConfirm: "Yes",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        final deleted =
            await RemoteClientApi().deleteClientDataFromDB(apartmentId);
        if (deleted == true) {
          showSnackBarForConfirmation();
        } else {
          showSnackBarForError();
        }
        Get.back();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Provider.of<ClientProvider>(context, listen: false).fetchClients(1);
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
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color.fromARGB(255, 217, 159, 253),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Card(
        color: Colors.white,
        borderOnForeground: true,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              const Expanded(
                flex: 1,
                child: CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage('images/user.png'),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      "Ім'я: ${widget.customer.name}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 17),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Паспорт: ${widget.customer.passport}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Телефон: ${widget.customer.phoneNumber}, ',
                      style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w600,
                          fontSize: 15),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Text(
                          'Статус: ',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 15),
                        ),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 9, vertical: 3),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.orangeAccent,
                                border: Border.all(
                                  width: 1.5,
                                  color: Colors.white,
                                )),
                            child: Text(widget.customer.status.toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600))),
                      ],
                    ),
                  ],
                ),
              ),
              if (isMobile == true) ...[
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          await SPHelper.saveClientsIDSharedPreference(
                              widget.customer.id.toString());

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const EditClientsData()),
                          );
                        },
                        child: const FaIcon(
                          FontAwesomeIcons.pencil,
                          color: Colors.blue,
                          size: 18,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      InkWell(
                        onTap: () =>
                            _showAlertDialog(widget.customer.id.toString()),
                        child: const FaIcon(
                          FontAwesomeIcons.trashCan,
                          color: Colors.black,
                          size: 18,
                        ),
                      )
                    ],
                  ),
                )
              ] else ...[
                Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        await SPHelper.saveClientsIDSharedPreference(
                            widget.customer.id.toString());
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EditClientsData()),
                        );
                      },
                      child: const FaIcon(
                        FontAwesomeIcons.pencil,
                        color: Colors.blue,
                        size: 18,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    InkWell(
                      onTap: () =>
                          _showAlertDialog(widget.customer.id.toString()),
                      child: const FaIcon(
                        FontAwesomeIcons.trashCan,
                        color: Colors.black,
                        size: 18,
                      ),
                    )
                  ],
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
