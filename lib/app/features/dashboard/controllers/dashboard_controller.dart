// ignore_for_file: prefer_const_constructors

part of dashboard;

class DashboardController extends GetxController {
  final scafoldKey = GlobalKey<ScaffoldState>();
  final AuthController authController = Get.put(AuthController());

  final dataProfil = const UserProfileData(
    image: AssetImage(ImageRasterPath.man),
    name: 'dvdddd',
    jobDesk: "Owner",
  );

  void onPressedProfil() {}

  void _showAlertDialog() async {
    Get.defaultDialog(
      title: "Зачекай!",
      middleText: "Ти впевнений?",
      textConfirm: "Так",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        authController.logout();
        Get.back();
      },
      textCancel: "Назад",
      onCancel: () {},
    );
  }

  Future onSelectedMainMenu(int index, SelectionButtonData value) async {
    if (index == 0) {
      // Get.toNamed('/');
    }
    if (index == 1) {
      // NavigationService().navigateToScreen(AddingNewApartment());
      // Get.to(AddingNewApartment());
    }
    if (index == 2) {
      // Get.to(AllClientsList());
    }
    if (index == 4) {
      // _showAlertDialog();
      // authController.logout();
    }
  }

  void onSelectedTaskMenu(int index, String label) {}

  void searchTask(String value) {}

  void onPressedTask(int index, ListTaskAssignedData data) {}
  void onPressedAssignTask(int index, ListTaskAssignedData data) {}
  void onPressedMemberTask(int index, ListTaskAssignedData data) {}
  void onPressedCalendar() {}
  void onPressedTaskGroup(int index, ListAppartDateData data) {}

  void openDrawer() {
    if (scafoldKey.currentState != null) {
      scafoldKey.currentState!.openDrawer();
    }
  }
}
