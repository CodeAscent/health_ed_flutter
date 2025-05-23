import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_ed_flutter/modules/home/bloc/home_bloc.dart';
import 'package:health_ed_flutter/modules/home/bloc/home_event.dart';
import 'package:health_ed_flutter/modules/home/bloc/home_state.dart';
import 'package:health_ed_flutter/modules/home/model/request/ReportRequest.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class ReportViewerPage extends StatefulWidget {
  final String userId;

  const ReportViewerPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<ReportViewerPage> createState() => _ReportViewerPageState();
}

class _ReportViewerPageState extends State<ReportViewerPage> {
  Uint8List? _pdfBytes;
  bool _isGeneratingPdf = false;

  @override
  void initState() {
    super.initState();
    _fetchReportData();
  }

  void _fetchReportData() {
    context.read<HomeBloc>().add(
          GetReportRequested(
            reportRequest: ReportRequest(userId: widget.userId),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnostic Report'),
        actions: [
          IconButton(
            icon: _isGeneratingPdf
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.download),
            onPressed: _pdfBytes != null ? _downloadPdf : null,
          ),
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
              _pdfBytes =
                  state.reportResponse.pdfBytes; // ensure your model has this
            });
          }
        },
        builder: (context, state) {
          if (state is reportLoading || _pdfBytes == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return PdfPreview(
            build: (format) async => _pdfBytes!,
            allowPrinting: true,
            allowSharing: true,
          );
        },
      ),
    );
  }

  Future<void> _downloadPdf() async {
    if (_pdfBytes == null) return;

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => _pdfBytes!,
    );
  }
}
