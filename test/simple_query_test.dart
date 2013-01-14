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
    test("Big calcul", big_calcul);
    test("J ai mal dormi", mal_dormi);
    test("Enonce 2 ok", should_have_receive_enonce2);
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

should_have_receive_enonce2(){
  // When
  var response = analyser.findAnswer("As tu bien recu le second enonce(OUI/NON)");
  
  // Then
  expect(response, equals("OUI")); 
}

big_calcul(){
  // When
  var response = analyser.findAnswer("((1,1 2) 3,14 4 (5 6 7) (8 9 10)*4267387833344334647677634)/2*553344300034334349999000");
  
  // Then
  expect(response, equals("31878018903828899277492024491376690701584023926880")); 

}

mal_dormi(){
  // When
  var response = analyser.findAnswer("As tu passe une bonne nuit malgre les bugs de l etape precedente(PAS_TOP/BOF/QUELS_BUGS)");
  
  // Then
  expect(response, equals("PAS_TOP"));   
}