
import 'dart:core';
import 'dart:core';

import 'package:stomp_dart_client/stomp_dart_client.dart';


import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';

class webSocket {
  late StompClient stompClient;

  StompService(String identifier, String storeId) {
    stompClient = StompClient(
      config: StompConfig(
        url: 'wss://b-d2d32445-23ba-4c44-9997-d1e49a06e857-1.mq.ap-northeast-2.amazonaws.com:61619',
        beforeConnect: () async {
          debugPrint('waiting to connect... ♡⸜(˶˃ ᵕ ˂˶)⸝♡');
          await Future.delayed(const Duration(milliseconds: 200));
          debugPrint('connecting...☆ﾐ(o*･ω･)ﾉ');
        },
        onConnect: (frame) {
          print('[WS] :: STOMP Connected! Yay! (≧▽≦)');
          print('[WS] :: Subscribing to topic... :: hecto :: ᕦʕ •ᴥ•ʔᕤ :: with identifier... ( ☞˙ᵕ˙)☞ :: $identifier OR $storeId');
          stompClient.subscribe(
            destination: '/topic/test',
            callback: (frame) {
              final payload = json.encode(frame.body);
              final payloadHeader = json.encode(frame.headers);
              print('[WS] :: Topic Messaged Received! (*´▽\`*) :: ${json.encode(payload)}');
              print('[WS] :: Topic payloadHeader Received! (*´▽\`*) :: ${json.encode(payloadHeader)}');
            },
            headers: {
              'selector': "JMSCorrelationID = '$identifier' OR JMSCorrelationID = '$storeId'"
            },
          );
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
    stompClient.activate();
  }

  void deactivate() {
    stompClient.deactivate();
  }

  void send({required String destination, Map<String, String>? headers,
    required dynamic body}) {
    stompClient.send(
      destination: destination,
      headers: headers,
      body: body,
    );
  }
}


