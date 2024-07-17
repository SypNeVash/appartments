class TaskModel {
  String? id;
  String? type;
  String? clientPhone;
  String? userName;
  String? date;
  String? doneDate;
  String? description;
  bool? status;

  TaskModel({
     this.id,
     this.type,
    this.clientPhone,
     this.userName,
     this.date,
     this.doneDate,
     this.description,
     this.status,
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
