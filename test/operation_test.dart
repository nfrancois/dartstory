library scalaskel_test;

import "package:unittest/unittest.dart";
import "package:dart_story/operation.dart";

import 'dart:json';

Operation op;

main(){
  group('Operation Tests', (){
    setUp(() => op = new Operation());
    test('1+1', add_1_and_1);
    test('2*3', multiply_2_by_3);
  });
}

add_1_and_1(){
  // When
  var result = op.add(1, 1);
  
  // Then
  expect(result, equals(2));
}

multiply_2_by_3(){
  // When
  var result = op.multiply(2, 3);
  
  // Then
  expect(result, equals(6)); 
}