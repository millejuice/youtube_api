import 'package:flutter/material.dart';
import 'package:youtube/screen/home.dart';
import 'package:youtube/youtube_parser.dart';

void main() { 

  String? videoId = getIdFromUrl('https://www.youtube.com/watch?v=amOSaNX7KJg');
  print(videoId); // Valid url, prints 'dQw4w9WgXcQ'

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'YouTube API',
      initialRoute: '/home', 
      routes: {
        '/home': (context)=> const HomeScreen(),
      },
    );
  }
}

