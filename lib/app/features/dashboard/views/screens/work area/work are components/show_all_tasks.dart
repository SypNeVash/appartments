
import 'package:apartments/app/api/notifications_api.dart';
import 'package:apartments/app/models/task_model.dart';
import 'package:apartments/app/utils/animations/show_up_animation.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import 'add_task_working_area.dart';

class WorkAreaNotificationWidget extends StatefulWidget {


  const WorkAreaNotificationWidget(
      {super.key,});

  @override
  State<WorkAreaNotificationWidget> createState() => _WorkAreaNotificationWidgetState();
}

class _WorkAreaNotificationWidgetState extends State<WorkAreaNotificationWidget> {
  late Future<List<TaskModel>> _futureTasks;
  List<bool> isDoneList = [];

  @override
  void initState() {
    super.initState();
    _futureTasks = TaskApi().fetchTasks();
   
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
                              builder: (context) =>
                                  const AddTaskToWorkingArea()),
                        );
                      },
                      icon: const Icon(
                        Icons.add,
                        size: 30,
                        color: Colors.black,
                      )),
                )
              
        ],
      ),
      body:  Center(
        child: Column(
          children: [
           
            const SizedBox(height: 8),
            Expanded(
              child: FutureBuilder<List<TaskModel>>(
                future: _futureTasks,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                    ));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('No tasks found'));
                  } else {
                    List<TaskModel> notifications = snapshot.data!;
        
                    return ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        TaskModel notification = notifications[index];
                        return ShowUp(
                          delay: 200,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromARGB(
                                    255, 251, 249, 249),
                              ),
                              child: ListTile(
                                isThreeLine: true,
                                title: Text(
                                  notification.type,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      notification.description,
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
                                      notification.clientPhone ??
                                          'No phone number',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            Color.fromARGB(255, 42, 42, 42),
                                      ),
                                    ),
                                    Text(
                                      notification.date,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color:
                                            Color.fromARGB(255, 87, 87, 87),
                                      ),
                                    ),
                                  ],
                                ),
                           
                               
                               
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
