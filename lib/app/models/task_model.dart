class TaskModel {
  String id;
  String type;
  String clientPhone;
  String userName;
  DateTime date;
  DateTime doneDate;
  String description;
  bool status;

  TaskModel({
    required this.id,
    required this.type,
    required this.clientPhone,
    required this.userName,
    required this.date,
    required this.doneDate,
    required this.description,
    required this.status,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      type: json['type'],
      clientPhone: json['clientPhone'],
      userName: json['userName'],
      date: DateTime.parse(json['date']),
      doneDate: DateTime.parse(json['doneDate']),
      description: json['description'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'clientPhone': clientPhone,
      'userName': userName,
      'date': date.toIso8601String(),
      'doneDate': doneDate.toIso8601String(),
      'description': description,
      'status': status,
    };
  }
}
