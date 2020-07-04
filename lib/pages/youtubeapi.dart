import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:tirthankar/core/keys.dart';
import 'package:tirthankar/pages/_api.dart';
import 'package:dio/src/response.dart' as eos;
// import 'package:youtube_api/_api.dart';

class YoutubeAPIA {
  static const MethodChannel _channel = const MethodChannel('youtube_api');
  String key;
  String type;
  String query;
  String prevPageToken;
  String nextPageToken;
  int maxResults;
  API api;
  int page;
  final String _baseUrl = 'www.googleapis.com';
  
//  Constructor
  YoutubeAPIA(this.key, {String type, int maxResults: 10}) {
    page = 0;
    this.type = type;
    this.maxResults = maxResults;
    api = new API(key: this.key, maxResults: this.maxResults, type: this.type);
  }

//  For Searching on YouTube
  Future<List> search(String query, {String type}) async {
    this.query = query;
    Uri url = api.searchUri(query, type: type);
    var res = await http.get(url, headers: {"Accept": "application/json"});
    var jsonData = json.decode(res.body);
    print(url);
    _write(jsonData.toString(),"firstsearch");
    if (jsonData['error'] != null){
      print(jsonData['error']);
      return [];
    }
    if (jsonData['pageInfo']['totalResults'] == null) return [];
    List<YT_API> result = _getResultFromJson(jsonData);
    return result;
  }

  Future<List> searchVideo(String query) async {
    bool nextpage=false;
    Map<String, String> parameters;
    if (nextPageToken == null){
      parameters = {
      'part': 'snippet',
      'q': query,      
      'maxResults': '10',      
      'key': key,
      };
    } else {
      nextpage=true;
      parameters = {
        'part': 'snippet',
        'q': query,      
        'maxResults': '10',
        'pageToken': nextPageToken,
        'key': key,
      };
    }
    // Map<String, String> parameters = {
    //   'part': 'snippet',
    //   'q': playlistId,      
    //   'maxResults': '10',
    //   'pageToken': _nextPageToken,
    //   'key': YOUTUBE_KEY,
    // };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/search',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Playlist Videos
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
           
      if (jsonData['pageInfo']['totalResults'] == null) return [];
        if (nextpage==true){
          List<YT_API> result = [];
          nextPageToken = jsonData['nextPageToken'];
          prevPageToken = jsonData['prevPageToken'];
          api.setNextPageToken(nextPageToken);
          api.setPrevPageToken(prevPageToken);
          int total = jsonData['pageInfo']['totalResults'] <
                  jsonData['pageInfo']['resultsPerPage']
              ? jsonData['pageInfo']['totalResults']
              : jsonData['pageInfo']['resultsPerPage'];
          for (int i = 0; i < total; i++) {
            result.add(new YT_API(jsonData,i));
          }
          page++;
          if (total == 0) {
            return null;
          }
          return result;
        } else {
          nextPageToken = jsonData['nextPageToken'] ?? ''; 
          List<YT_API> result = _getResultFromJson(jsonData);
          return result;
        }

        
        // Fetch first eight videos from uploads playlist
        
      
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

// For getting all videos from youtube channel
  Future<List> channel(String channelId, {String order}) async {
    Uri url = api.channelUri(channelId, order);
    var res = await http.get(url, headers: {"Accept": "application/json"});
    var jsonData = json.decode(res.body);
    List<YT_API> result = _getResultFromJson(jsonData);
    return result;
  }

  List<YT_API> _getResultFromJson(jsonData) {
    List<YT_API> result = [];
    if (jsonData == null) return [];

    nextPageToken = jsonData['nextPageToken'];
    api.setNextPageToken(nextPageToken);
    int total = jsonData['pageInfo']['totalResults'] <
            jsonData['pageInfo']['resultsPerPage']
        ? jsonData['pageInfo']['totalResults']
        : jsonData['pageInfo']['resultsPerPage'];
    for (int i = 0; i < total; i++) {
      result.add(new YT_API(jsonData,i));
    }
    page = 1;
    return result;
  }

  _write(String json,String filename) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final File file = File('${directory.path}/{$filename}.txt');
  await file.writeAsString(json);
}

// To go on Next Page
  Future<List> nextPage() async {
    List<YT_API> result = [];
    Uri url = api.nextPageUri();
    print(url);
    
    
         
    var res = await http.get(url, headers: {"Accept": "application/json"});
    var jsonData = json.decode(res.body);
    _write(jsonData.toString(),nextPageToken); 
    if (jsonData['pageInfo']['totalResults'] == null) return [];
    if (jsonData == null) return [];
    print("Http response");
    nextPageToken = jsonData['nextPageToken'];
    prevPageToken = jsonData['prevPageToken'];
    api.setNextPageToken(nextPageToken);
    api.setPrevPageToken(prevPageToken);
    int total = jsonData['pageInfo']['totalResults'] <
            jsonData['pageInfo']['resultsPerPage']
        ? jsonData['pageInfo']['totalResults']
        : jsonData['pageInfo']['resultsPerPage'];
    for (int i = 0; i < total; i++) {
      result.add(new YT_API(jsonData,i));
    }
    page++;
    if (total == 0) {
      return null;
    }
    return result;
  }

  Future<List> prevPage() async {
    List<YT_API> result = [];
    Uri url = api.nextPageUri();
    print(url);
    var res = await http.get(url, headers: {"Accept": "application/json"});
    var jsonData = json.decode(res.body);

    if (jsonData['pageInfo']['totalResults'] == null) return [];

    if (jsonData == null) return [];

    nextPageToken = jsonData['nextPageToken'];
    prevPageToken = jsonData['prevPageToken'];
    api.setNextPageToken(nextPageToken);
    api.setPrevPageToken(prevPageToken);
    int total = jsonData['pageInfo']['totalResults'] <
            jsonData['pageInfo']['resultsPerPage']
        ? jsonData['pageInfo']['totalResults']
        : jsonData['pageInfo']['resultsPerPage'];
    for (int i = 0; i < total; i++) {
      // result.add(new YT_API(jsonData['items'][i],));
      result.add(new YT_API(jsonData,i,));
    }
    if (total == 0) {
      return null;
    }
    page--;
    return result;
  }

//  Get Current Page
  int get getPage => page;

//  Getter and Setter for Max Result Per page
  set setmaxResults(int maxResults) => this.maxResults = maxResults;

  get getmaxResults => this.maxResults;

//  Getter and Setter Key
  set setKey(String key) => api.key = key;

  String get getKey => api.key;

//  Getter and Setter for query
  set setQuery(String query) => api.query = query;

  String get getQuery => api.query;

//  Getter and Setter for type
  set setType(String type) => api.type = type;

  String get getType => api.type;
}

//To Reduce import
// I added this here
class YT_API {
  dynamic thumbnail;
  String kind,
      id,
      publishedAt,
      channelId,
      channelurl,
      title,
      description,
      channelTitle,
      url;
  int totalresult;

  YT_API(dynamic jsondata,int index) {
    dynamic data = jsondata['items'][index];
    

    thumbnail = {
      'default': data['snippet']['thumbnails']['default'],
      'medium': data['snippet']['thumbnails']['medium'],
      'high': data['snippet']['thumbnails']['high']
    };
    kind = data['id']['kind'].substring(8);
    id = data['id'][data['id'].keys.elementAt(1)];
    // print(data['id'].keys.elementAt(1));
    
    url = getURL(kind, id);
    publishedAt = data['snippet']['publishedAt'];
    channelId = data['snippet']['channelId'];
    channelurl = "https://www.youtube.com/channel/$channelId";
    title = data['snippet']['title'];
    print(title + publishedAt);
    description = data['snippet']['description'];
    channelTitle = data['snippet']['channelTitle'];
    totalresult = jsondata['pageInfo']['totalResults'];
    // print(id + publishedAt);
  }

  String getURL(String kind, String id) {
    String baseURL = "https://www.youtube.com/";
    switch (kind) {
      case 'channel':
        return "$baseURL watch?v=$id";
        break;
      case 'video':
        return "$baseURL watch?v=$id";
        break;
      case 'playlist':
        return "$baseURL watch?v=$id";
        break;
    }
    return baseURL;
  }
}
