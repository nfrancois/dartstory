library test;

import "package:unittest/unittest.dart";
import "package:dart_story/query_analyser.dart";

QueryAnalyser analyser;

// TODO mocker et descendre certains test dans calculator.
main(){
  group("Math query Tests", (){
    setUp(() => analyser = new QueryAnalyser());
    test("addition", should_add);
    test("multiply", should_multiply);
    test("divide", should_divide);
    test("with ()", should_calculate_by_priority);
    test("with ()", should_calculate_with_parent);
    test("with priority", should_calculate_with_priority);
    test("with priority", should_calculate_with_priority_2);
    test('42 is "42"', should_convert_num_int);
    test('4.2 is "4,2"', should_convert_num_double);
    test('6.0 is "6"', should_convert_num_double_as_int);
    //test('long can be convert', should_convert_num_long_int);
    test('operation with float', should_operate_with_float);
  });
}

should_convert_num_int(){
  // When
  String result = analyser.numToString(42.0);
  
  // Then
  expect(result, "42");   
}

// Lose of precision :( . http://stackoverflow.com/questions/14319236/big-number-and-lost-of-precision
should_convert_num_long_int(){
  // When
  String result = analyser.findAnswer("((1.1 2) 3.14 4 (5 6 7) (8 9 10)*4267387833344334647677634)/2*553344300034334349999000");
  
  // Then
  expect(result, "31878018903828899277492024491376690701584023926880");    
}

should_convert_num_double(){
  // When
  String result = analyser.numToString(4.2);
  
  // Then
  expect(result, "4,2");   
}

should_convert_num_double_as_int(){
  // When
  String result = analyser.numToString(6.0);
  
  // Then
  expect(result, "6");   
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

should_calculate_with_parent(){
  // When
  String result = analyser.findAnswer("(1 2) 3 4 (5 6 7) (8 9 10)");
  // Then
  expect(result, "55");
}

should_calculate_with_priority(){
  // When
  String result = analyser.findAnswer("1 2*2");
  // Then
  expect(result, "5");
}

should_calculate_with_priority_2(){
  // When
  String result = analyser.findAnswer("2*2 1");

  // Then
  expect(result, "5");
}


should_operate_with_float(){
  // When 
  var result = analyser.findAnswer("1,5*4");
  
  // Then
  expect(result, "6");     
}
