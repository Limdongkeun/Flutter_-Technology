
import 'dart:io';
import 'package:file_picker/file_picker.dart';
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
      home: ExcelUploader(),
    );
  }
}


class ExcelUploader extends StatefulWidget {
  const ExcelUploader({super.key});

  @override
  State<StatefulWidget> createState() => _ExcelUploaderState();

}

class _ExcelUploaderState extends State<ExcelUploader> {

  Future<void> _pickFile() async {
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
        return;
      }
      if (fileBytes != null) {
        _processExcelFile(fileBytes, fileName);
      }
    } else { // 앱인 경우
      var status = await Permission.storage.request();
      if (status.isGranted) {
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
            _processExcelFile(bytes, fileName);
          }
        } else {
          debugPrint('파일 없음');
          return;
        }
      } else {
        debugPrint('권한 거절');
        return;
      }
    }
  }

  void _processExcelFile(Uint8List fileBytes, String fileName) {
    var excel = Excel.decodeBytes(fileBytes);
    List<Map<String, dynamic>> productList = [];

    for (var table in excel.tables.keys) {
      var sheet = excel.tables[table];
      debugPrint("File Name: $fileName");
      debugPrint("File Column: ${excel.tables[table]!.maxColumns}");
      debugPrint("File Row: ${excel.tables[table]!.maxRows}");

      // 첫 번째 행은 헤더로 가정
      List<String> headers = sheet!.rows.first.map((cell) =>
      cell?.value.toString() ?? '').toList();

      for (var i = 1; i < sheet.rows.length; i++) {
        var row = sheet.rows[i];
        Map<String, dynamic> product = {
          'product_name': row[0]?.value,
          'product_price': row[1]?.value,
          'product_category': row[2]?.value,
          'product_필수1': row[3]?.value,
          'product_필수2': row[4]?.value,
          'product_필수3': row[5]?.value,
          'product_필수4': row[6]?.value,
          'product_필수5': row[7]?.value,
          'product_필수6': row[8]?.value,
          'product_필수7': row[9]?.value,
          'product_필수8': row[10]?.value,
          'product_필수9': row[11]?.value,
          'product_필수10': row[12]?.value,
        };
        productList.add(product);
      }

      debugPrint(headers.toString());
    }

    debugPrint(productList.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Excel 파일 업로드'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _pickFile,
          child: const Text('파일 선택'),
        ),
      ),
    );
  }
}
