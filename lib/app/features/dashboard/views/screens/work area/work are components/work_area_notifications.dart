import 'package:apartments/app/api/notifications_api.dart';
import 'package:apartments/app/models/task_model.dart';
import 'package:apartments/app/utils/animations/show_up_animation.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class WorkAreaNotification extends StatefulWidget {
  const WorkAreaNotification({super.key});

  @override
  _WorkAreaNotificationState createState() => _WorkAreaNotificationState();
}

class _WorkAreaNotificationState extends State<WorkAreaNotification>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0), // Start from above the screen
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showNotification(BuildContext context) {
    _controller.forward();
    showOverlay(
      (context, t) {
        return SlideTransition(
          position: _offsetAnimation,
          child: GestureDetector(
            onTap: () {
              OverlaySupportEntry.of(context)!.dismiss();
            },
            child: Material(
              color: Colors.transparent,
              child: NotificationWidget(
                title: "Завдання",
                onClose: () {
                  OverlaySupportEntry.of(context)!.dismiss();
                },
              ),
            ),
          ),
        );
      },
      duration: Duration.zero,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        OverlaySupportEntry.of(context)?.dismiss();
      },
      child: Center(
        child: InkWell(
          onTap: () => _showNotification(context),
          child: const Icon(Icons.notifications_active_outlined,
              color: Colors.blue),
        ),
      ),
    );
  }
}

class NotificationWidget extends StatefulWidget {
  final String title;
  final VoidCallback onClose;

  const NotificationWidget(
      {super.key, required this.title, required this.onClose});

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  late Future<List<TaskModel>> _futureTasks;
  List<bool> isDoneList = [];

  @override
  void initState() {
    super.initState();
    _futureTasks = TaskApi().fetchTasks();
    _futureTasks.then((tasks) {
      setState(() {
        isDoneList = List<bool>.filled(tasks.length, false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width;
        if (constraints.maxWidth < 600) {
          width = constraints.maxWidth * 0.9;
        } else {
          width = constraints.maxWidth * 0.5;
        }

        return Center(
          child: Container(
            width: width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.notifications_active_rounded,
                        color: Colors.blue),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black),
                      onPressed: widget.onClose,
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.blue,
                ),
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
                        return Center(child: Text('Помилка: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('Немає поки задач'));
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
                                      notification.type.toString(),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          notification.clientPhone ??
                                              'Немає телефон номеру',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                Color.fromARGB(255, 42, 42, 42),
                                          ),
                                        ),
                                        Text(
                                          notification.date.toString(),
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color:
                                                Color.fromARGB(255, 87, 87, 87),
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: InkWell(
                                      highlightColor: Colors.blue,
                                      onTap: () async {
                                        bool isDone = await TaskApi().tasksDone(
                                            notification.id.toString());
                                        if (isDone == true) {
                                          setState(() {
                                            isDoneList[index] = true;
                                          });
                                          await Future.delayed(const Duration(
                                              milliseconds: 500));
                                          _futureTasks = TaskApi().fetchTasks();
                                          _futureTasks.then((tasks) {
                                            setState(() {
                                              isDoneList = List<bool>.filled(
                                                  tasks.length, false);
                                            });
                                          });
                                        }
                                      },
                                      child: isDoneList.isNotEmpty &&
                                              isDoneList[index] == true
                                          ? const ShowUp2(
                                              delay: 300,
                                              child: Icon(
                                                  Icons
                                                      .check_circle_outline_rounded,
                                                  color: Colors.grey),
                                            )
                                          : const Icon(
                                              Icons.circle_outlined,
                                              color: Colors.grey,
                                            ),
                                    ),
                                    onTap: () {},
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
      },
    );
  }
}
