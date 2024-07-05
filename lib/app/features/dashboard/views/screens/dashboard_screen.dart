library dashboard;

import 'dart:async';
import 'package:apartments/app/api/all_apartments_api.dart';
import 'package:apartments/app/api/token_control.dart';
import 'package:apartments/app/constans/app_constants.dart';
import 'package:apartments/app/features/dashboard/controllers/authcontroller.dart';
import 'package:apartments/app/features/dashboard/views/components/filters_forms.dart';
import 'package:apartments/app/features/dashboard/views/screens/adding_apartment.dart';
import 'package:apartments/app/features/dashboard/views/screens/work%20area/filter.dart';
import 'package:apartments/app/features/dashboard/views/screens/work%20area/work_are_dashboard.dart';
import 'package:apartments/app/providers/appartment_provider.dart';
import 'package:apartments/app/shared_components/header_text.dart';
import 'package:apartments/app/shared_components/list_task_assigned.dart';
import 'package:apartments/app/shared_components/list_task_date.dart';
import 'package:apartments/app/shared_components/responsive_builder.dart';
import 'package:apartments/app/shared_components/search_field.dart';
import 'package:apartments/app/shared_components/selection_button.dart';
import 'package:apartments/app/shared_components/simple_selection_button.dart';
import 'package:apartments/app/shared_components/simple_user_profile.dart';
import 'package:apartments/app/shared_components/user_profile.dart';
import 'package:apartments/app/utils/services/shared_preferences.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:apartments/app/utils/helpers/app_helpers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'all_aparts_screen.dart';
import 'clients/all_clients_grid_view.dart';
import 'clients/clients components/search_text_form.dart';

// binding
part '../../bindings/dashboard_binding.dart';

// controller
part '../../controllers/dashboard_controller.dart';

// model

// component
part '../components/bottom_navbar.dart';
part '../components/header_weekly_task.dart';
part '../components/main_menu.dart';
part '../components/task_menu.dart';
part '../components/member.dart';
// part '../components/task_in_progress.dart';
part '../components/weekly_task.dart';
part '../components/task_group.dart';

// class DashboardScreen extends GetView<DashboardController> {
//   const DashboardScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {}

Widget _buildSidebar(BuildContext context, bool? mobile) {
  final DashboardController controller = Get.find<DashboardController>();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: UserProfile(
          data: controller.dataProfil,
          onPressed: controller.onPressedProfil,
        ),
      ),
      const SizedBox(height: 15),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: _MainMenu(onSelected: controller.onSelectedMainMenu),
      ),
      const Divider(
        indent: 20,
        thickness: 1,
        endIndent: 20,
        height: 60,
      ),
      // _Member(member: controller.member),
      const SizedBox(height: kSpacing),
      // _TaskMenu(
      //   onSelected: controller.onSelectedTaskMenu,
      // ),
      const SizedBox(height: kSpacing),
      const Padding(
        padding: EdgeInsets.all(kSpacing),
        child: Text(
          "Елітний квадрат",
        ),
      ),
    ],
  );
}

openDrawer() {
  final DashboardController controller = Get.find<DashboardController>();
  controller.openDrawer();
}

Widget _buildTaskContent(
    {Function()? onPressedMenu, String? numberOfApartment}) {
  final DashboardController controller = Get.find<DashboardController>();

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: kSpacing),
    child: Column(
      children: [
        const SizedBox(height: kSpacing),
        Row(
          children: [
            if (onPressedMenu != null)
              Padding(
                padding: const EdgeInsets.only(right: kSpacing / 2),
                child: IconButton(
                  onPressed: onPressedMenu,
                  icon: const Icon(Icons.menu),
                ),
              ),
            Expanded(
              child: SearchField(
                onSearch: controller.searchTask,
                hintText: "Пошук .. ",
              ),
            ),
          ],
        ),
        const SizedBox(height: kSpacing),
        Row(
          children: [
            Expanded(
              child: HeaderText(
                DateTime.now().formatdMMMMY(),
              ),
            ),
            const SizedBox(width: kSpacing / 2),
            Text(
              '10 з $numberOfApartment',
              style: const TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 105, 105, 105),
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
        const SizedBox(height: kSpacing),
        const AllApartmentsScreen(),
      ],
    ),
  );
}

class BuilFilterContent extends StatefulWidget {
  final bool? isActive;
  final String desktop;

  const BuilFilterContent(
      {required this.isActive, required this.desktop, super.key});

  @override
  State<BuilFilterContent> createState() => _BuilFilterContentState();
}

class _BuilFilterContentState extends State<BuilFilterContent> {
  bool openFilter = false;
  String? role;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() async {
    role = await SPHelper.getRolesSharedPreference() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    AppartDetailsListener profileDetailsListener =
        Provider.of<AppartDetailsListener>(context, listen: true);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: Column(
        children: [
          const SizedBox(height: kSpacing),
          Row(
            children: [
              const Expanded(child: HeaderText("Фільтр")),
              IconButton(
                onPressed: () {
                  if (widget.isActive == true || widget.isActive == null) {
                    openFilter = !openFilter;
                    setState(() {});
                  }
                },
                icon: openFilter == true
                    ? const FaIcon(FontAwesomeIcons.circleXmark)
                    : const Icon(EvaIcons.funnelOutline),
                tooltip: "Filter",
              )
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          if (widget.desktop == 'mobile') ...[
            openFilter == true ? const FilterOfAppartments() : const SizedBox(),
          ],
          if (widget.desktop == 'desktop') ...[
            if (profileDetailsListener.getPageIndex == 0) ...[
              const FilterOfAppartments(),
            ] else if (profileDetailsListener.getPageIndex == 2) ...[
              const ClientSearchForm(),
            ] else if (profileDetailsListener.getPageIndex == 3) ...[
              const WorkAreaFormFilter(),
            ] else
              ...[]
          ]
        ],
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardController controller = Get.find<DashboardController>();
  final scafoldKey = GlobalKey<ScaffoldState>();

  late Timer _timer;
  String? _token;
  bool? isMobile;
  String? role;
  String? numberOfApartment;
  @override
  void initState() {
    super.initState();
    getUserData();
    _startTokenCheck();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppartDetailsListener profileDetailsListener =
          Provider.of<AppartDetailsListener>(context, listen: false);
      profileDetailsListener.setMobile = isMobile;
    });
  }

  void _startTokenCheck() {
    _checkToken();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) async {
      await _checkToken();
    });
  }

  Future<void> _checkToken() async {
    final token = await TokenManager.getToken();
    if (token == null) {
      _logout();
    } else {
      setState(() {
        _token = token;
      });
    }
  }

  void _logout() {
    final apartDetailsListener =
        Provider.of<AppartDetailsListener>(context, listen: false);
    final AuthController authController = Get.put(AuthController());
    _timer.cancel();
    TokenManager.clearToken();
    authController.logout();
    apartDetailsListener.setPageIndex = 0;
  }

  getUserData() async {
    role = await SPHelper.getRolesSharedPreference() ?? '';
    final numberOfApartments = await RemoteApi().getNumberForApartments();
    numberOfApartment = numberOfApartments.toString();
    setState(() {});
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void openDrawer() {
    if (scafoldKey.currentState != null) {
      scafoldKey.currentState!.openDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    AppartDetailsListener profileDetailsListener =
        Provider.of<AppartDetailsListener>(context, listen: true);
    isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      key: controller.scafoldKey,
      drawer: ResponsiveBuilder.isDesktop(context)
          ? null
          : Drawer(
              child: SafeArea(
                child:
                    SingleChildScrollView(child: _buildSidebar(context, true)),
              ),
            ),
      bottomNavigationBar: (ResponsiveBuilder.isDesktop(context) || kIsWeb)
          ? null
          : const _BottomNavbar(),
      body: SafeArea(
        child: ResponsiveBuilder(
          mobileBuilder: (context, constraints) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BuilFilterContent(
                    isActive: true,
                    desktop: "mobile",
                  ),
                  if (profileDetailsListener.getPageIndex == 0) ...[
                    _buildTaskContent(
                      onPressedMenu: () => controller.openDrawer(),
                      numberOfApartment: numberOfApartment,
                    ),
                  ] else if (profileDetailsListener.getPageIndex == 1) ...[
                    const AddingNewApartments(),
                  ] else if (profileDetailsListener.getPageIndex == 2) ...[
                    const AllClientsMain(
                      openDrawer: true,
                    ),
                  ] else if (profileDetailsListener.getPageIndex == 3) ...[
                    const WorkingAreaDashboard(
                      openDrawer: true,
                    ),
                  ] else ...[
                    _buildTaskContent(
                      numberOfApartment: numberOfApartment,
                    ),
                  ],
                ],
              ),
            );
          },
          tabletBuilder: (context, constraints) {
            return SingleChildScrollView(
              controller: ScrollController(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BuilFilterContent(isActive: true, desktop: "mobile"),
                  _buildTaskContent(
                    onPressedMenu: () => openDrawer(),
                    numberOfApartment: numberOfApartment,
                  ),
                  const AddingNewApartments(),
                ],
              ),
            );
          },
          desktopBuilder: (context, constraints) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: constraints.maxWidth > 1350 ? 3 : 4,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    controller: ScrollController(),
                    child: _buildSidebar(context, false),
                  ),
                ),
                if (profileDetailsListener.getPageIndex == 0) ...[
                  Flexible(
                    flex: constraints.maxWidth > 1350 ? 8 : 7,
                    child: SingleChildScrollView(
                      controller: ScrollController(),
                      physics: const BouncingScrollPhysics(),
                      child: _buildTaskContent(
                        numberOfApartment: numberOfApartment,
                      ),
                    ),
                  ),
                ] else if (profileDetailsListener.getPageIndex == 1) ...[
                  Flexible(
                      flex: constraints.maxWidth > 1350 ? 8 : 7,
                      child: SingleChildScrollView(
                          controller: ScrollController(),
                          physics: const BouncingScrollPhysics(),
                          child: const AddingNewApartments())),
                ] else if (profileDetailsListener.getPageIndex == 2) ...[
                  Flexible(
                    flex: constraints.maxWidth > 1350 ? 8 : 7,
                    child: SingleChildScrollView(
                      controller: ScrollController(),
                      physics: const BouncingScrollPhysics(),
                      child: const AllClientsMain(),
                    ),
                  ),
                ] else if (profileDetailsListener.getPageIndex == 3) ...[
                  Flexible(
                      flex: constraints.maxWidth > 1350 ? 8 : 7,
                      child: SingleChildScrollView(
                          controller: ScrollController(),
                          physics: const BouncingScrollPhysics(),
                          child: const WorkingAreaDashboard())),
                ] else ...[
                  Flexible(
                    flex: constraints.maxWidth > 1350 ? 8 : 7,
                    child: SingleChildScrollView(
                      controller: ScrollController(),
                      physics: const BouncingScrollPhysics(),
                      child: _buildTaskContent(
                        numberOfApartment: numberOfApartment,
                      ),
                    ),
                  ),
                ],
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: const VerticalDivider(),
                ),
                Flexible(
                  flex: 4,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    controller: ScrollController(),
                    child: const BuilFilterContent(
                        isActive: false, desktop: "desktop"),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
