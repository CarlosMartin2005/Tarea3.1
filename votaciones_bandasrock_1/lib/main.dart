import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:votaciones_bandasrock_1/bandas_de_rock_page.dart';
import 'package:votaciones_bandasrock_1/crearbanda_page.dart';
import 'package:votaciones_bandasrock_1/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const BandasPage(),
      routes: {
        '/crear_banda': (context) => CrearBanda(),
        '/bandas' : (context) => const BandasPage(),
      },
    );
  }
}
