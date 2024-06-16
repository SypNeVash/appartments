import 'package:apartments/app/models/customers_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CustomerGrid extends StatefulWidget {
  final List<CustomerModel> customers;

  const CustomerGrid({required this.customers, super.key});

  @override
  State<CustomerGrid> createState() => _CustomerGridState();
}

class _CustomerGridState extends State<CustomerGrid> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return StaggeredGridView.countBuilder(
          crossAxisCount: _getCrossAxisCount(constraints.maxWidth),
          itemCount: widget.customers.length,
          itemBuilder: (context, index) {
            return CustomerCard(customer: widget.customers[index]);
          },
          staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        );
      },
    );
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

class CustomerCard extends StatelessWidget {
  final CustomerModel customer;

  const CustomerCard({required this.customer, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color.fromARGB(255, 217, 159, 253), width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Card(
        color: Colors.white,
        borderOnForeground: true,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${customer.name} ${customer.surname}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text('Phone: ${customer.phoneNumber}'),
              const SizedBox(height: 5),
              Text('Email: ${customer.email}'),
              const SizedBox(height: 5),
              Text('Address: ${customer.address}'),
            ],
          ),
        ),
      ),
    );
  }
}
