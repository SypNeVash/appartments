import 'package:apartments/app/constans/app_constants.dart';
import 'package:apartments/app/features/dashboard/views/screens/clients/crud_client_api.dart';
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
              const CircleAvatar(
                radius: 35,
                backgroundImage: AssetImage('images/user.png'),
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.customer.name} ${widget.customer.surname}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text('Address: ${widget.customer.address}'),
                  const SizedBox(height: 5),
                  Text('Email: ${widget.customer.email}'),
                  const SizedBox(height: 5),
                  Text('Birthday: ${widget.customer.birthday}'),
                  const SizedBox(height: 5),
                  Text('Pasport: ${widget.customer.passport}'),
                  const SizedBox(height: 5),
                  Text('Patronymic: ${widget.customer.patronymic}'),
                  const SizedBox(height: 5),
                  Text('Phone: ${widget.customer.phoneNumber}'),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  InkWell(
                    onTap: () async {
                      await SPHelper.saveClientsIDSharedPreference(
                          widget.customer.id.toString());
                      Get.toNamed('/editClientsData');
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
            ],
          ),
        ),
      ),
    );
  }
}
