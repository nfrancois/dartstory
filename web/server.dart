library dart_story_server;

import "dart:io";
import 'dart:utf';

import 'dart:json';

//import 'package:dart_story/scalaskel.dart';
import '../lib/scalaskel.dart';
import '../lib/query_analyser.dart';
import '../lib/jajascript.dart';


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
           ..addRequestHandler((req) => req.path == "/jajascript/optimize", _jajascript)
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
                         ..close();
  }
  
  // TODO : future ?
  _logRequestInfo(HttpRequest request, var answerCallback){
    if(request.contentLength != -1){
      print("************** Request Body **************");
      var input = request.inputStream;
      input..onData = (()  => print(decodeUtf8(input.read())))
           ..onClosed = () {
        print("******************************************");
        answerCallback();
      };
    } else {
      answerCallback();
    }
  } 
  
  /*****************   Handlers http  *****************/ 
  _serveHandler(HttpRequest request, HttpResponse response){
    _logRequestInfo(request, () {
      var query = request.queryParameters["q"];
      String answer = (query == null) ? "@CodeStory with Dart" : _queryAnalyser.findAnswer(query);
      print("Query=$query Answer=$answer");
      _doAnswer(response,answer);
    });
  }
  
  _enonce1(HttpRequest request, HttpResponse response){
    _logRequestInfo(request, () {
      response.statusCode = HttpStatus.CREATED;
      _doAnswer(response, "OUI"); 
    });
  }
  
  _enonce2(HttpRequest request, HttpResponse response){
    _logRequestInfo(request, () {
      response.statusCode = HttpStatus.CREATED;
      _doAnswer(response, "OUI"); 
    });
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
  
  // TODO utiliser un Future pour lire le body et le ré-utiliser
  _jajascript(HttpRequest request, HttpResponse response){
    var buffer = new StringBuffer();
    var input = request.inputStream;
    input.onData = () => buffer.add(new String.fromCharCodes(input.read()));
    input.onClosed = () {
      try {
        var json = buffer.toString();
        var optim = _doJajaOptim(json);
        var jsonOptiom = optim.toJson();
        response.headers..set(HttpHeaders.CONTENT_TYPE, "application/json");
        print("Receive command=$json optimization=jsonOptiom");
        _doAnswer(response, jsonOptiom);
      } on JSONParseException catch(e){// TODO faire des exceptions fonctionnelle ?
        var error = "JSon tout pourri $e";
        print(error);
        response.statusCode = HttpStatus.BAD_REQUEST;
        _doAnswer(response, error);
      }      
    };
  }
  
   JajaOptimization _doJajaOptim(String json){
    var optim = null;
    Stopwatch stopwatch = new Stopwatch()..start();
    if(json.isEmpty){
      return new JajaOptimization.empty();
    } else {
      var commands = JajaCommand.parseFromJson(json);
      var optimizer = new JajaOptimizer(commands);
      return optimizer.optimize();
    }
    stopwatch.stop();
    print("*** Tmp=${stopwatch.elapsedMilliseconds}");    
  }
  
}