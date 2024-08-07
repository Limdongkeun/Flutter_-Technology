// lib/excel/ExcelDownload.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:excel/excel.dart';
import 'package:permission_handler/permission_handler.dart';

class ExcelDownloader {
  static Future<void> saveExcel(List<Map<String, dynamic>> dataList, String fileName) async {
    final Excel excel = Excel.createExcel();
    final Sheet sheetObject = excel['Sheet1'];

    List<String> columnTitles = dataList.first.keys.toList();
    for (int i = 0; i < columnTitles.length; i++) {
      var cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.value = TextCellValue(columnTitles[i]);
    }

    // Add data rows
    for (int row = 0; row < dataList.length; row++) {
      Map<String, dynamic> enrollment = dataList[row];
      List<dynamic> rowData = enrollment.values.toList();
      for (int col = 0; col < rowData.length; col++) {
        var cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row + 1));
        cell.value = TextCellValue(rowData[col].toString());
      }
    }

    if (kIsWeb) {
      excel.save(fileName:  '$fileName.xlsx');
      debugPrint('웹~~~성공');
    } else {
      var permission = await _callPermission();
      if (permission) {
        var fileBytes = excel.save();
        Directory directory = Directory('/storage/emulated/0/Download');
        String filePath = '${directory.path}/$fileName.xlsx';

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

  static Future<bool> _callPermission() async {
    var status = Permission.manageExternalStorage.request();
    var permission = false;
    if (await status.isGranted) {
      debugPrint('권한나옴');
      permission = true;
    } else {
      debugPrint('권한 부여가 거부되었습니다.');
      permission = false;
    }
    return permission;
  }
}
