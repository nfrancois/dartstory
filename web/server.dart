library dart_delivert_client;

import "dart:io";

var env = Platform.environment;

main(){
  print('Starting....');
  var port = env['PORT'] == null ? 12345 : int.parse(env['PORT']);
  var ip = "0.0.0.0";

  var server = new HttpServer();
  server.defaultRequestHandler = _serveHandler; 
  server.listen(ip, port);


  print('Listening for connections on $ip:$port');
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