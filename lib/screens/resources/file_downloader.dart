import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileDownloader {
  final Dio _dio = Dio();

  Future<void> downloadFile(BuildContext context, String url, String fileName, Function(int, int) onProgress) async {
    try {
      Directory? directory;

      // Check if the platform is iOS or Android
      if (Platform.isAndroid) {
        // For Android, request permission and use the public Download folder
        if (await Permission.storage.request().isGranted) {
          directory = Directory('/storage/emulated/0/Download');
        }
      } else if (Platform.isIOS) {
        // For iOS, use the app's Documents directory
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory != null) {
        // Get the file path
        String savePath = await _getUniqueFilePath(directory.path, fileName, promptIfExists: false);

        // Check if the file already exists
        File file = File(savePath);
        if (await file.exists()) {
          // Show confirmation dialog
          bool shouldDownload = await _showDownloadConfirmationDialog(context, fileName);
          if (!shouldDownload) {
            return; // If user cancels, stop the download
          }
        }

        // Proceed to download the file if user confirms
        savePath = await _getUniqueFilePath(directory.path, fileName, promptIfExists: true);
        await _dio.download(
          url,
          savePath,
          onReceiveProgress: (received, total) {
            onProgress(received, total); // Report progress
          },
        );

        print('File saved to: $savePath');
      } else {
        print('Failed to get directory');
      }
    } catch (e) {
      print('Error downloading file: $e');
    }
  }

  Future<String> _getUniqueFilePath(String directoryPath, String fileName, {bool promptIfExists = false}) async {
    String filePath = '$directoryPath/$fileName';
    String fileExtension = '';
    String baseFileName = fileName;

    // Extract file extension and base file name
    if (fileName.contains('.')) {
      fileExtension = fileName.substring(fileName.lastIndexOf('.'));
      baseFileName = fileName.substring(0, fileName.lastIndexOf('.'));
    }

    int fileSuffix = 1;
    // Check if the file exists and append a number in parentheses if necessary
    while (await File(filePath).exists() && promptIfExists) {
      filePath = '$directoryPath/$baseFileName ($fileSuffix)$fileExtension';
      fileSuffix++;
    }

    return filePath;
  }

  Future<bool> _showDownloadConfirmationDialog(BuildContext context, String fileName) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Download file again?"),
          content: Text("Do you want to download '$fileName' again?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // User cancels
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // User confirms
              child: const Text("Download again"),
            ),
          ],
        );
      },
    ) ?? false;
  }
}
