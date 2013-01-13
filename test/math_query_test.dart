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
    test("divide", should_divide);
    test("with ()", should_calculate_by_priority);
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

should_divide(){
  // When
  String result = analyser.findAnswer("3/2");
  
  // Then
  expect(result, "1,5");    
}

should_calculate_by_priority(){
  // When
  String result = analyser.findAnswer("(1 2)*2");
  // Then
  expect(result, "6");
}
