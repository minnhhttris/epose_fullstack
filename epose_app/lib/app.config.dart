//import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

Future<void> appConfig() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Replace with your backend server URL
  // await dotenv.load(fileName: ".env");

  // final String backendUrl = dotenv.env['URL'] ?? '';
  // final String socketUrl = dotenv.env['URL'] ?? '';

  // await _connectToBackend(backendUrl);
  // _connectToSocket(socketUrl);
}

Future<void> _connectToBackend(String backendUrl) async {
  try {
    final response = await http.get(Uri.parse(backendUrl));

    if (response.statusCode == 200) {
      print('Kết nối thành công!!!!');
    } else {
      print('Lỗi kết nối: ${response.statusCode}');
    }
  } catch (e) {
    print('Lỗi kết nối: $e');
  }
}

void _connectToSocket(String socketUrl) {
  IO.Socket socket = IO.io(socketUrl, <String, dynamic>{
    'transports': ['websocket'],
  });

  socket.on('connect', (_) {
    print('Kết nối Socket.IO thành công');
  });

  socket.on('disconnect', (_) {
    print('Mất kết nối Socket.IO');
  });

  socket.on('connect_error', (error) {
    print('Lỗi kết nối Socket.IO: $error');
  });
}
