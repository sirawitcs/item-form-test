import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:item_form/component/custom_textfield_widget.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:item_form/utils/validate.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

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
      ),
      home: const MyHomePage(title: 'Item Form Test'),
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
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController skuController = TextEditingController();
  final TextEditingController itemPriceController = TextEditingController();
  final TextEditingController itemCountController = TextEditingController();
  final TextEditingController itemDescriptiontroller = TextEditingController();
  late DropzoneViewController dropzoneController;
  final MobileScannerController cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    torchEnabled: false,
  );
  String itemType = '';
  String imageNetwork = '';
  Uint8List? imageFile;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Future<void> acceptFile(dynamic event) async {
      final url = await dropzoneController.createFileUrl(event);
      final file = await dropzoneController.getFileData(event);
      setState(() {
        imageNetwork = url;
        imageFile = file;
      });
    }

    void showQRScannerDialog() {
      showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Scan QR Code'),
            content: SizedBox(
              width: 400,
              height: 400,
              child: MobileScanner(
                controller: cameraController,
                fit: BoxFit.cover,
                onDetect: (result) async {
                  if (mounted && result.barcodes.isNotEmpty) {
                    try {
                      final Map<String, dynamic> form = jsonDecode(
                        result.barcodes.first.rawValue ?? '{}',
                      );
                      setState(() {
                        itemNameController.text = form['name'] ?? '';
                        skuController.text = form['sku'] ?? '';
                        itemDescriptiontroller.text = form['desc'] ?? '';
                      });
                      await cameraController.stop();
                      if (mounted) Navigator.pop(context);
                    } catch (e) {}
                  }
                },
              ),
            ),
          );
        },
      );
    }

    bool isImageError() {
      return (formKey.currentState != null &&
          !formKey.currentState!.validate() &&
          (imageFile == null || imageFile!.isEmpty));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomTextfieldWidget(
                        hintText: "ชื่อสินค้า",
                        controller: itemNameController,
                        validator: (value) =>
                            validateString(value, "ชื่อสินค้า"),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: CustomTextfieldWidget(
                        hintText: "รหัสสินค้า",
                        controller: skuController,
                        validator: (value) =>
                            validateString(value, "รหัสสินค้า"),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: 'หมวดหมู่สินค้า',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                        width: 1,
                      ),
                    ),
                  ),
                  validator: (value) =>
                      validateDrowdown(value, 'หมวดหมู่สินค้า'),
                  items: ['เสื้อผ้า', 'อาหาร', 'อุปกรณ์ไอที', 'ยา']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      itemType = value!;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomTextfieldWidget(
                        hintText: "ราคาสินค้า",
                        controller: itemPriceController,
                        validator: (value) =>
                            validateDouble(value, "ราคาสินค้า"),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: CustomTextfieldWidget(
                        hintText: "จำนวนสินค้า",
                        controller: itemCountController,
                        validator: (value) => validateInt(value, "ราคาสินค้า"),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextfieldWidget(
                  hintText: "คำอธิบายสินค้า",
                  controller: itemDescriptiontroller,
                  maxLine: 5,
                  validator: (value) => validateString(value, "ราคาสินค้า"),
                ),
              ),
              Padding(
                padding: EdgeInsetsGeometry.all(8),
                child: Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: (isImageError())
                          ? Colors.red
                          : Colors.grey.shade400,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    children: [
                      imageNetwork.isNotEmpty
                          ? Center(
                              child: Image.network(
                                imageNetwork,
                                width: 344,
                                height: 200,
                                fit: BoxFit.contain,
                              ),
                            )
                          : Center(child: Text('วางไฟล์รูปภาพที่นี่')),
                      DropzoneView(
                        operation: DragOperation.copy,
                        cursor: CursorType.grab,
                        onCreated: (ctrl) => dropzoneController = ctrl,
                        onDropFile: acceptFile,
                        mime: ['image/jpeg', 'image/png'],
                      ),
                    ],
                  ),
                ),
              ),
              if (isImageError())
                Text("รูปภาพห้ามว่าง", style: TextStyle(color: Colors.red)),
              OverflowBar(
                alignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed:
                        (formKey.currentState?.validate() ?? false) &&
                            (imageFile?.isNotEmpty ?? false) &&
                            itemType.isNotEmpty
                        ? () {}
                        : null,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(' submit'),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await Permission.camera.request();
                      final status = await Permission.camera.status;
                      if (status.isGranted) {
                        showQRScannerDialog();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('แสกน Qrcode'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
