import 'package:apartments/app/features/dashboard/views/screens/sub%20screens%20of%20apartments/edit_appartment_sub_screen.dart';
import 'package:apartments/app/shared_components/responsive_builder.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class ApartmentEditDetail extends StatefulWidget {
  const ApartmentEditDetail({Key? key}) : super(key: key);

  @override
  State<ApartmentEditDetail> createState() => _ApartmentEditDetailState();
}

class _ApartmentEditDetailState extends State<ApartmentEditDetail> {
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
                      constraints: const BoxConstraints(maxWidth: 400),
                      padding: const EdgeInsets.only(top: 10),
                      child: const TextFormForAddingEditingApt()),
                ),
              ));
        }, tabletBuilder: (context, constraints) {
          return SingleChildScrollView(
              controller: ScrollController(),
              physics: const BouncingScrollPhysics(),
              child: Center(
                child: Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    padding: const EdgeInsets.only(top: 10),
                    child: const TextFormForAddingEditingApt()),
              ));
        }, desktopBuilder: (context, constraints) {
          return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              controller: ScrollController(),
              child: Center(
                child: Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    padding: const EdgeInsets.only(top: 20, bottom: 35),
                    child: const Column(
                      children: [
                        FormsEditList(),
                        TextFormForAddingEditingApt(),
                      ],
                    )),
              ));
        })));
  }
}

class FormsEditList extends StatelessWidget {
  const FormsEditList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Редагувати апартамент',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        Text(
          'Будь ласка, заповніть форму',
          style: TextStyle(fontSize: 15),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
