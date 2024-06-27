part of dashboard;

class _MainMenu extends StatefulWidget {
  const _MainMenu({
    required this.onSelected,
    Key? key,
  }) : super(key: key);

  final Function(int index, SelectionButtonData value) onSelected;

  @override
  State<_MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<_MainMenu> {
  String? role;
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() async {
    role = await SPHelper.getRolesSharedPreference() ?? '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SelectionButton(
      data: [
        SelectionButtonData(
          activeIcon: EvaIcons.home,
          icon: EvaIcons.homeOutline,
          label: "Апартаменти",
        ),

        if (role != 'Customer') ...[
          SelectionButtonData(
            activeIcon: EvaIcons.fileAddOutline,
            icon: EvaIcons.fileAddOutline,
            label: "Додати апартамент",
            totalNotif: 100,
          ),
          SelectionButtonData(
            activeIcon: EvaIcons.personOutline,
            icon: EvaIcons.personOutline,
            label: "Клієнти",
          ),
          SelectionButtonData(
            activeIcon: EvaIcons.monitorOutline,
            icon: EvaIcons.monitorOutline,
            label: "Робочий простір",
          ),
          SelectionButtonData(
            activeIcon: EvaIcons.logOutOutline,
            icon: EvaIcons.logOutOutline,
            label: "Вийти",
          ),
        ] else
          ...[],

        // SelectionButtonData(
        //   activeIcon: EvaIcons.personAddOutline,
        //   icon: EvaIcons.personAddOutline,
        //   label: "Add user",
        //   totalNotif: 100,
        // ),
      ],
      onSelected: widget.onSelected,
    );
  }
}
