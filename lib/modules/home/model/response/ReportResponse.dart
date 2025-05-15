import 'dart:typed_data';

class ReportResponse {
  final Uint8List pdfBytes;

  ReportResponse({required this.pdfBytes});

  factory ReportResponse.fromPdfBytes(Uint8List bytes) {
    return ReportResponse(pdfBytes: bytes);
  }
}
