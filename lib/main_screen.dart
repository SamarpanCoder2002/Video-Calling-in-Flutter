import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:video_meet/video_call.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  _beautifyScreen(
      {Color navigationBarColor = Colors.white,
      Color statusBarColor = Colors.transparent,
      Brightness? statusIconBrightness = Brightness.dark,
      Brightness? navigationIconBrightness = Brightness.dark}) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: navigationBarColor, // navigation bar color
      statusBarColor: statusBarColor, // status bar color
      statusBarIconBrightness: statusIconBrightness,
      systemNavigationBarIconBrightness: navigationIconBrightness,
    ));
  }

  @override
  void initState() {
    _beautifyScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _commonButton('Start a Meeting', () {
              _joinMeeting(
                  meetId:
                      'video_call_${DateTime.now().microsecondsSinceEpoch}');
            }),
            const SizedBox(height: 30),
            _commonButton('Join Meeting', _joinMeeting),
          ],
        ),
      ),
    );
  }

  _commonButton(String btnText, VoidCallback onTap) {
    return ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff0155FE),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            )),
        child: Text(
          btnText,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ));
  }

  void _joinMeeting({String meetId = ''}) async {
    final Map<Permission, PermissionStatus> _permissionStatuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    final _permissionResultMap =
        _permissionStatuses.map((key, value) => MapEntry(key, value.isGranted));

    final _allPermissionResult = _permissionResultMap.values.toList();

    if (_allPermissionResult.contains(false)) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All Permission Need to Proceed')));
      return;
    }

    final TextEditingController _meetIdController = TextEditingController();
    final TextEditingController _userNameController = TextEditingController();

    _joinContentWidget() {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: meetId.isEmpty ? 300 : 100,
        margin: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          children: [
            if (meetId.isEmpty)
              TextFormField(
                  controller: _meetIdController,
                  cursorColor: const Color(0xff424242),
                  decoration: InputDecoration(
                    enabledBorder: _commonBorder,
                    focusedBorder: _commonBorder,
                    border: _commonBorder,
                    filled: true,
                    hintText: 'Meeting Id',
                    fillColor: const Color(0xFFF3F2F2),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 17, horizontal: 15),
                  )),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
                controller: _userNameController,
                cursorColor: const Color(0xff424242),
                decoration: InputDecoration(
                  enabledBorder: _commonBorder,
                  focusedBorder: _commonBorder,
                  border: _commonBorder,
                  filled: true,
                  hintText: 'User Name',
                  fillColor: const Color(0xFFF3F2F2),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 17, horizontal: 15),
                )),
          ],
        ),
      );
    }

    showDialog(
        context: context,
        builder: (_) => StatefulBuilder(
            builder: (_, __) => AlertDialog(
                  insetPadding: const EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  title: _joinTitle(),
                  content: _joinContentWidget(),
                  actionsAlignment: MainAxisAlignment.center,
                  actions: [
                    _commonButton("Let's Join", () {
                      if (meetId.isEmpty && _meetIdController.text.isEmpty) {
                        return;
                      }

                      final _confId =
                          meetId.isEmpty ? _meetIdController.text : meetId;

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => VideoMeetScreen(
                              conferenceId: _confId,
                              userName: _userNameController.text,
                              userId: DateTime.now()
                                  .microsecondsSinceEpoch
                                  .toString())));
                    }),
                  ],
                )));
  }

  _joinTitle() {
    return const Center(
      child: Text(
        'Enter Meeting Id',
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
      ),
    );
  }

  get _commonBorder => OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(
            color: const Color(0xff424242).withOpacity(0.4), width: 2),
      );
}
