import 'dart:async';


import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class VoiceChatPage extends StatefulWidget {
  const VoiceChatPage({super.key});

  @override
  State<VoiceChatPage> createState() => _VoiceChatPageState();
}

class _VoiceChatPageState extends State<VoiceChatPage> {
  Room? room;
  bool micEnable = true;
  bool isConnected = false;

  Future<String> fetchToken() async {
    final res = await http.get(
      Uri.parse("http://192.168.33.50:3000/getToken")
    );
    return res.body;
  }

  Future<void> joinRoom() async{

    if (isConnected) {
      print("⚠️ Already connected!");
      return;
    }

    await Permission.microphone.request();

    final token = await fetchToken();
    final url = "wss://test-mlgnqqtg.livekit.cloud";

    final newRoom = Room();




    await newRoom.connect(
      url,
      token,
      connectOptions: const ConnectOptions(autoSubscribe: true),
    );

    await newRoom.localParticipant!.setMicrophoneEnabled(micEnable);

    await Hardware.instance.setSpeakerphoneOn(true);
    
    setState(() {
      room = newRoom;
      isConnected = true;
    });

    print("✅ Joined LiveKit room");
  }

  Future<void> disconnectRoom() async {
    if (!isConnected) return;

    await room?.disconnect();
    setState(() {
      room = null;
      isConnected = false;
    });

    print("🔌 Disconnected from LiveKit Room");
  }

  @override
  void dispose() {
    room?.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text("Voice chat")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            ElevatedButton(
              onPressed: () => isConnected ? disconnectRoom() : joinRoom(), 
              child: Text(isConnected ? "Disconnected" : "Join Voice Room"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (room != null && room!.localParticipant != null) {
                  micEnable = !micEnable;
                  room!.localParticipant!.setMicrophoneEnabled(micEnable);
                  setState(() {});
                } else {
                  print("⚠️ Room not connected yet!");
                }
              },  
              child: Text(micEnable ? "Mute Mic" : "Unmute Mic"),
            ),
          ],
        ),
      ),
    );
  }
}

