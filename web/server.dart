library dart_story_server;

import "dart:io";

var env = Platform.environment;


main(){
  var port = env['PORT'] == null ? 12345 : int.parse(env['PORT']);
  var host = "0.0.0.0";
  new DartStoryServer(host, port).startServer();
}

class DartStoryServer {
  
  final Map queryAnswers = {
                            "Quelle est ton adresse email" : env["EMAIL"],
                            "Es tu abonne a la mailing list(OUI/NON)": env["MAILING_LIST"],
                            "Es tu heureux de participer(OUI/NON)" : "OUI",
                            "Es tu pret a recevoir une enonce au format markdown par http post(OUI/NON)" : "OUI",
                            "Est ce que tu reponds toujours oui(OUI/NON)" : "NON"
  };
 
  final int port;
  final String host;
  final HttpServer _server;
  
  DartStoryServer(this.host, this.port) : _server = new HttpServer();
  
  
  startServer(){
    print('Starting....');
    _server..defaultRequestHandler = _serveHandler
           ..listen(host, port);
    print('Listening for connections on $host:$port');
  }
  
  stopServer(){
    print("Stopping...");
    _server.close();
  }
  
  _doAnswer(HttpResponse response, String content){
    print("Answer=$content");
    response.outputStream..writeString(content)
                         ..close();
  }
  
  String _findAnswer(String query){
    if(query != null && queryAnswers.containsKey(query)){
      return queryAnswers[query];
    } else {
      return "@CodeStory with Dart";    
    }    
  }
  
  _serveHandler(HttpRequest request, HttpResponse response){
    var query = request.queryParameters["q"];
    String answer = _findAnswer(query);
    print("Query=$query Answer=$answer");
    _doAnswer(response,answer);
  }


}