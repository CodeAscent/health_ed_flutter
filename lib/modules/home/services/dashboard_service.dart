import 'dart:convert';
import '../../../core/services/http_wrapper.dart';
import '../models/dashboard_models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

class DashboardService {
  static Future<DashboardResponse> getDashboardData() async {
    try {
      final response = await HttpWrapper.getRequest('dashboard/user-dashboard');

      if (response.statusCode == 200) {
        return DashboardResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load dashboard data');
      }
    } catch (e) {
      throw Exception('Error fetching dashboard data: $e');
    }
  }

  static Future<void> downloadReport() async {
    try {
      final response = await HttpWrapper.getRequest(
        'dashboard/download-report',
      );

      if (response.statusCode == 200) {
        // Get the app's temporary directory
        final dir = await getTemporaryDirectory();
        final fileName = 'report_${DateTime.now().millisecondsSinceEpoch}.pdf';
        final file = File('${dir.path}/$fileName');

        // Write the PDF bytes to file
        await file.writeAsBytes(response.bodyBytes);

        // Open the PDF file
        await OpenFile.open(file.path);
      } else {
        throw Exception('Failed to download report');
      }
    } catch (e) {
      throw Exception('Error downloading report: $e');
    }
  }
}
