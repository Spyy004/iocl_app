
import 'dart:io';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

import '../utils/consts.dart';

class MailService  {
  
  String username = 'batestioclbpl@gmail.com';
  String password = 'ajzf vlbl ctog gnec';


  Future<void> sendEmail(String message, List<dynamic> users, List<dynamic> selectedUsers, String managerEmail, String managerName)async {
    if(managerEmail.isEmpty || managerName.isEmpty) {
      showGenericToast("Cannot Send Email due to technical error. Please try later");
    }
    final smtpServer = gmail(username, password);
    final date = DateTime.now();
    DateTime timeIn15Minutes = date.add(Duration(minutes: 15));
    String formattedTime = formatTime(timeIn15Minutes);


    users.forEach((user) async {
      final message = Message()
        ..from = Address(username, 'IOCL Bhopal')
        ..recipients.add(user['email'])
        ..subject = 'Please Report for Testing'
        ..text = 'Sh. ${user['name']}, you have been selected for carrying out BA test on ${date.day}/${date.month}/${date.year} at ${formattedTime}. Kindly report immediately at AAI BA Test Section. It has to be completed within one hour after reporting on duty. Thanks.';
      try {
        final sendReport = await send(message, smtpServer);
        print('Message sent: ' + sendReport.toString());
      } on MailerException catch (e) {
        print('Message not sent.');
        for (var p in e.problems) {
          print('Problem: ${p.code}: ${p.msg}');
        }
      }
    });

    final message = Message()
      ..from = Address(username, 'IOCL Bhopal')
      ..recipients.addAll([Address(managerEmail)])
      ..subject = 'Please Report for Carrying Testing'
      ..text = 'Sh. ${managerName}, you have been selected for carrying out Breath Analyser test on ${date.day}/${date.month}/${date.year} at ${formattedTime}. Kindly report immediately at AAI BA Test Section. It has to be completed within one hour after reporting on duty. Thanks.\n Selected Workers: \n ${selectedUsers.map((e) => e['name']).toList().join(', ')} \n   Workers to test: \n ${users.map((e) => e['name']).toList().join(', ')}';

    try {
      final sendReport = await send(message, smtpServer);
      showGenericToast(('Email sent: ' + sendReport.toString()));
    } on MailerException catch (e) {
      showGenericToast(('Email not sent'));
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }




  }
}