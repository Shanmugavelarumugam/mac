// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

// class QrScannerScreen extends StatefulWidget {
//   @override
//   _QrScannerScreenState createState() => _QrScannerScreenState();
// }

// class _QrScannerScreenState extends State<QrScannerScreen> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   QRViewController? controller;
//   String? scannedResult;

//   @override
//   void reassemble() {
//     super.reassemble();
//     if (Platform.isAndroid) {
//       controller!.pauseCamera();
//     }
//     controller!.resumeCamera();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Scan QR Code')),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             flex: 5,
//             child: QRView(
//               key: qrKey,
//               onQRViewCreated: _onQRViewCreated,
//               overlay: QrScannerOverlayShape(
//                 borderColor: Colors.green,
//                 borderRadius: 10,
//                 borderLength: 30,
//                 borderWidth: 10,
//                 cutOutSize: 300,
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Center(
//               child: Text(
//                 scannedResult != null
//                     ? 'Scanned: $scannedResult'
//                     : 'Scan a code',
//                 style: TextStyle(fontSize: 16),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _onQRViewCreated(QRViewController qrController) {
//     this.controller = qrController;
//     qrController.scannedDataStream.listen((scanData) {
//       qrController.pauseCamera();
//       setState(() {
//         scannedResult = scanData.code;
//       });

//       // Navigate back and pass scanned data
//       Navigator.pop(context, scanData.code);
//     });
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
// }
