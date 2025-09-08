import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketProvider {
  IO.Socket? _socket;

  void connect(String userId, {required String token}) {
    _socket = IO.io(
      "http://45.129.87.38:6065",
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableForceNew()
          .enableAutoConnect()
          .setQuery({"userId": userId}) // optional, backend must support
          .setExtraHeaders({"Authorization": "Bearer $token"})
          .build(),
    );

    _socket!.onConnect((_) {
      print("✅ Socket connected");
    });

    _socket!.onDisconnect((_) {
      print("❌ Socket disconnected");
    });
  }

  void on(String event, Function(dynamic) handler) {
    _socket?.on(event, handler);
  }

  void emit(String event, dynamic data) {
    _socket?.emit(event, data);
  }

  void disconnect() {
    _socket?.disconnect();
  }
}
