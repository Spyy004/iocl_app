import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:iocl_app/app.dart';
import 'package:iocl_app/services/firebase_options.dart';
import 'package:iocl_app/stores/adminstore.dart';
import 'package:iocl_app/stores/dashboardstore.dart';
import 'package:iocl_app/stores/requeststore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
    await Hive.openBox("iocl");
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => DashboardStore()),
          ChangeNotifierProvider(create: (context) => AdminStore()),
          ChangeNotifierProvider(create: (context) => RequestStore()),
        ],
        child: MyApp(),
      ),
    );
}
