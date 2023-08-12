import 'package:flutter/material.dart';
import 'package:multi_select_dropdown/DropdownComponent/dropdown_component.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              background: Colors.white,
              surface: Colors.white),
          useMaterial3: true,
          primaryColor: const Color(0xff1677ff),
          hintColor: const Color(0xffc2c2c2),
          cardColor: const Color(0xfff0f0f0),
          shadowColor: Colors.grey.withOpacity(0.4),
          dividerColor: const Color(0xffe1e1e1),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Color(0xff292929)),
          ),
          iconTheme: const IconThemeData(color: Color(0xffd3d3d3), size: 24)),
      home: const DropdownComponent(),
    );
  }
}
