part of dashboard;

class _BottomNavbar extends StatefulWidget {
  const _BottomNavbar({Key? key}) : super(key: key);

  @override
  State<_BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<_BottomNavbar> {
  int index = 0;
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
    return BottomNavigationBar(
      currentIndex: index,
      items: [
        const BottomNavigationBarItem(
          activeIcon: Icon(EvaIcons.home),
          icon: const Icon(EvaIcons.homeOutline),
          label: "Apartments",
        ),
        if (role != 'Customer') ...[
          const BottomNavigationBarItem(
            activeIcon: Icon(EvaIcons.bell),
            icon: Icon(EvaIcons.bellOutline),
            label: "Notifications",
          ),
          const BottomNavigationBarItem(
            activeIcon: Icon(EvaIcons.checkmarkCircle2),
            icon: Icon(EvaIcons.checkmarkCircle),
            label: "Customers",
          ),
        ] else
          ...[],
        const BottomNavigationBarItem(
          activeIcon: Icon(EvaIcons.settings),
          icon: Icon(EvaIcons.settingsOutline),
          label: "Settings",
        ),
      ],
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Theme.of(context).primaryColor.withOpacity(.5),
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: false,
      onTap: (value) {
        setState(() {
          index = value;
        });
      },
    );
  }
}
