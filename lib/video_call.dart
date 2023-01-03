import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_meet/data_management.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

class VideoMeetScreen extends StatelessWidget {
  final String conferenceId;
  final String userName;
  final String userId;

  const VideoMeetScreen(
      {Key? key,
      required this.conferenceId,
      required this.userName,
      required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltVideoConference(
        appID: int.parse(DataManagement.getAppId),
        appSign: DataManagement.getAppSigningKey,
        conferenceID: conferenceId,
        userID: userId,
        userName: userName,
        config: ZegoUIKitPrebuiltVideoConferenceConfig(
            turnOnCameraWhenJoining: false,
            turnOnMicrophoneWhenJoining: false,
            useSpeakerWhenJoining: true,
            leaveConfirmDialogInfo: ZegoLeaveConfirmDialogInfo(
              title: "Leave the conference",
              message: "Are you sure to leave the conference?",
              cancelButtonName: "Cancel",
              confirmButtonName: "Confirm",
            ),
            topMenuBarConfig: ZegoTopMenuBarConfig(
              buttons: [
                ZegoMenuBarButtonName.showMemberListButton,
                ZegoMenuBarButtonName.chatButton
              ],
            ),
            bottomMenuBarConfig: ZegoBottomMenuBarConfig(buttons: [
              ZegoMenuBarButtonName.toggleCameraButton,
              ZegoMenuBarButtonName.toggleMicrophoneButton,
              ZegoMenuBarButtonName.switchAudioOutputButton,
              ZegoMenuBarButtonName.leaveButton,
              ZegoMenuBarButtonName.switchCameraButton,
            ], extendButtons: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(60, 60),
                  shape: const CircleBorder(),
                  backgroundColor: const Color(0xff2C2F3E).withOpacity(0.6),
                ),
                child: const Icon(Icons.copy),
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: conferenceId));

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('MeetId Copied to clipboard')));
                },
              )
            ])),
      ),
    );
  }
}
