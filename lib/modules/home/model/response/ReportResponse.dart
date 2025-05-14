class ReportResponse {
  final String html;

  ReportResponse({required this.html});

  // Factory for plain HTML string
  factory ReportResponse.fromRawHtml(String rawHtml) {
    return ReportResponse(html: rawHtml);
  }
}
