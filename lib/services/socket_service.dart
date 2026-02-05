import 'package:web_socket_channel/io.dart';
import '../constants/api_constants.dart';

class SocketService {
  IOWebSocketChannel? _channel;

  Stream get stream => _channel!.stream;

  void connect(String conversationId, String token) {
    try {
      final url = ApiConstants.socketUrl(conversationId, token);
      _channel = IOWebSocketChannel.connect(Uri.parse(url));
    } catch (e) {
      print(e);
    }
  }

  void sendMessage(String message) {
    if (_channel != null) {
      _channel!.sink.add(message);
    }
  }

  void disconnect() {
    if (_channel != null) {
      _channel!.sink.close();
    }
  }
}
