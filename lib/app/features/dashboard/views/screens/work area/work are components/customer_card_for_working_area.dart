import 'package:apartments/app/api/work_are_api.dart';
import 'package:apartments/app/features/dashboard/views/screens/work%20area/working_area_details.dart';
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
      title: "Зачекайте!",
      middleText: "Будь-ласка підтвердіть",
      textConfirm: "Так",
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
      textCancel: "Назад",
      onCancel: () {},
    );
  }

  showSnackBarForConfirmation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          'Успішно видалено',
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  showSnackBarForError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Спробувати ще раз'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Color _getColorForValue(String? value) {
    switch (value) {
      case 'Зустріч':
        return const Color.fromARGB(255, 171, 107, 255);
      case 'Передзвонити':
        return Colors.yellow;
      case 'Оплачено':
        return Colors.green;
      case 'Заселений':
        return const Color.fromARGB(255, 175, 219, 255);
      case 'Заморожений':
        return Colors.red;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      splashColor: const Color.fromARGB(255, 216, 208, 255),
      onTap: () async {
        await SPHelper.saveWorkAreaIDSharedPreference(
            widget.workingAreaModel.id.toString());
        // Get.toNamed('/workingareadetails');

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WorkingAreDetails()),
        );
      },
      child: Card(
        color: _getColorForValue(widget.workingAreaModel.task),
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
              Expanded(
                child: Column(
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
                        'Тел: ${widget.workingAreaModel.customerCard!.phoneNumber}, ',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        // Expanded(
                        //   child: const Text(
                        //     'Завдання: ',
                        //     overflow: TextOverflow.ellipsis,
                        //   ),
                        // ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: const Color.fromARGB(255, 247, 245, 245),
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
                    Text(
                      'ID: ${widget.workingAreaModel.id}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () =>
                    _showAlertDialog(widget.workingAreaModel.id.toString()),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 247, 243, 243),
                      shape: BoxShape.circle),
                  child: const FaIcon(
                    FontAwesomeIcons.trashCan,
                    color: Color.fromARGB(255, 0, 0, 0),
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
