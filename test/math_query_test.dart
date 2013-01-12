library test;

import "package:unittest/unittest.dart";
import "package:dart_story/query_analyser.dart";

QueryAnalyser analyser;

// TODO mock
main(){
  group("Math query Tests", (){
    setUp(() => analyser = new QueryAnalyser());
    test("addition", should_add);
    test("multiply", should_multiply);
  });
}

should_add(){
  // When
  String result = analyser.findAnswer("1 1");
  
  // Then
  expect(result, "2");    
}

should_multiply(){
  // When
  String result = analyser.findAnswer("1*1");
  
  // Then
  expect(result, "1");    
}
