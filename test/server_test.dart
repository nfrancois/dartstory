library test;

import 'dart:io';
//import 'packages/unittest/unittest.dart'
import 'dart:uri';



int currentPort = 12345;
String host = "0.0.0.0";

main() {
  /*
  group("Server Test", (){
    test("Default request", _default_request);
    //test("Default request", _default_request);
    //test("Request email", _email_request);
  });
  */
}

_default_request(){
  /*
  currentPort++;
  print("*** default request");
  // Given
  var server = new DartStoryServer(host, currentPort);
  server.startServer();
 
  HttpClient client = new HttpClient();
  // When
  var connexion = client.get("0.0.0.0", currentPort, "?q=Quelle+est+ton+adresse+email");
  // Then
  connexion.onError = (e) => _failAndStop(server, "Connexion failed : $e");
  connexion.onResponse = (HttpClientResponse response){
    print("response");
    expect(response.statusCode, equals(200));
    server.stopServer();
    /*
    InputStream stream = response.inputStream;
    stream.onError = (e) => _failAndStop(server, "Stream failed : $e");
    stream.onClosed = () => server.stopServer();
    stream.onData = (() { 
      String content = new String.fromCharCodes(stream.read());
      expect(content, equals(env["EMAIL"]));
      stream.close();
    });
    */
  };
  */
}
/*

_failAndStop(DartStoryServer server, String message){
  print("*** FAIL");
  fail(message);
  server.stopServer();
}
*/
