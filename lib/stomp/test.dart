import 'dart:async';
import 'dart:convert';

import 'package:example_test/stomp/webSocketTest.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';


void main() {
  String kioskId = 'ALL';
  String storeId = '1';

  StompService stompService = StompService();
  stompService.subscribe(destination: '/topic/test', kioskId: kioskId, storeId: storeId);
  stompService.activate();
  bool sendTF = false;
  // Timer.periodic(const Duration(seconds: 5), (_) {
    stompService.send(
      destination: '/topic/test',
      headers: {
        'content-type' : 'application/json',
        'kioskId' : kioskId,
        'storeId' : storeId
      },
      body: json.encode({"a": 123}),
    );
    // debugPrint('send T/F $sendTF');
  // });
  Timer.periodic(const Duration(seconds: 10), (_) {
    stompService.deactivate();
  });

}