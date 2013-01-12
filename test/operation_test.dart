library scalaskel_test;

import "package:unittest/unittest.dart";
import "package:dart_story/operation.dart";

import 'dart:json';

Operation op;

main(){
  group('Operation Tests', (){
    setUp(() => op = new Operation());
    test('Add 1 and 1', add_1_and_1);
  });
}

add_1_and_1(){
  // When
  var result = op.add(1, 1);
  
  // Then
  expect(result, equals(2));
}