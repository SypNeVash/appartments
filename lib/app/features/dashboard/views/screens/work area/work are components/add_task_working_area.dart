import 'package:apartments/app/constans/app_constants.dart';
import 'package:apartments/app/features/dashboard/views/components/text_form_fiel_decoration.dart';
import 'package:apartments/app/models/task_model.dart';
import 'package:apartments/app/utils/services/shared_preferences.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class TextFormForTask extends StatefulWidget {
  final Function(bool) callBack;
  const TextFormForTask({required this.callBack, Key? key}) : super(key: key);

  @override
  State<TextFormForTask> createState() => _TextFormForTaskState();
}

class _TextFormForTaskState extends State<TextFormForTask> {
  final TextEditingController type = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController dateAndTime = TextEditingController();

  String errorText = '';
  TaskModel taskModel = TaskModel();
  DateTime dateTime = DateTime.now();
  String uuid = const Uuid().v4();

  Future<bool> postTaskData() async {
    Dio dio = Dio();
    final accessToken = await SPHelper.getTokenSharedPreference() ?? '';
    final workAreaId = await SPHelper.getWorkAreaIDSharedPreference();

    String apiUrl =
        'https://realtor.azurewebsites.net/api/WorkArea/task/$workAreaId';
    final dateTime = _combineDateAndTime();

    try {
      Map<String, dynamic> datas = {
        "id": uuid,
        "type": type.text,
        "date": dateTime!.toIso8601String(),
        "description": description.text,
      };

      Response response = await dio.post(
        apiUrl,
        data: datas,
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      print(response.statusCode);
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    type.dispose();
    description.dispose();
    dateAndTime.dispose();
    super.dispose();
  }

  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        final now = DateTime.now();
        final dt =
            DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
        _timeController.text = DateFormat('HH:mm').format(dt);
      });
    }
  }

  DateTime? _combineDateAndTime() {
    final dateText = _dateController.text;
    final timeText = _timeController.text;

    if (dateText.isEmpty || timeText.isEmpty) {
      return null;
    }

    final date = DateFormat('yyyy-MM-dd').parse(dateText);
    final time = DateFormat('HH:mm').parse(timeText);

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  String? selectedType;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Select Date',
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: outlineMainInputFocusedBorder,
                  enabledBorder: outlineMainInputFocusedBorder,
                  errorBorder: outlineMainInputFocusedBorder,
                  focusedErrorBorder: outlineMainInputFocusedBorder,
                  border: outlineMainInputFocusedBorder,
                  suffixIcon: IconButton(
                    icon: const Icon(
                      EvaIcons.calendar,
                      color: Colors.blue,
                    ),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _timeController,
                decoration: InputDecoration(
                  labelText: 'Select Time',
                  filled: true,
                  border: outlineMainInputFocusedBorder,
                  fillColor: Colors.white,
                  focusedBorder: outlineMainInputFocusedBorder,
                  enabledBorder: outlineMainInputFocusedBorder,
                  errorBorder: outlineMainInputFocusedBorder,
                  focusedErrorBorder: outlineMainInputFocusedBorder,
                  suffixIcon: IconButton(
                    icon: const Icon(
                      EvaIcons.clockOutline,
                      color: Colors.blue,
                    ),
                    onPressed: () => _selectTime(context),
                  ),
                ),
                readOnly: true,
                onTap: () => _selectTime(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a time';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              DropdownButtonFormField<String>(
                autovalidateMode: AutovalidateMode.always,
                autofocus: false,
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
                decoration: decorationForTextFormField('Тип'),
                onChanged: (val) {
                  type.text = val!;
                },
                icon: const FaIcon(
                  FontAwesomeIcons.chevronDown,
                  size: 15,
                  color: Colors.grey,
                ),
                hint: const Text('Тип'),
                items: tasks.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: description,
                autovalidateMode: AutovalidateMode.always,
                textCapitalization: TextCapitalization.sentences,
                autofocus: false,
                maxLines: 4,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
                decoration: decorationForTextFormField('Description'),
              ),
              Text(
                errorText,
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 250,
                height: 40,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 188, 2),
                    ),
                    onPressed: () async {
                      var cancel = BotToast.showLoading();
                      final done = await postTaskData();
                      if (done == true) {
                        cancel();
                        widget.callBack(done);
                        // Navigator.of(context).pop(true);
                      } else {
                        cancel();
                        setState(() {
                          errorText = 'Error: Please check and try again';
                        });
                      }
                    },
                    child: const Text(
                      'Зберегти',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    )),
              ),
              const SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}
