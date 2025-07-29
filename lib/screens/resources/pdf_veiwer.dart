import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:typed_data';  // Import Uint8List

class PDFViewerPage extends StatefulWidget {
  final String url;  // URL of the PDF to open
  final String fileName;  // Name of the PDF to display

  const PDFViewerPage({super.key, required this.url, required this.fileName});

  @override
  State<PDFViewerPage> createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  PdfControllerPinch? pdfController;
  double progress = 0.0;  // Tracks the progress of the file download
  bool isLoading = true;  // Boolean to track the loading state

  @override
  void initState() {
    super.initState();
    openPDFfromURL();  // Open the PDF directly from the URL
  }

  Future<void> openPDFfromURL() async {
    try {
      final request = http.Request('GET', Uri.parse(widget.url));
      final response = await http.Client().send(request);

      // Track the total file size
      final contentLength = response.contentLength ?? 0;
      List<int> bytes = [];
      int received = 0;

      // Listen to the file download stream
      response.stream.listen(
        (chunk) {
          bytes.addAll(chunk);
          received += chunk.length;

          // Update progress
          setState(() {
            progress = received / contentLength;
          });
        },
        onDone: () {
          // Convert the List<int> to Uint8List
          Uint8List byteData = Uint8List.fromList(bytes);

          // Once done, load the PDF into the controller
          setState(() {
            pdfController = PdfControllerPinch(
              document: PdfDocument.openData(byteData),  // Open the PDF from Uint8List
            );
            isLoading = false;
          });
        },
        onError: (e) {
          print("Error loading PDF: $e");
          setState(() {
            isLoading = false;
          });
        },
        cancelOnError: true,
      );
    } catch (e) {
      print("Error loading PDF: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fileName),
      ),
      body: Column(
        children: [
          if (isLoading)
            LinearProgressIndicator(
              value: progress,  // Show the progress of the download
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          Expanded(
            child: pdfController != null
                ? PdfViewPinch(controller: pdfController!)  // Display the PDF
                : Center(child: isLoading ? null : const Text('Failed to load PDF')),  // Show an error message if PDF fails to load
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    pdfController?.dispose();  // Dispose the controller when not needed
    super.dispose();
  }
}
