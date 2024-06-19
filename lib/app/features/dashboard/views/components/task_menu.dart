part of dashboard;

// ignore: unused_element
class _TaskMenu extends StatelessWidget {
  const _TaskMenu({
    required this.onSelected,
    Key? key,
  }) : super(key: key);

  final Function(int index, String label) onSelected;

  @override
  Widget build(BuildContext context) {
    return SimpleSelectionButton(
      data: const [
        "Directory",
        "Onboarding",
        "Offboarding",
        "Time-off",
      ],
      onSelected: onSelected,
    );
  }
}
