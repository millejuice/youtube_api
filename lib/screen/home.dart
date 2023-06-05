import 'package:flutter/material.dart';
import 'package:youtube/model/apimodel.dart';
import 'package:youtube/youtube_parser.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String url = 'https://www.youtube.com/watch?v=amOSaNX7KJg';

  late Future<YoutubeVideos> youtubeList;
  YoutubeVideos? youtube;

  void _callAPI() async{
    var response = getIdFromUrl(url);
    print(response);
  }
  @override
  void initState(){
    super.initState();
   youtubeList = fetchYoutubeList();
  }

  Future<YoutubeVideos> fetchYoutubeList() async {
    var part = 'snippet';
    var maxResults = 10; //자신이 가지고 오고 싶은 개수
    var playlistId = 'Youtube url에 있는 재생목록 ID';
    var key = '자신의 API 키';

    var url = 'https://www.googleapis.com/youtube/v3/playlistItems?'
        'playlistId=$playlistId&part=$part&maxResults=$maxResults&key=$key';
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      youtube = YoutubeVideos.fromJson(decodedData);
      return youtube!;
    } else {
      throw Exception('Failed to load mail auth result');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: FutureBuilder(
              future: youtubeList,
              builder: (BuildContext context, AsyncSnapshot snapshot){ 
              // 이 곳 부분에 데이터를 받아오기 전까지 보여줄 Loading창을 구현하면 좋다.
                        SizedBox(
                          height: 145,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.items.length,
                            itemBuilder: (context, index) {
                              var items = snapshot.data.items;

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
                                      var link =
                                          "https://www.youtube.com/watch?v=$vodId&list=$list";
                                      launch(link, forceSafariVC: false);
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        //썸네일부분 구현 필요
                                    
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
                      },
                    ),
                  );
               
                // body: Center(
                //   child: 
                //   ElevatedButton(
                //     onPressed: (){_callAPI();},
                //    child: const Text('Youtube 불러오기')),
                // ),
                  
                }
              }