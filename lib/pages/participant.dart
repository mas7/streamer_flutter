import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/material.dart';
import 'package:streamer/utils/app_id.dart';

class Participant extends StatefulWidget {
  final String channelName;
  final String userName;
  final int uid;
  const Participant({
    Key? key,
    required this.channelName,
    required this.userName,
    required this.uid,
  }) : super(key: key);

  @override
  State<Participant> createState() => _ParticipantState();
}

class _ParticipantState extends State<Participant> {
  List<int> _users = [];
  // Handles the video call
  late RtcEngine _engine;
  // Handles the messaging like pressing the mute button
  // RtmClient -> You login with specific client
  // RtmChannel -> You join a channel
  AgoraRtmClient? _client;
  AgoraRtmChannel? _channel;

  Future<void> initializeAgora() async {
    // By default this starts with audio
    _engine = await RtcEngine.createWithContext(RtcEngineContext(appId));
    _client = await AgoraRtmClient.createInstance(appId);

    // To enable video
    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(ClientRole.Broadcaster);

    // Callbacks for the RTC engine
    _engine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (channel, uid, elapsed) {
          setState(() {
            _users.add(uid);
          });
        },
      ),
    );

    // Callbacks for the RTM client
    _client?.onMessageReceived = (AgoraRtmMessage message, String peerId) {
      print('Private Message from $peerId: {$message.text}');
    };

    _client?.onConnectionStateChanged = (int state, int reason) {
      print('Connection state changed: {$state.toString()} reason: {$reason.toString()}');

      // 5: Connection Aborted
      if (state == 5) {
        _channel?.leave();
        _client?.logout();
        _client?.destroy();
        print("Logged out");
      }
    };

    // Join the Rtm and Rtc channels
    await _client?.login(null, widget.uid.toString());
    _channel = await _client?.createChannel(widget.channelName);
    await _channel?.join();
    await _engine.joinChannel(null, widget.channelName, null, widget.uid);

    // Callbacks for the RTM channel
    _channel?.onMemberJoined = (AgoraRtmMember member) {
      print('Member joined: {$member.userId}, channel: {$member.channelId}');
    };

    _channel?.onMemberLeft = (AgoraRtmMember member) {
      print('Member left: {$member.userId}, channel: {$member.channelId}');
    };

    _channel?.onMessageReceived = (AgoraRtmMessage message, AgoraRtmMember fromMember) {
      // TODO: Implement this
      print('Message received from {$fromMember.userId}: {$message.text}');
    };
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Text('Participant'),
    ));
  }
}
