import 'package:apartments/app/shared_components/responsive_builder.dart';
import 'package:flutter/material.dart';

import 'work are components/working_area_left_side.dart';
import 'work are components/working_area_right_side.dart';

class WorkingAreDetails extends StatelessWidget {
  const WorkingAreDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: ResponsiveBuilder(mobileBuilder: (context, constraints) {
      return const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: WorkingFieldEditForm(
              isMobile: true,
            ),
          ),
        ],
      );
    }, tabletBuilder: (context, constraints) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Flexible(
            flex: 5,
            child: WorkingFieldEditForm(),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: const VerticalDivider(),
          ),
          const Flexible(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: WorkingAreaRightSide(),
              )),
        ],
      );
    }, desktopBuilder: (context, constraints) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Flexible(
            flex: 5,
            child: WorkingFieldEditForm(),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: const VerticalDivider(),
          ),
          const Flexible(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: WorkingAreaRightSide(),
              )),
        ],
      );
    })));
  }
}
