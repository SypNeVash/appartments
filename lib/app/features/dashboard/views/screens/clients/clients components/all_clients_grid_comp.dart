import 'package:apartments/app/constans/app_constants.dart';
import 'package:apartments/app/models/customers_model.dart';
import 'package:apartments/app/utils/animations/show_up_animation.dart';
import 'package:flutter/material.dart';

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
                radius: 25,
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
                  Text('Phone: ${widget.customer.phoneNumber}'),
                  const SizedBox(height: 5),
                  Text('Email: ${widget.customer.email}'),
                  const SizedBox(height: 5),
                  Text('Address: ${widget.customer.address}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
