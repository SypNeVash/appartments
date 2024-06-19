part of dashboard;

class _MainMenu extends StatelessWidget {
  const _MainMenu({
    required this.onSelected,
    Key? key,
  }) : super(key: key);

  final Function(int index, SelectionButtonData value) onSelected;

  @override
  Widget build(BuildContext context) {
    return SelectionButton(
      data: [
        SelectionButtonData(
          activeIcon: EvaIcons.home,
          icon: EvaIcons.homeOutline,
          label: "Apartments",
        ),
        SelectionButtonData(
          activeIcon: EvaIcons.fileAddOutline,
          icon: EvaIcons.fileAddOutline,
          label: "Add Apartment",
          totalNotif: 100,
        ),
        SelectionButtonData(
          activeIcon: EvaIcons.personOutline,
          icon: EvaIcons.personOutline,
          label: "Clients",
        ),
        SelectionButtonData(
          activeIcon: EvaIcons.personAddOutline,
          icon: EvaIcons.personAddOutline,
          label: "Add user",
          totalNotif: 100,
        ),
        SelectionButtonData(
          activeIcon: EvaIcons.logOutOutline,
          icon: EvaIcons.logOutOutline,
          label: "Log out",
        ),
      ],
      onSelected: onSelected,
    );
  }
}
