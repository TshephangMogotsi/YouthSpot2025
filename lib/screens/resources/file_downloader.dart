import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class FileDownloader {
  final Dio _dio = Dio();

  Future<void> downloadFile(
    BuildContext context,
    String url,
    String fileName,
    Function(int, int) onProgress,
  ) async {
    try {
      Directory? directory;
      print('Starting download for $fileName');

      if (Platform.isAndroid) {
        print('Requesting storage permission on Android');
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        final sdkInt = androidInfo.version.sdkInt;

        bool hasPermission = false;

        if (sdkInt >= 30) {
          // Android 11+ (Scoped Storage)
          var status = await Permission.manageExternalStorage.request();
          hasPermission = status.isGranted;
        } else {
          // Android 10 and below
          var status = await Permission.storage.request();
          hasPermission = status.isGranted;
        }

        if (hasPermission) {
          print('Storage permission granted');
          directory = Directory('/storage/emulated/0/Download');
        } else {
          print('Storage permission denied');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text("Storage permission is required to download files.")),
          );
          return;
        }
      } else if (Platform.isIOS) {
        print('Getting documents directory on iOS');
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) {
        print('Failed to get download directory');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not access storage directory.")),
        );
        return;
      }

      print('Download directory: ${directory.path}');
      String savePath = await _getUniqueFilePath(directory.path, fileName);
      print('Saving file to: $savePath');

      await _dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          print('Download progress: $received/$total');
          onProgress(received, total);
        },
      );

      print('File saved to: $savePath');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("File saved to Downloads: $fileName")),
      );
    } catch (e) {
      print('Error downloading file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Download failed: $e")),
      );
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
}
