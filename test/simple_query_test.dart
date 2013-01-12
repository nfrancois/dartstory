library test;

import "package:unittest/unittest.dart";
import "package:dart_story/query_analyser.dart";

QueryAnalyser analyser;

main(){
  group("Simple query Tests", (){
    setUp(() => analyser = new QueryAnalyser());
    test("response email", should_reponse_email);
    test("mailing list", should_be_abonne);
    test("I am Happy", should_be_happy);
    test("I am ready to reveive markdown", should_be_ready);
    test("I don't always anwers OUI", should_not_always_response_oui);
    test("Enonce 1 ok", should_have_receive_enonce1);
  });
}

should_reponse_email(){
  // When
  var response = analyser.findAnswer("Quelle est ton adresse email");
  
  // Then
  expect(response, equals("nicolas.franc@gmail.com"));
}

should_be_abonne(){
  // When
  var response = analyser.findAnswer("Es tu abonne a la mailing list(OUI/NON)");
  
  // Then
  expect(response, equals("OUI"));
}

should_be_happy(){
  // When
  var response = analyser.findAnswer("Es tu heureux de participer(OUI/NON)");
  
  // Then
  expect(response, equals("OUI"));  
}

should_be_ready(){
  // When
  var response = analyser.findAnswer("Es tu pret a recevoir une enonce au format markdown par http post(OUI/NON)");
  
  // Then
  expect(response, equals("OUI")); 
}

should_not_always_response_oui(){
  // When
  var response = analyser.findAnswer("Est ce que tu reponds toujours oui(OUI/NON)");
  
  // Then
  expect(response, equals("NON")); 
}

should_have_receive_enonce1(){
  // When
  var response = analyser.findAnswer("As tu bien recu le premier enonce(OUI/NON)");
  
  // Then
  expect(response, equals("OUI")); 
}
