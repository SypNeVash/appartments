import 'package:apartments/app/api/token_control.dart';
import 'package:apartments/app/constans/app_constants.dart';
import 'package:apartments/app/features/dashboard/controllers/authcontroller.dart';
import 'package:apartments/app/features/dashboard/views/screens/users/add_new_user.dart';
import 'package:apartments/app/utils/services/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';

import '../features/dashboard/views/screens/users/users_dashboard.dart';
import '../features/dashboard/views/screens/work area/work are components/work_area_notifications.dart';

class UserProfileData {
  final ImageProvider image;
  final String name;
  final String jobDesk;

  const UserProfileData({
    required this.image,
    required this.name,
    required this.jobDesk,
  });
}

class UserProfile extends StatefulWidget {
  const UserProfile({
    required this.data,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final UserProfileData data;
  final Function() onPressed;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String name = '';
  String role = '';
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() async {
    name = await SPHelper.getFullNameSharedPreference() ??
        await SPHelper.getNameSharedPreference() ??
        '';
    role = await SPHelper.getRolesSharedPreference() ?? '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(kBorderRadius),
        onTap: () {
          if (role != 'Customer') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UsersDashboard()),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              _buildImage(),
              const SizedBox(width: 10),
              Expanded(
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildName(),
                        _buildJobdesk(),
                        if (role == 'Customer') ...[
                          const SizedBox(
                            height: 5,
                          ),
                          const LogOutForCustomers()
                        ] else ...[
                          // const AddNewUser(),
                        ]
                      ],
                    ),
                    // const WorkAreaNotification()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return CircleAvatar(
      radius: 25,
      backgroundImage: widget.data.image,
    );
  }

  Widget _buildName() {
    return Text(
      name,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: kFontColorPallets[0],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildJobdesk() {
    return Text(
      roleDefinition[role] ?? 'Користувач',
      style: TextStyle(
        fontWeight: FontWeight.w300,
        color: kFontColorPallets[1],
      ).copyWith(fontSize: 13),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class LogOutForCustomers extends StatelessWidget {
  const LogOutForCustomers({super.key});

  logOutForClient() {
    final AuthController authController = Get.put(AuthController());
    TokenManager.clearToken();
    authController.logout();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          logOutForClient();
        },
        child: const Row(
          children: [
            FaIcon(FontAwesomeIcons.rightFromBracket,
                color: Colors.black, size: 12),
            SizedBox(
              width: 3,
            ),
            Text(
              'Logout',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ));
  }
}

class AddNewUser extends StatelessWidget {
  const AddNewUser({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {},
        child: Container(
          constraints: const BoxConstraints(),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: Colors.orangeAccent),
          child: const Row(
            children: [
              FaIcon(FontAwesomeIcons.plus, color: Colors.black, size: 12),
              SizedBox(
                width: 3,
              ),
              Text(
                'Додати',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ));
  }
}
