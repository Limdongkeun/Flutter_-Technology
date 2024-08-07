
import 'package:example_test/excel/GlobalExcelDownload.dart';
import 'package:example_test/excel/GlobalExcelUploader.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
  List<ProductDTO> productList = [];

  List<Map<String, dynamic>> eventData = [
    {
      'product_name': '새우깡',
      'product_price': '2000',
      'product_category': '10'
    },
    {
      'product_name': '오징어땅콩',
      'product_price': '3500',
      'product_category': '10'
    },
  ];
  void ExcelDown() {
    ExcelDownloader.saveExcel(eventData, 'product');
  }

  void ExcelUp() async {
    List<Map<String, dynamic>> data = await ExcelUploader.pickFile();
    if (data.isNotEmpty) {
      setState(() {
        productList = data.map((item) {
          return ProductDTO(
            productName: item['product_name'].toString() ?? '',
            productPrice: item['product_price'].toString() ?? '',
            productCategory: item['product_category'].toString() ?? '',
          );
        }).toList();
      });
      debugPrint(productList.toString());
    } else {
      debugPrint('No data found or file processing failed.');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
        body: Column(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 위젯끼리 같은 공간만큼 띄움
              children: <Widget>[
                ElevatedButton( //ElevatedButton-기존의 RaisedButton,버튼을 강조하고 싶을 때 사용
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red
                  ), // 버튼 색은 빨강색으로
                  onPressed: () { // 버튼을 누르면 안에 있는 함수를 실행
                    ExcelDown();
                  },
                  child: const Text(
                    "엑셀 다운로드",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue
                  ), // 버튼 색은 파란색으로
                  onPressed: () { // 버튼을 누르면 안에 있는 함수를 실행
                    ExcelUp();
                  },
                  child: const Text(
                    "엑셀 업로드",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            )
          ],
        )
    );
  }
}
class ProductDTO {
  final String productName;
  final String productPrice;
  final String productCategory;

  ProductDTO({
    required this.productName,
    required this.productPrice,
    required this.productCategory,
  });

  @override
  String toString() {
    return 'ProductDTO{productName: $productName, productPrice: $productPrice, productCategory: $productCategory}';
  }
}