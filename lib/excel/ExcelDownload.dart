import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ExcelDownloader(),
    );
  }
}

class ExcelDownloader extends StatefulWidget {
  const ExcelDownloader({super.key});

  @override
  State<StatefulWidget> createState() => _ExcelDownloaderState();
}

// class EventEnrollment {
//   final String productName;
//   final String productPrice;
//   final String productCategory;
//
//   const EventEnrollment({
//     required this.productName,
//     required this.productPrice,
//     required this.productCategory,
//   });
//
//   List<dynamic> toRowData() {
//     return [
//       productName,
//       productPrice,
//       productCategory,
//     ];
//   }
// }

class _ExcelDownloaderState extends State<ExcelDownloader> {
  List<Map<String, dynamic>> eventEnrollments = [];

  Future<void> _saveExcel() async {
    final Excel excel = Excel.createExcel();
    final Sheet sheetObject = excel['Sheet1'];

    List<String> columnTitles = eventEnrollments.first.keys.toList();
    for (int i = 0; i < columnTitles.length; i++) {
      var cell = sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.value = TextCellValue(columnTitles[i]);
    }

    // Add data rows
    for (int row = 0; row < eventEnrollments.length; row++) {
      Map<String, dynamic> enrollment = eventEnrollments[row];
      List<dynamic> rowData = enrollment.values.toList();
      for (int col = 0; col < rowData.length; col++) {
        var cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row + 1));
        cell.value = TextCellValue(rowData[col].toString());
      }
    }


    if (kIsWeb) {
      // Save Excel file on web
      var fileBytes = excel.save(fileName: 'product.xlsx');

      debugPrint('웹~~~성공');

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
        debugPrint(filePath);
        debugPrint('앱~~~성공');
      } else {
        debugPrint('Permission denied');
      }
    }
  }

  Future<bool> callPermission() async {
    var status =  Permission.manageExternalStorage.request();
    var permission = false;
    if(await status.isGranted) {
      debugPrint('권한나옴');
      permission = true;
    } else {
      debugPrint('권한 부여가 거부되었습니다.');
      permission = false;
    }
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