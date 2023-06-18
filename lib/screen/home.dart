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
  String url = 'https://www.youtube.com/watch?v=amOSaNX7KJg';
  List<Snippet> videos = [];
  late Future<YoutubeVideos> youtubeList;
  late YoutubeVideos youtube;

  @override
  void initState(){             //initState는 처음만 실행되서 futurebuilder만들기 전에 실행 안될수도 있어서 바굼
    super.initState();
    youtubeList = fetchYoutubeList();
    print('init success');
  }

  Future<YoutubeVideos> fetchYoutubeList() async {            //YoutubeVideos가져오고 youtube에 저장
    var part = 'snippet';
    var maxResults = 10; //자신이 가지고 오고 싶은 개수
    var playlistId = 'v=amOSaNX7KJg';
    var key = 'AIzaSyBHdbdKJmDcfDuF_XcbHLXbpwzueO9ISB8';
      String url = 'https://www.googleapis.com/youtube/v3/videos?'
  'id=$playlistId&part=$part&maxResults=$maxResults&key=$key';
        print(url);
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      print(response.body);
      var decodedData = jsonDecode(response.body);
      print('fetch2');
      youtube = YoutubeVideos.fromJson(decodedData);     //youtube에 YoutubeVideos객체 저장
      var videoList = decodedData['items'] as List<dynamic>;    //items키 이용해서  videoList에 비디오 목록 저장
      print('response.body: ${response.body}');
       //print(youtube);
      // print(videoList);
      return youtube;
    } else {
      print('값 없음37');
      throw Exception('Failed to load mail auth result');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: FutureBuilder(
              future: youtubeList,
              builder: (BuildContext context, AsyncSnapshot snapshot){ 
              if(snapshot.hasData == false)
              {
                // print(snapshot.data);
                print('값 없음50');
                return const Center(child: CircularProgressIndicator());
              }
              else if(snapshot.hasError)
              {
                return Padding(
                      padding: const EdgeInsets.all(8.0),
                      
                      child: Text(
                        'Error: ${snapshot.error}', // 에러명을 텍스트에 뿌려줌
                        style: const TextStyle(fontSize: 15),
                      ),
                    );
              }
              else{
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
                                    //  launch(link, forceSafariVC: false);
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        //썸네일부분 구현 필요
                                          Image.network(url),
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
                      return const Center(
                        child: Text('Nothing'),
                      );
                      },
                    ),
                  );
                }
              }