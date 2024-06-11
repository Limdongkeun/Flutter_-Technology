import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class StompService {
  StompClient? stompClient;
  bool _isConnected = false;

  void subscribe({required String destination, required String kioskId, required String storeId}) {
    _isConnected = false;
    stompClient = StompClient(
      config: StompConfig(
        url: 'wss://b-d2d32445-23ba-4c44-9997-d1e49a06e857-1.mq.ap-northeast-2.amazonaws.com:61619',
        beforeConnect: () async {
          debugPrint('waiting to connect... ♡⸜(˶˃ ᵕ ˂˶)⸝♡');
          debugPrint('connecting...☆ﾐ(o*･ω･)ﾉ');
        },
        onConnect: (frame) {
          print('[WS] :: STOMP Connected! Yay! (≧▽≦)');
          print('[WS] :: Subscribing to topic... :: hecto :: ᕦʕ •ᴥ•ʔᕤ :: with identifier... ( ☞˙ᵕ˙)☞ :: ${kioskId} AND ${storeId}');
          stompClient!.subscribe(
            destination: destination,
            callback: (frame) {
              final payload = json.encode(frame.body);
              final payloadHeader = json.encode(frame.headers);
              print('[WS] :: Topic Message Received! (*´▽`*) :: $payload');
              print('[WS] :: Topic payloadHeader Received! (*´▽`*) :: $payloadHeader');
            },
            headers: {
              'selector': "kioskId = '$kioskId' AND storeId = '$storeId' OR (kioskId = ALL AND storeId = '$storeId')"
            },
          );
          _isConnected = true;
        },
        stompConnectHeaders: {
          'login': 'admin',
          'passcode': 'cnttcntt12345!'
        },
        onWebSocketError: (dynamic error) => debugPrint('오류: $error'),
      ),
    );
  }

  void activate() {
    if(stompClient != null){
      stompClient!.activate();
      print('webSocket 연결');
    }
  }

  void deactivate() {
    if(stompClient != null) {
      stompClient!.deactivate();
      print('webSocket 종료');
    }
  }

  bool send({required String destination, Map<String, String>? headers, required dynamic body}) {
    if(_isConnected) {
      stompClient!.send(
        destination: destination,
        headers: headers,
        body: body,
      );
     debugPrint('webSocket Send Success $body');

      return true;
    } else {

      debugPrint('webSocket Send Fail');

      return false;
    }
  }


}
