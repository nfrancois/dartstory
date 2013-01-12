library dart_story_server;

import "dart:io";
import 'dart:json';
//import 'package:dart_story/scalaskel.dart';
import '../lib/scalaskel.dart';
import '../lib/query_analyser.dart';

var env = Platform.environment;


main(){
  var port = env['PORT'] == null ? 12345 : int.parse(env['PORT']);
  var host = "0.0.0.0";
  new DartStoryServer(host, port).startServer();
}

class DartStoryServer {
 
  final int port;
  final String host;
  final HttpServer _server;
  
  final MoneyChanger  _changer;
  final QueryAnalyser _queryAnalyser;
  
  DartStoryServer(this.host, this.port) : _server = new HttpServer(), _changer = new MoneyChanger(), _queryAnalyser = new QueryAnalyser();
  
  startServer(){
    print('Starting....');
    _server..defaultRequestHandler = _serveHandler
           ..addRequestHandler((req) => req.path=="/enonce/1" && req.method == "POST" , _enonce1)
           ..addRequestHandler((req) => req.path.startsWith("/scalaskel/change/") && req.method == "GET" , _scalaskel)
           ..listen(host, port);
    print('Listening for connections on $host:$port');
  }
  
  stopServer(){
    print("Stopping...");
    _server.close();
  }
  
  _doAnswer(HttpResponse response, String content){
    response.outputStream..writeString(content)
                         ..writeString("\n")
                         //..flush()
                         ..close();
  }
  
  _logRequestInfo(HttpRequest request){
    print("************** Request Info **************");
    print(request.path);
    print("=> Headers");
    request.headers.forEach((key, value) => print("* key=$key : value=$value"));     
    print("=> Parameters");
    request.queryParameters.forEach((key, value) => print("* key=$key : value=$value"));
    print("=> Data (size=${request.contentLength})");
    var input = request.inputStream;
    input.onData = ()  => print(new String.fromCharCodes(input.read()));
    print("******************************************");
  }  
  
  /*****************   Handlers http  *****************/ 
  _serveHandler(HttpRequest request, HttpResponse response){
    _logRequestInfo(request);
    var query = request.queryParameters["q"];
    String answer = (query == null) ? "@CodeStory with Dart" :_queryAnalyser.findAnswer(query);
    print("Query=$query Answer=$answer");
    _doAnswer(response,answer);
  }
  
  _enonce1(HttpRequest request, HttpResponse response){
    _logRequestInfo(request);
    response.statusCode = HttpStatus.CREATED;
    _doAnswer(response, "OUI"); 
  }

  _scalaskel(HttpRequest request, HttpResponse response){
    var valueAsString = request.path.substring(18);
    try {
      var value = int.parse(valueAsString);
      var results = _changer.change(value);
      var json = results.map((money) => money.toJson());
      print("Change $value => $json");
      _doAnswer(response, json.toString());
    } on FormatException catch (fe) {
      var error =  "Erreur. Pas un entier. $fe";
      _doAnswer(response, error);
    }
  }
  

}