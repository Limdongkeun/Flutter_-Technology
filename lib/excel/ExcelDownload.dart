import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ExcelDownloader(),
    );
  }
}

class ExcelDownloader extends StatefulWidget {
  @override
  _ExcelDownloaderState createState() => _ExcelDownloaderState();
}

class EventEnrollment {
  final String product_name;
  final String product_price;
  final String product_category;

  EventEnrollment({
    required this.product_name,
    required this.product_price,
    required this.product_category,
  });

  List<dynamic> toRowData() {
    return [
      product_name,
      product_price,
      product_category,
    ];
  }
}

class _ExcelDownloaderState extends State<ExcelDownloader> {
  List<EventEnrollment> eventEnrollments = [
    EventEnrollment(
      product_name: "새우깡",
      product_price: "2000",
      product_category: "10"
    ),
    EventEnrollment(
        product_name: "오징어땅콩",
        product_price: "3500",
        product_category: "10"
    ),
  ];

  Future<void> _saveExcel() async {
    final Excel excel = Excel.createExcel();
    final Sheet sheetObject = excel['Sheet1'];

    // Add column titles
    List<String> columnTitles = [
      'product_name',
      'product_price',
      'product_category',
    ];
    for (int i = 0; i < columnTitles.length; i++) {
      var cell = sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.value = TextCellValue(columnTitles[i]);
    }

    // Add data rows
    for (int row = 0; row < eventEnrollments.length; row++) {
      EventEnrollment enrollment = eventEnrollments[row];
      List<dynamic> rowData = enrollment.toRowData();
      for (int col = 0; col < rowData.length; col++) {
        var cell = sheetObject.cell(
            CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row + 1));
        cell.value = TextCellValue(rowData[col].toString());
      }
    }


    if (kIsWeb) {
      // Save Excel file on web
      var fileBytes = excel.save(fileName: 'product.xlsx');

      print('웹~~~성공');

    } else {
      // Save Excel file on mobile
      var permission = callPermission();
      if (await permission) {
        var fileBytes = excel.save();
        Directory directory = Directory('/storage/emulated/0/Download');
        String filePath = '${directory.path}/product.xlsx';

        // 디렉토리가 존재하지 않으면 생성합니다.
        if (!directory.existsSync()) {
          directory.createSync(recursive: true);
        }

        File file = File(filePath);
        file.writeAsBytesSync(fileBytes!);
        print(filePath);
        print('앱~~~성공');
      } else {
        print('Permission denied');
      }
    }
  }

  Future<bool> callPermission() async {
    var status = await Permission.storage.request();
    var permission = false;
    if(status.isGranted) {
      print('권한나옴');
      permission = true;
    } else {
      print('권한 부여가 거부되었습니다.');
      permission = false;
    }

    // if (status.isGranted) {
    //   print('권한이 부여되었습니다.');
    // }
    //
    // if(status.isDenied) {
    //   print('권한 부여가 거부되었습니다.');
    // }
    //
    // if(status.isPermanentlyDenied) {
    //   print('권한 부여가 영구적으로 거부되었습니다.');
    // }
    //
    // if(status.isRestricted) {
    //   print('권한이 제한되었습니다.');
    // }
    //
    // if(status.isUndetermined) {
    //   print('권한 부여가 아직 미정입니다.');
    // }
    return permission;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('엑셀 다운로드'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _saveExcel,
          child: const Text('엑셀 다운로드'),
        ),
      ),
    );
  }
}