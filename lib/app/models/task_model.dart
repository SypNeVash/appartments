class TaskModel {
  String id;
  String type;
  String clientPhone;
  String userName;
  String date;
  String doneDate;
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
      date: json['date'],
      doneDate: json['doneDate'],
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
      'date': date,
      'doneDate': doneDate,
      'description': description,
      'status': status,
    };
  }
}
