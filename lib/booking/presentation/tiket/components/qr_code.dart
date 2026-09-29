import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

const qrTileColor = Color(0xFFFFFFFF);
const qrModuleColor = Color(0xFF1A1716);

const qrMinCodeSize = 126.0;
const qrModuleSize = 6.0;
const qrQuietZoneModules = 4;

class BookingQrCode extends StatelessWidget {
  const BookingQrCode({required this.data, super.key});

  final String data;

  static int moduleCountFor(String data) => QrCode.fromData(
    data: data,
    errorCorrectLevel: QrErrorCorrectLevel.Q,
  ).moduleCount;

  static double codeSizeFor(String data) {
    final size = moduleCountFor(data) * qrModuleSize;
    return size < qrMinCodeSize ? qrMinCodeSize : size;
  }

  @override
  Widget build(BuildContext context) {
    final qr = QrCode.fromData(
      data: data,
      errorCorrectLevel: QrErrorCorrectLevel.Q,
    );
    final size = codeSizeFor(data);
    final quietZone = size / qr.moduleCount * qrQuietZoneModules;

    return Container(
      decoration: BoxDecoration(
        color: qrTileColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(quietZone),
      child: QrImageView.withQr(
        qr: qr,
        size: size,
        semanticsLabel: 'Kode QR booking $data',
        padding: EdgeInsets.zero,
        backgroundColor: qrTileColor,
        eyeStyle: const QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: qrModuleColor,
        ),
        dataModuleStyle: const QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.square,
          color: qrModuleColor,
        ),
      ),
    );
  }
}
