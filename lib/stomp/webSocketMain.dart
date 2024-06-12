import 'dart:convert';

import 'package:example_test/stomp/webSocketTest.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../enum/global.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late StompService stompService;
  final String kioskId = '1';
  final String storeId = '1';

  @override
  void initState() {
    super.initState();
    Global.connect(kioskId,storeId);
  }

  void _sendKeyValue() {
    Global.sendMessage(kioskId, storeId);
  }

  void _programRestart() {
    Global.programRestart(kioskId, storeId);
  }

  void _programStop() {
    Global.programStop(kioskId, storeId);
  }

  void _systemShutDown() {
    Global.systemShutDown(kioskId, storeId);
  }

  void _cancelPayment() {
    Global.cancelPayment(
        kioskId,
        storeId,
        json.encode(
            {
              "paymentId" : "1231241241",
              "amount" : "35000",
              "cardId" : "185Basfas",
            }
        )
    );
  }

  @override
  void dispose() {
    stompService.deactivate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
          child: Column(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 위젯끼리 같은 공간만큼 띄움
                children: <Widget>[
                  ElevatedButton( //ElevatedButton-기존의 RaisedButton,버튼을 강조하고 싶을 때 사용
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red
                    ), // 버튼 색은 빨강색으로
                    onPressed: () { // 버튼을 누르면 안에 있는 함수를 실행
                      _sendKeyValue();
                    },
                    child: const Text(
                      "sendKeyValue",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue
                    ), // 버튼 색은 파란색으로
                    onPressed: () { // 버튼을 누르면 안에 있는 함수를 실행
                      _programRestart();
                    },
                    child: const Text(
                      "programRestart",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green
                    ), // 버튼 색은 파란색으로
                    onPressed: () { // 버튼을 누르면 안에 있는 함수를 실행
                      _programStop();
                    },
                    child: const Text(
                      "programStop",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow
                    ), // 버튼 색은 파란색으로
                    onPressed: () { // 버튼을 누르면 안에 있는 함수를 실행
                      _systemShutDown();
                    },
                    child: const Text(
                      "systemShutdown",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey
                    ), // 버튼 색은 파란색으로
                    onPressed: () { // 버튼을 누르면 안에 있는 함수를 실행
                      _cancelPayment();
                    },
                    child: const Text(
                      "cancelPayment",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              )
            ],
          )

      ),

    );
  }
}
