import 'package:flutter/material.dart';
import 'package:video_meet/data_management.dart';

import 'main_screen.dart';

void main() async{
  await DataManagement.loadEnvData;
  runApp(const EntryRoot());
}

class EntryRoot extends StatelessWidget {
  const EntryRoot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ZegoCloud Testing',
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: child!,
      ),
      home: const MainScreen(),
    );
  }
}
