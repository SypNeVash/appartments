import 'dart:ui';
import 'package:apartments/app/api/admin_panel_api.dart';
import 'package:apartments/app/api/token_control.dart';
import 'package:apartments/app/features/dashboard/controllers/authcontroller.dart';
import 'package:apartments/app/features/dashboard/views/screens/apartment_details.dart';
import 'package:apartments/app/features/dashboard/views/screens/clients/add_new_clients.dart';
import 'package:apartments/app/features/dashboard/views/screens/dashboard_screen.dart';
import 'package:apartments/app/features/dashboard/views/screens/edit_appartment_screen.dart';
import 'package:apartments/app/providers/admin_panel_provider.dart';

import 'package:apartments/app/providers/clients_provider.dart';
import 'package:apartments/app/providers/work_area_provider.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:provider/provider.dart';

import 'app/config/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/features/dashboard/views/screens/clients/edit_clients_dat.dart';
import 'app/features/dashboard/views/screens/login_screen.dart';
import 'app/features/dashboard/views/screens/work area/add_new_client_to_work_area.dart';
import 'app/features/dashboard/views/screens/work area/working_area_details.dart';
import 'app/providers/appartment_provider.dart';
import 'app/utils/services/auth_services.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    AuthService.isAuthenticated().then((isAuthenticated) {
      if (!isAuthenticated) {
        Get.offNamed('/login');
      }
    });
    return null;
  }
}

class MyNavigatorObserver extends NavigatorObserver {
  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    print(
        'didPop: ${route.settings.name}, previousRoute: ${previousRoute?.settings.name}');
    // Custom behavior on pop
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    print(
        'didPush: ${route.settings.name}, previousRoute: ${previousRoute?.settings.name}');
    // Custom behavior on push
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(DashboardController());
  final authController = Get.put(AuthController());
  await authController.checkAuthenticationStatus();
  await TokenManager.getToken();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => AppartDetailsListener()),
    ChangeNotifierProvider(
      create: (context) => ApartmentProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => ClientProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => WorkAreaProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => AdminPanelProvider(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String tokenExist = '';
  @override
  void initState() {
    super.initState();
  }

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return GetMaterialApp(
      // navigatorKey: NavigationService().navigationKey,
      title: 'Apartment',
      theme: AppTheme.basic,
      initialRoute: authController.isAuthenticated.value ? '/' : '/login',
      getPages: [
        GetPage(
          name: '/',
          page: () => const DashboardScreen(),
          // middlewares: [AuthMiddleware()],
        ),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/apartmentdetail', page: () => const ApartmentDetail()),
        GetPage(
            name: '/editingApartments',
            page: () => const ApartmentEditDetail()),
        GetPage(name: '/addingNewClient', page: () => const AddingNewClients()),
        GetPage(
            name: '/addingNewWorkArea', page: () => const WorkingAreMainEdit()),
        GetPage(
            name: '/workingareadetails', page: () => const WorkingAreDetails()),
        GetPage(name: '/editClientsData', page: () => const EditClientsData()),
      ],
      scrollBehavior: CustomScrollBehaviour(),
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver(), MyNavigatorObserver()],
      debugShowCheckedModeBanner: false,
    );
  }
}

class CustomScrollBehaviour extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
