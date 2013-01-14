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
           ..addRequestHandler((req) => req.path == "/enonce/2" && req.method == "POST" , _enonce2)
           ..listen(host, port);
    print('Listening for connections on $host:$port');
  }
  
  stopServer(){
    print("Stopping...");
    _server.close();
  }
  
  // TODO Transformer en un Future
  _doAnswer(HttpResponse response, String content, bool close){
    response.outputStream..writeString(content)
                         ..writeString("\n")
                         ..flush();// Si close, le body n'a pas été encore lu
    if(close){
      response.outputStream.close();
    }
  }
  
  // TODO refacto, utiliser, un Future pour executer le _doAnswer le log est fini
  _logRequestInfo(HttpRequest request, HttpResponse response){
    print("************** Request Info **************");
    print("=> Headers");
    request.headers.forEach((key, value) => print("* key=$key : value=$value"));     
    print("=> Parameters");
    request.queryParameters.forEach((key, value) => print("* key=$key : value=$value"));
    print("=> Data (size=${request.contentLength})");
    var input = request.inputStream;
    input.onData = ()  => print(new String.fromCharCodes(input.read()));
    // TODO call Future de réponse.
    input.onClosed = () => response.outputStream.close();// Il fermer la connexion
    print("******************************************");
  } 
  
  /*****************   Handlers http  *****************/ 
  _serveHandler(HttpRequest request, HttpResponse response){
    var query = request.queryParameters["q"];
    String answer = (query == null) ? "@CodeStory with Dart" :_queryAnalyser.findAnswer(query);
    print("Query=$query Answer=$answer");
    _doAnswer(response,answer, true);
  }
  
  _enonce1(HttpRequest request, HttpResponse response){
    _logRequestInfo(request, response);
    response.statusCode = HttpStatus.CREATED;
    _doAnswer(response, "OUI", false); 
  }
  
  _enonce2(HttpRequest request, HttpResponse response){
    _logRequestInfo(request, response);
    response.statusCode = HttpStatus.CREATED;
    _doAnswer(response, "NON", false);
  }  

  _scalaskel(HttpRequest request, HttpResponse response){
    var valueAsString = request.path.substring(18);
    try {
      var value = int.parse(valueAsString);
      var results = _changer.change(value);
      var json = results.map((money) => money.toJson());
      print("Change $value => $json");
      _doAnswer(response, json.toString(), true);
    } on FormatException catch (fe) {
      var error =  "Erreur. Pas un entier. $fe";
      _doAnswer(response, error,  true);
    }
  }
  

}