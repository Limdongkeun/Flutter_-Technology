import 'dart:convert';

import '../stomp/webSocketTest.dart';



class Global {
  static final StompService stompService = StompService();

  static void connect(String kioskId, String storeId) {
    stompService.deactivate();
    stompService.subscribe(destination: 'topic/test', kioskId: kioskId, storeId: storeId);
    stompService.activate();
  }



  static void sendMessage(String kioskId, String storeId) {
    stompService.send(
      destination: 'topic/test',
      headers: {
        'content-type': 'application/json',
        'kioskId': kioskId,
        'storeId': storeId
      },
      body: json.encode({"key1" : "value2", "key2" : "value2", "key3" : "value3"}),
    );
  }

  static void programRestart(String kioskId, String storeId) {
    stompService.send(
      destination: 'topic/test',
      headers: {
        'content-type': 'application/json',
        'kioskId': kioskId,
        'storeId': storeId
      },
      body: json.encode({"program" : "restart"}),
    );
  }

  static void programStop(String kioskId, String storeId) {
    stompService.send(
      destination: 'topic/test',
      headers: {
        'content-type': 'application/json',
        'kioskId': kioskId,
        'storeId': storeId
      },
      body: json.encode({"program" : "stop"}),
    );
  }

  static void systemShutDown(String kioskId, String storeId) {
    stompService.send(
      destination: 'topic/test',
      headers: {
        'content-type': 'application/json',
        'kioskId': kioskId,
        'storeId': storeId
      },
      body: json.encode({"system" : "shutDown"}),
    );
  }

  static void cancelPayment(String kioskId, String storeId, dynamic body) {
    stompService.send(
      destination: 'topic/test',
      headers: {
        'content-type': 'application/json',
        'kioskId': kioskId,
        'storeId': storeId
      },
      body: body,
    );
  }

}