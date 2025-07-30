import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileDownloader {
  final Dio _dio = Dio();

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  Future<void> downloadFile(BuildContext context, String url, String fileName, Function(int, int) onProgress) async {
    try {
      Directory? directory;

      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = Directory('/storage/emulated/0/Download');
        } else {
          // Handle permission denial
          return;
        }
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory != null) {
        String savePath = await _getUniqueFilePath(directory.path, fileName);

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

  Future<String> _getUniqueFilePath(String directoryPath, String fileName) async {
    String filePath = '$directoryPath/$fileName';
    String fileExtension = '';
    String baseFileName = fileName;

    if (fileName.contains('.')) {
      fileExtension = fileName.substring(fileName.lastIndexOf('.'));
      baseFileName = fileName.substring(0, fileName.lastIndexOf('.'));
    }

    int fileSuffix = 1;
    while (await File(filePath).exists()) {
      filePath = '$directoryPath/$baseFileName($fileSuffix)$fileExtension';
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
