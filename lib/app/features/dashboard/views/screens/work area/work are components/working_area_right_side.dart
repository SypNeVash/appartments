import 'dart:convert';

import 'package:apartments/app/api/work_are_api.dart';
import 'package:apartments/app/features/dashboard/views/components/text_form_fiel_decoration.dart';
import 'package:apartments/app/models/chat_message_model.dart';
import 'package:apartments/app/models/work_area_model.dart';
import 'package:apartments/app/utils/animations/show_up_animation.dart';
import 'package:apartments/app/utils/services/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'working_area_left_side.dart';

class WorkingAreaRightSide extends StatefulWidget {
  final bool? isMobile;
  const WorkingAreaRightSide({this.isMobile, super.key});

  @override
  State<WorkingAreaRightSide> createState() => _WorkingAreaRightSideState();
}

class _WorkingAreaRightSideState extends State<WorkingAreaRightSide> {
  String? name;
  DateTime dateTime = DateTime.now();

  final chatController = TextEditingController();
  List<String> chat = [];
  late WorkingAreaModel workingAreaModel;
  List<String> addToTheChat = [];
  @override
  void initState() {
    getWorkAreaUsingID();
    super.initState();
  }

  getInfosFromSharedPreferences() async {
    name = await SPHelper.getNameSharedPreference() ?? '';
  }

  getWorkAreaUsingID() async {
    await getInfosFromSharedPreferences();
    workingAreaModel = await WorkAreApi().fetchWorkingAreaDetailsById();
    chat = workingAreaModel.chat!;
    setState(() {});
  }

  Future<bool> addMessageToCustomerChat(Map<String, String> newMessage) async {
    final accessToken = await SPHelper.getTokenSharedPreference() ?? '';
    final workAreaId = await SPHelper.getWorkAreaIDSharedPreference();
    final String apiUrl =
        'https://realtor.azurewebsites.net/api/WorkArea/comment/$workAreaId';

    var url = 'https://realtor.azurewebsites.net/api/WorkArea/$workAreaId';

    final Dio dio = Dio();

    try {
      Response response = await dio.get(
        url,
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200) {
        response = await dio.post(
          apiUrl,
          data: newMessage,
          options: Options(
            headers: {'Authorization': 'Bearer $accessToken'},
          ),
        );
        if (response.statusCode == 200) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  bool isLoading = false;
  Future<bool> sendChatToServer() async {
    setState(() {
      isLoading = true;
    });
    Map<String, String> newMessage = {
      "text": chatController.text,
      "user": name.toString(),
      "date": dateTime.toString()
    };

    final finalResult = await addMessageToCustomerChat(newMessage);
    if (finalResult == true) {
      chatController.text = '';
      isLoading = false;
      getWorkAreaUsingID();
    } else {
      isLoading = false;
    }
    setState(() {});
    return finalResult;
  }

  @override
  Widget build(BuildContext context) {
    List<ChatMessage> messages = chat.map((jsonString) {
      Map<String, dynamic> json = jsonDecode(jsonString);
      return ChatMessage.fromJson(json);
    }).toList();
    return Scaffold(
      appBar: widget.isMobile == true
          ? AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WorkingFieldEditForm()),
                  );
                },
                icon: const Icon(EvaIcons.arrowBack),
              ),
              centerTitle: true,
            )
          : null,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: widget.isMobile == true
              ? const EdgeInsets.symmetric(horizontal: 25.0)
              : const EdgeInsets.symmetric(horizontal: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Notifications',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 0, 0, 0)),
              ),
              const SizedBox(
                height: 15,
              ),
              if (chat.isNotEmpty) ...[
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: chat.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];

                      return ShowUp2(
                        delay: 400,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const FaIcon(
                                      FontAwesomeIcons.bell,
                                      size: 13,
                                      color: Colors.blue,
                                    ),
                                    const SizedBox(
                                      width: 7,
                                    ),
                                    Text(
                                      message.user,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Text(
                                  message.text,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromARGB(255, 34, 34, 34)),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  message.date.toString(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blue),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ] else ...[
                const Text(
                  'No chat available',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 126, 126, 126)),
                )
              ],
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.0),
                child: Divider(),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: chatController,
                decoration: decorationForTextFormField('Add message').copyWith(
                  suffix: InkWell(
                    onTap: () {
                      if (chatController.text.isNotEmpty) {
                        sendChatToServer();
                      }
                    },
                    child: isLoading == true
                        ? const SizedBox(
                            height: 17,
                            width: 17,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                            ))
                        : const FaIcon(
                            FontAwesomeIcons.paperPlane,
                            color: Colors.black,
                            size: 20,
                          ),
                  ),
                ),
                validator: (value) {
                  return null; // ID is optional, so no validation
                },
                onChanged: (value) {
                  addToTheChat.add(value);
                },
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
