class Conversation {
  final int id;
  
  Conversation({required this.id});

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
    );
  }
}
