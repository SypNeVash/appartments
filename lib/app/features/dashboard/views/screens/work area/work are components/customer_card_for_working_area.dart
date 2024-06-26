import 'package:apartments/app/api/work_are_api.dart';
import 'package:apartments/app/constans/app_constants.dart';
import 'package:apartments/app/models/work_area_model.dart';
import 'package:apartments/app/providers/work_area_provider.dart';
import 'package:apartments/app/utils/services/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CustomerCardForWorkingAre extends StatefulWidget {
  final WorkingAreaModel workingAreaModel;
  const CustomerCardForWorkingAre({required this.workingAreaModel, super.key});

  @override
  State<CustomerCardForWorkingAre> createState() =>
      _CustomerCardForWorkingAreState();
}

class _CustomerCardForWorkingAreState extends State<CustomerCardForWorkingAre> {
  void _showAlertDialog(String id) async {
    Get.defaultDialog(
      title: "Wait!",
      middleText: "Please confirm",
      textConfirm: "Yes",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        final deleted = await WorkAreApi().deleteWorkAre(id);
        if (deleted == true) {
          showSnackBarForConfirmation();
        } else {
          showSnackBarForError();
        }
        Get.back();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Provider.of<WorkAreaProvider>(context, listen: false)
              .fetchWorkingAreaList(1);
        });
      },
      textCancel: "Back",
      onCancel: () {},
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
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      splashColor: const Color.fromARGB(255, 216, 208, 255),
      onTap: () async {
        await SPHelper.saveWorkAreaIDSharedPreference(
            widget.workingAreaModel.id.toString());
        Get.toNamed('/workingareadetails');
      },
      child: Card(
        color: widget.workingAreaModel.task == taskSelectionCallLater
            ? Colors.yellow
            : const Color.fromARGB(255, 224, 196, 255),
        borderOnForeground: true,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Text(
                  widget.workingAreaModel.customerCard!.name![0],
                  style: const TextStyle(
                      color: Color.fromARGB(255, 50, 12, 156),
                      fontWeight: FontWeight.w700,
                      fontSize: 20),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Text(
                    widget.workingAreaModel.customerCard!.name.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 17),
                  ),
                  const SizedBox(height: 5),
                  Text(
                      'Tel: ${widget.workingAreaModel.customerCard!.phoneNumber}, ',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text('Task: '),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              width: 1.5,
                              color: Colors.white,
                            )),
                        child: Text(widget.workingAreaModel.task.toString(),
                            style:
                                const TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text('ID: ${widget.workingAreaModel.id}'),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  InkWell(
                    onTap: () =>
                        _showAlertDialog(widget.workingAreaModel.id.toString()),
                    child: const FaIcon(
                      FontAwesomeIcons.trashCan,
                      color: Color.fromARGB(255, 0, 0, 0),
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
