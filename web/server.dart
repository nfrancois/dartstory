library dart_story_server;

import "dart:io";

var env = Platform.environment;

HttpServer _server;

main(){
  startServer();
}

startServer(){
  print('Starting....');
  var port = env['PORT'] == null ? 12345 : int.parse(env['PORT']);
  var ip = "0.0.0.0";

  _server = new HttpServer();
  _server.defaultRequestHandler = _serveHandler; 
  _server.listen(ip, port);


  print('Listening for connections on $ip:$port');
}

stopServer(){
  print("Stopping...");
  _server.close();
}

_answer(HttpResponse response, String content){
  print("Answer=$content");
  response.outputStream..writeString(content)
                       ..close();
}

_serveHandler(HttpRequest request, HttpResponse response){
  var query = request.queryParameters["q"];
  print("Query=$query");
  if(query == "Quelle est ton adresse email"){
    _answer(response, env["EMAIL"]);
  } else if(query == "Es tu abonne a la mailing list(OUI/NON)"){
    _answer(response, env["MAILING_LIST"]);
  } else {
    _answer(response, "Hello");
  }
}