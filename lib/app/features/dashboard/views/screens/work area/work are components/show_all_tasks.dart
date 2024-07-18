import 'package:apartments/app/api/notifications_api.dart';
import 'package:apartments/app/api/work_are_api.dart';
import 'package:apartments/app/models/task_model.dart';
import 'package:apartments/app/models/work_area_model.dart';
import 'package:apartments/app/utils/animations/show_up_animation.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import 'add_task_working_area.dart';

class WorkAreaNotificationWidget extends StatefulWidget {
  const WorkAreaNotificationWidget({
    super.key,
  });

  @override
  State<WorkAreaNotificationWidget> createState() =>
      _WorkAreaNotificationWidgetState();
}

class _WorkAreaNotificationWidgetState
    extends State<WorkAreaNotificationWidget> {
  List<TaskModel> _futureTasks = [];
  List<bool> isDoneList = [];

  late WorkingAreaModel workingAreaModel;
  getWorkAreaUsingID() async {
    workingAreaModel = await WorkAreApi().fetchWorkingAreaDetailsById();
    _futureTasks = workingAreaModel.tasks!;
    setState(() {});
  }

  @override
  void initState() {
    getWorkAreaUsingID();
    super.initState();
  }

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
        title: const Text(
          'All Tasks',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddTaskToWorkingArea()),
                  ).then((value) {
                    if (value == true) {
                      getWorkAreaUsingID();
                    }
                  });
                },
                icon: const Icon(
                  Icons.add,
                  size: 30,
                  color: Colors.black,
                )),
          )
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            children: [
              const SizedBox(height: 8),
              if (_futureTasks.isEmpty) ...[
                const Center(
                  child: Text('No Notification'),
                ),
              ],
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _futureTasks.length,
                  itemBuilder: (context, index) {
                    TaskModel notification = _futureTasks[index];

                    return ShowUp(
                      delay: 200,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(66, 187, 187, 187),
                                blurRadius: 3,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ListTile(
                            isThreeLine: true,
                            title: Text(
                              notification.type.toString(),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  notification.description.toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  notification.clientPhone ?? 'No phone number',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromARGB(255, 42, 42, 42),
                                  ),
                                ),
                                Text(
                                  notification.date.toString(),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Color.fromARGB(255, 87, 87, 87),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
