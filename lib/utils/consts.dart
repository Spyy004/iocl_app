import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iocl_app/services/excelservice.dart';
import 'package:iocl_app/services/mailservice.dart';

final lightTheme = ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffED6B21)),
        useMaterial3: true,
      );

final darkTheme = ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff03134e)),
        useMaterial3: true,
      );

void showGenericToast(message) {
  Fluttertoast.showToast(
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 2,
      gravity: ToastGravity.CENTER,
      msg: message,
      webBgColor: '#E0B0FF',
      webPosition: "center");
}

String formatTime(DateTime time) {
  // Extract hours and minutes
  int hours = time.hour;
  int minutes = time.minute;

  // Determine AM/PM
  String period = (hours < 12) ? 'AM' : 'PM';

  // Convert to 12-hour format
  hours = hours % 12;
  hours = (hours != 0) ? hours : 12;

  // Format the time string
  String formattedTime = '$hours:${_formatMinutes(minutes)} $period';

  return formattedTime;
}

String _formatMinutes(int minutes) {
  // Ensure minutes are formatted with leading zero if needed
  return (minutes < 10) ? '0$minutes' : '$minutes';
}
User? currentUser;
final db = FirebaseFirestore.instance;
bool isUserAdmin = false;
Map<String,dynamic>? loggedInUser;
ExcelService excelService = ExcelService();
MailService mailService = MailService();