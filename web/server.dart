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

_email(HttpRequest request, HttpResponse response){
  print("email request");
  var email = env["EMAIL"];
  response.outputStream..writeString(email)
                       ..close();
}

_serveHandler(HttpRequest request, HttpResponse response){
  var query = request.queryParameters["q"];
  print("Query=$query");
  if(query == "Quelle est ton adresse email"){
    _email(request, response);
  } else {
    response.outputStream..writeString("Hello")
                         ..close();   
  }
}