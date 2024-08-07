
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:permission_handler/permission_handler.dart';

class ExcelUploader {

  static Future<List<Map<String, dynamic>>> pickFile() async {
    FilePickerResult? result;
    Uint8List? fileBytes;
    String? fileName;
    String? filePath;

    if (kIsWeb) {
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xls', 'xlsx'],
      );

      if (result != null && result.files.isNotEmpty) {
        fileBytes = result.files.first.bytes;
        fileName = result.files.first.name;

      } else {
        debugPrint('파일 없음');
        return [];
      }
      if (fileBytes != null) {
        try {
          return processExcelFile(fileBytes, fileName);
        } catch (e) {
          debugPrint('Error processing file: $e');
          return [];
        }
      }
    } else { // 앱인 경우
      var status = Permission.manageExternalStorage.request();
      if (await status.isGranted) {
        debugPrint('권한 나옴');
        result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['xls', 'xlsx'],
        );

        if (result != null && result.files.isNotEmpty) {
          filePath = result.files.single.path;
          fileName = result.files.single.name;

          if (filePath != null) {
            var bytes = File(filePath).readAsBytesSync();
            try {
              return processExcelFile(bytes, fileName);
            } catch (e) {
              debugPrint('Error processing file: $e');
              return [];
            }
          }
        } else {
          debugPrint('파일 없음');
          return [];
        }
      } else {
        debugPrint('권한 거절');
        return [];
      }
    }

    return [];
  }

  static List<Map<String, dynamic>> processExcelFile(Uint8List fileBytes, String fileName) {
    var excel = Excel.decodeBytes(fileBytes);
    List<Map<String, dynamic>> excelDataList = [];

    for (var table in excel.tables.keys) {
      var sheet = excel.tables[table];
      debugPrint("File Name: $fileName");
      debugPrint("File Column: ${excel.tables[table]!.maxColumns}");
      debugPrint("File Row: ${excel.tables[table]!.maxRows}");

      // 첫 번째 행은 헤더로 가정
      List<String> headers = sheet!.rows.first.map((cell) => cell?.value.toString() ?? '').toList();

      // Check for empty header values
      for (int i = 0; i < headers.length; i++) {
        if (headers[i].isEmpty) {
          throw Exception("Header at index $i is empty.");
        }
      }

      for (var i = 1; i < sheet.rows.length; i++) {
        var row = sheet.rows[i];
        Map<String, dynamic> excelRow = {};

        // 헤더 n번 째와 row n번째 값을 넣는다
        for (var j = 0; j < headers.length; j++) {
          excelRow[headers[j]] = row[j]?.value;
        }

        excelDataList.add(excelRow);
      }
      debugPrint(headers.toString());
    }

    return excelDataList;
  }
}
