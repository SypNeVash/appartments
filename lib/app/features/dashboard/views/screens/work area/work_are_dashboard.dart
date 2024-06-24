import 'package:apartments/app/shared_components/responsive_builder.dart';
import 'package:flutter/material.dart';

class WorkingAreaDashboard extends StatefulWidget {
  const WorkingAreaDashboard({super.key});

  @override
  State<WorkingAreaDashboard> createState() => _WorkingAreaDashboardState();
}

class _WorkingAreaDashboardState extends State<WorkingAreaDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ResponsiveBuilder(
          mobileBuilder: (context, constraints) {
            return const SingleChildScrollView(
              child: const Column(),
            );
          },
          tabletBuilder: (context, constraints) {
            return const SingleChildScrollView();
          },
          desktopBuilder: (context, constraints) {
            return const SingleChildScrollView();
          },
        ),
      ),
    );
  }
}
