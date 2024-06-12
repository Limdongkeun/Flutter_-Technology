import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'dart:typed_data';
import 'dart:convert';

import 'package:permission_handler/permission_handler.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ExcelUploader(),
    );
  }
}


class ExcelUploader extends StatefulWidget {
  @override
  _ExcelUploaderState createState() => _ExcelUploaderState();

}

class _ExcelUploaderState extends State<ExcelUploader> {

  Future<void> _pickFile() async {
    if(kIsWeb) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xls', 'xlsx'],
      );

      if (result != null && result.files.isNotEmpty) {
        Uint8List? fileBytes = result.files.first.bytes;
        String fileName = result.files.first.name;

        if (fileBytes != null) {
          var excel = Excel.decodeBytes(fileBytes);
          List<Map<String, dynamic>> productList = [];

          for (var table in excel.tables.keys) {
            var sheet = excel.tables[table];
            print("File Name: $fileName");
            print(excel.tables[table]!.maxColumns);
            print(excel.tables[table]!.maxRows);

            // 첫 번째 행은 헤더로 가정
            List<String> headers = sheet!.rows.first.map((cell) =>
            cell?.value.toString() ?? '').toList();

            for (var i = 1; i < sheet.rows.length; i++) {
              var row = sheet.rows[i];
              Map<String, dynamic> product = {
                'product_name': row[0]?.value,
                'product_price': row[1]?.value,
                'product_category': row[2]?.value,
              };
              productList.add(product);
            }
          }

          print(productList);
        }
      } else {
        print('파일 없음');
      }
    } else { // 앱인 경우
      var status = await Permission.storage.request();

      if (status.isGranted) {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['xls', 'xlsx'],
        );

        if (result != null && result.files.isNotEmpty) {
          String? filePath = result.files.single.path;

          if (filePath != null) {
            var bytes = File(filePath).readAsBytesSync();
            var excel = Excel.decodeBytes(bytes);
            List<Map<String, dynamic>> productList = [];

            for (var table in excel.tables.keys) {
              var sheet = excel.tables[table];
              print("File Name: ${result.files.single.name}");

              // 첫 번째 행은 헤더로 가정
              List<String> headers = sheet!.rows.first.map((cell) => cell?.value.toString() ?? '').toList();

              for (var i = 1; i < sheet.rows.length; i++) {
                var row = sheet.rows[i];
                Map<String, dynamic> product = {
                  'product_name': row[0]?.value,
                  'product_price': row[1]?.value,
                  'product_category': row[2]?.value,
                };
                productList.add(product);
              }
            }

            print(productList);
          }
        } else {
          print('파일 없음');
        }
      } else {
        print('Storage permission denied');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Excel 파일 업로드'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _pickFile,
          child: Text('파일 선택'),
        ),
      ),
    );
  }
}
