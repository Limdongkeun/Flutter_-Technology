import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:flutter/foundation.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';

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

        String downloadDirPath = await getPublicDownloadFolderPath();
        String filePath = '$downloadDirPath/$fileName.xlsx';

        // Ensure the directory exists
        Directory directory = Directory(downloadDirPath);
        if (!directory.existsSync()) {
          directory.createSync(recursive: true);
        }

        // Save the file
        File file = File(filePath);
        file.writeAsBytesSync(fileBytes!);
        Share.shareFiles([filePath]);
        debugPrint('File saved at $filePath');
        debugPrint('앱~~~성공');
      } else {
        debugPrint('Permission denied');
      }
    }
  }


  static Future<bool> _callPermission() async {
    bool permission = false;

    if (Platform.isAndroid) {
      permission = await _requestAndroidPermissions();
    } else if (Platform.isIOS) {
      permission = await _requestIOSPermissions();
    }

    return permission;
  }

  static Future<bool> _requestAndroidPermissions() async {
    var status = await Permission.manageExternalStorage.request();
    if (status.isGranted) {
      debugPrint('권한 부여됨 (Android)');
      return true;
    } else {
      debugPrint('권한 부여가 거부되었습니다 (Android).');
      return false;
    }
  }

  static Future<bool> _requestIOSPermissions() async {
    var status = await Permission.mediaLibrary.request();
    if (status.isGranted) {
      debugPrint('권한 부여됨 (iOS)');
      return true;
    } else {
      debugPrint('권한 부여가 거부되었습니다 (iOS).');
      return false;
    }
  }

  static Future<String> getPublicDownloadFolderPath() async {
    String? downloadDirPath;

    // 만약 다운로드 폴더가 존재하지 않는다면 앱내 파일 패스를 대신 주도록한다.
    if (Platform.isAndroid) {
      downloadDirPath = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
      Directory dir = Directory(downloadDirPath);

      if (!dir.existsSync()) {
        downloadDirPath = (await getExternalStorageDirectory())!.path;
      }
    } else if (Platform.isIOS) {
      // downloadDirPath = (await getApplicationSupportDirectory())!.path;
      downloadDirPath = (await getApplicationDocumentsDirectory()).path;
    }

    return downloadDirPath!;
  }
}
