import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_ed_flutter/modules/home/bloc/home_bloc.dart';
import 'package:health_ed_flutter/modules/home/bloc/home_event.dart';
import 'package:health_ed_flutter/modules/home/bloc/home_state.dart';
import 'package:health_ed_flutter/modules/home/model/request/ReportRequest.dart';
import 'package:htmltopdfwidgets/htmltopdfwidgets.dart' as htmltopdfwidgets;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:pdf/widgets.dart' as pw;

class ReportViewerPage extends StatefulWidget {
  final String userId;

  const ReportViewerPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<ReportViewerPage> createState() => _ReportViewerPageState();
}

class _ReportViewerPageState extends State<ReportViewerPage> {
  String? _htmlContent;
  late final WebViewController _controller;
  bool _isGeneratingPdf = false;

  @override
  void initState() {
    super.initState();
    _initializeWebViewController();
    _fetchReportData();
  }

  void _initializeWebViewController() {
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    _controller = WebViewController.fromPlatformCreationParams(params);

    if (_controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (_controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    _controller.loadRequest(Uri.parse('about:blank'));
  }

  void _fetchReportData() {
    context.read<HomeBloc>().add(
          GetReportRequested(
            reportRequest: ReportRequest(userId: widget.userId),
          ),
        );
  }

  void _loadHtmlContent() {
    if (_htmlContent == null) return;

    final html = '''
      <!DOCTYPE html>
      <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <style>
            body {
              font-family: -apple-system, BlinkMacSystemFont, sans-serif;
              padding: 20px;
              color: #333;
              line-height: 1.5;
            }
            h1, h2, h3 {
              color: #2c3e50;
            }
            table {
              width: 100%;
              border-collapse: collapse;
              margin: 15px 0;
            }
            th, td {
              border: 1px solid #ddd;
              padding: 8px;
              text-align: left;
            }
            th {
              background-color: #f2f2f2;
            }
          </style>
        </head>
        <body>
          ${_htmlContent!}
        </body>
      </html>
    ''';

    _controller.loadHtmlString(html);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnostic Report'),
        actions: [
          IconButton(
              icon: _isGeneratingPdf
                  ? const CircularProgressIndicator()
                  : const Icon(Icons.download),
              onPressed: () async {
                _generatePdf();
              }),
        ],
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is GetReportFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Failed to load report: ${state.message}')),
            );
          } else if (state is GetReportSuccess) {
            setState(() {
              _htmlContent = state.reportResponse.html;
              _loadHtmlContent();
            });
          }
        },
        builder: (context, state) {
          if (state is reportLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_htmlContent == null) {
            return const Center(child: Text('No report data available.'));
          }

          return WebViewWidget(controller: _controller);
        },
      ),
    );
  }

  Future<void> _generatePdf() async {
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async {
      var body = '''
      <!DOCTYPE html>
      <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <style>
            body {
              font-family: -apple-system, BlinkMacSystemFont, sans-serif;
              padding: 20px;
              color: #333;
              line-height: 1.5;
            }
            h1, h2, h3 {
              color: #2c3e50;
            }
            table {
              width: 100%;
              border-collapse: collapse;
              margin: 15px 0;
            }
            th, td {
              border: 1px solid #ddd;
              padding: 8px;
              text-align: left;
            }
            th {
              background-color: #f2f2f2;
            }
          </style>
        </head>
        <body>
          ${_htmlContent ?? ''}
        </body>
      </html>
    ''';

      final pdf = pw.Document();
      final widgets = await htmltopdfwidgets.HTMLToPdf().convert(body);
      pdf.addPage(pw.MultiPage(maxPages: 100, build: (context) => widgets));
      return await pdf.save();
    });
  }
}
