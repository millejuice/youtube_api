import 'package:flutter/material.dart';
import 'package:youtube/model/apimodel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //List<Snippet> videos = [];
  late Future<YoutubeVideos> youtubeList;
  late YoutubeVideos youtube;

  @override
  void initState(){             
    super.initState();
    youtubeList = fetchYoutubeList();
    print('init success');
  }

  Future<YoutubeVideos> fetchYoutubeList() async {            //YoutubeVideos가져오고 youtube에 저장
    var part = 'snippet';
    var maxResults = 1;                            
    var playlistId = 'amOSaNX7KJg';
    var key = 'youtube_api_key';
      String url = 'https://www.googleapis.com/youtube/v3/videos?'
  'id=$playlistId&part=$part&maxResults=$maxResults&key=$key';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      print(response.body);
      var decodedData = jsonDecode(response.body);
      print('fetch2');
      youtube = YoutubeVideos.fromJson(decodedData);             //youtube에 YoutubeVideos객체 저장
      var videoList = decodedData['items'] as List<dynamic>;     //items키 이용해서  videoList에 비디오 목록 저장
      setState(() {});
      return youtube;
    } else {
      print('값 없음45');
      throw Exception('Failed to load mail auth result');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: FutureBuilder<YoutubeVideos>(
              future: fetchYoutubeList(),
              builder: (BuildContext context, AsyncSnapshot snapshot){ 
              if(snapshot.hasData == false)
              {
                print('값 없음50');
                return const Center(child: CircularProgressIndicator());
              }
              else if(snapshot.hasError)
              {
                return Padding(
                      padding: const EdgeInsets.all(8.0),
                      
                      child: Text(
                        'Error: ${snapshot.error}', 
                        style: const TextStyle(fontSize: 15),
                      ),
                    );
              }
              else{
                youtube = snapshot.data!;
                var items = youtube.items;
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.items.length,
                    itemBuilder: (context, index) {
                      var items = snapshot.data!.items;
                      String thumb = '';
                      var thumbnails = items[index].snippet.thumbnails;
                      return SizedBox(
                        width: 140.0,
                        child: Material(
                          color: Colors.white,
                          child: InkWell(
                            onTap: () {
                              var vodId = items[index].snippet.resourceId.videoId;
                              var list = items[index].snippet.playlistId;

                            },
                            child: Column(
                              children: <Widget>[
                                  Image.network(items[index].snippet.thumbnails.high),
                                Text(
                                  items[index].snippet.title, // 제목 부분
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    height: 1.3, //줄간격
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }           
          },
        ),
      );
    }
  }