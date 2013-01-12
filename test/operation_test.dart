library test;

import "package:unittest/unittest.dart";
import "package:dart_story/query_analyser.dart";

Operation op;

main(){
  group('Operation Tests', (){
    setUp(() => op = new Operation());
    test('1+1', add_1_and_1);
    test('1+1', add_2_and_4);
    test('2*3', multiply_2_by_3);
    test('1*5', multiply_1_by_5);
  });
}

add_1_and_1(){
  // When
  var result = op.add(1, 1);
  
  // Then
  expect(result, equals(2));
}

add_2_and_4(){
  // When
  var result = op.add(2, 4);
  
  // Then
  expect(result, equals(6));
}


multiply_2_by_3(){
  // When
  var result = op.multiply(2, 3);
  
  // Then
  expect(result, equals(6)); 
}

multiply_1_by_5(){
  // When
  var result = op.multiply(1, 5);
  
  // Then
  expect(result, equals(5)); 
}