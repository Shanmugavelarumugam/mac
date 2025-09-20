// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

// class QrScannerScreen extends StatefulWidget {
//   @override
//   State<QrScannerScreen> createState() => _QrScannerScreenState();
// }

// class _QrScannerScreenState extends State<QrScannerScreen> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   QRViewController? controller;
//   String? qrText;

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           QRView(
//             key: qrKey,
//             onQRViewCreated: _onQRViewCreated,
//             overlay: QrScannerOverlayShape(
//               borderColor: Colors.green,
//               borderRadius: 10,
//               borderLength: 30,
//               borderWidth: 10,
//               cutOutSize: MediaQuery.of(context).size.width * 0.7,
//             ),
//           ),
//           Positioned(
//             top: 40,
//             left: 16,
//             child: IconButton(
//               icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
//               onPressed: () => Navigator.pop(context),
//             ),
//           ),
//           if (qrText != null)
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 color: Colors.black54,
//                 child: Text(
//                   'Result: $qrText',
//                   style: const TextStyle(color: Colors.white, fontSize: 16),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//     controller.scannedDataStream.listen((scanData) {
//       setState(() {
//         qrText = scanData.code;
//       });
//       controller.pauseCamera();
//       Navigator.pop(context, qrText);
//     });
//   }
// }
