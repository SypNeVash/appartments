import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class WorkAreaNotification extends StatefulWidget {
  const WorkAreaNotification({super.key});

  @override
  _WorkAreaNotificationState createState() => _WorkAreaNotificationState();
}

class _WorkAreaNotificationState extends State<WorkAreaNotification> {
  OverlaySupportEntry? _notificationEntry;

  void _showNotification(BuildContext context) {
    showOverlay(
      (context, t) {
        return GestureDetector(
          onTap: () {
            OverlaySupportEntry.of(context)!.dismiss();
          },
          child: Material(
            color: Colors.transparent,
            child: NotificationWidget(
              title: "New Notification",
              message:
                  "This is a custom drop-down notification with scrollable content." *
                      5,
              onClose: () {
                OverlaySupportEntry.of(context)!.dismiss();
              },
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
        child: ElevatedButton(
          onPressed: () => _showNotification(context),
          child: const Text('Show Notification'),
        ),
      ),
    );
  }
}

class NotificationWidget extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onClose;

  const NotificationWidget(
      {super.key,
      required this.title,
      required this.message,
      required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.notifications, color: Colors.blue),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: onClose,
              ),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Text(
              message,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
