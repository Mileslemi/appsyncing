import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_size/window_size.dart';

import 'app_routing/app_pages.dart';
import 'getx_dependancies.dart';
import 'themes/main_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb && (Platform.isLinux || Platform.isMacOS || Platform.isWindows)) {
    setWindowMinSize(const Size(1000, 800));
  }
  if (Platform.isLinux || Platform.isWindows) {
    // Use the ffi version on linux and windows
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  String title = "DeskTop Platform";

  if (Platform.isAndroid || Platform.isIOS) {
    title = "Mobile Platform";
  }
  runApp(MyApp(
    title: title,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({this.title, super.key});

  final String? title;
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: title ?? '',
      initialRoute: AppPages.initial,
      debugShowCheckedModeBanner: false,
      theme: MainTheme.lightTheme,
      darkTheme: MainTheme.darkTheme,
      defaultTransition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 500),
      themeMode: ThemeMode.system,
      getPages: AppPages.routes,
      initialBinding: ProjectBindings(),
      // home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
