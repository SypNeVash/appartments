class ChatMessage {
  final String text;
  final String user;
  final DateTime date;

  ChatMessage({
    required this.text,
    required this.user,
    required this.date,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      text: json['Text'],
      user: json['User'],
      date: DateTime.parse(json['Date']),
    );
  }
}
