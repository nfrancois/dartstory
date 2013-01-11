library dart_story_server;

import "dart:io";
import 'dart:json';

var env = Platform.environment;


main(){
  var port = env['PORT'] == null ? 12345 : int.parse(env['PORT']);
  var host = "0.0.0.0";
  new DartStoryServer(host, port).startServer();
}

class DartStoryServer {
  
  final Map queryAnswers = {
                            "Quelle est ton adresse email" : env["EMAIL"],
                            "Es tu abonne a la mailing list(OUI/NON)": "OUI",
                            "Es tu heureux de participer(OUI/NON)" : "OUI",
                            "Es tu pret a recevoir une enonce au format markdown par http post(OUI/NON)" : "OUI",
                            "Est ce que tu reponds toujours oui(OUI/NON)" : "NON",
                            "As tu bien recu le premier enonce(OUI/NON)" : "OUI"
  };
 
  final int port;
  final String host;
  final HttpServer _server;
  
  DartStoryServer(this.host, this.port) : _server = new HttpServer();
  
  
  startServer(){
    print('Starting....');
    _server..defaultRequestHandler = _serveHandler
           ..addRequestHandler((req) => req.path=="/enonce/1" && req.method == "POST" , _enonce1)
           ..addRequestHandler((req) => req.path=="/scalaskel/change/1" && req.method == "GET" , _scalaskel)
           ..listen(host, port);
    print('Listening for connections on $host:$port');
  }
  
  stopServer(){
    print("Stopping...");
    _server.close();
  }
  
  String _findAnswer(String query){
    if(query != null && queryAnswers.containsKey(query)){
      return queryAnswers[query];
    } else {
      return "@CodeStory with Dart";    
    }    
  } 
  
  _doAnswer(HttpResponse response, String content){
    response.outputStream..writeString(content)
                         ..writeString("\n")
                         ..flush();
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
    String answer = _findAnswer(query);
    print("Query=$query Answer=$answer");
    _doAnswer(response,answer);
  }
  
  _enonce1(HttpRequest request, HttpResponse response){
    _logRequestInfo(request);
    //response.statusCode = HttpStatus.CREATED;
    _doAnswer(response, "OUI"); 
  }

  _scalaskel(HttpRequest request, HttpResponse response){
    //JSON.stringify(object)
    //_logRequestInfo(request);
    _doAnswer(response, "Not yet !");  
  }
  

}