class ApiConstants {
  static const String baseUrl = 'https://dev-api.supersourcing.com/shuledirect-service';
  
  static const String login = '$baseUrl/candidates/login/';
  static const String conversations = '$baseUrl/chat/conversations/';
  
  static String messages(String conversationId) => '$baseUrl/chat/messages/?conversation_id=$conversationId';

  static String socketUrl(String conversationId, String token) {
    return 'wss://dev-api.supersourcing.com/shuledirect-service/ws/chat/$conversationId/?token=$token';
  }
}
