import 'package:flutter/material.dart';
import 'package:streamer/pages/director.dart';
import 'package:streamer/pages/participant.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _channelNameController = TextEditingController();
  final _userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Image.asset('assets/logo.png'),
            ),
            const SizedBox(height: 25),
            const Text('Multi Streaming Platform'),
            const SizedBox(height: 40),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: TextField(
                controller: _userNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  hintText: 'Username',
                ),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: TextField(
                controller: _channelNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  hintText: 'Channel name',
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // To Participant
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Participant(
                      channelName: _channelNameController.text,
                      userName: _userNameController.text,
                    ),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Participant ',
                    style: TextStyle(fontSize: 20),
                  ),
                  Icon(
                    Icons.live_tv,
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                // To Director
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Director(
                      channelName: _channelNameController.text,
                    ),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Director ',
                    style: TextStyle(fontSize: 20),
                  ),
                  Icon(
                    Icons.cut,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
