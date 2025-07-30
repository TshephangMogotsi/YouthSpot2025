// import 'package:url_launcher/url_launcher.dart';

// import 'file_model.dart';

// // Function to open a PDF file from a URL
// Future<void> openFile(PDFDocument doc) async {
//   final Uri fileUrl = Uri.parse(doc.url); // Convert the URL string to a Uri

//   if (await canLaunchUrl(fileUrl)) {
//     await launchUrl(fileUrl, mode: LaunchMode.externalApplication); // Opens in the default browser or app
//   } else {
//     print("Could not launch $fileUrl");
//     // Optionally, show a snackbar or dialog to notify the user
//   }
// }
