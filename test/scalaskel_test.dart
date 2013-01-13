library test;

import "package:unittest/unittest.dart";
import "package:dart_story/scalaskel.dart";

import 'dart:json';

MoneyChanger changer;

main(){
  group('MoneyChanger tests', (){
    setUp(() => changer = new MoneyChanger());
    test('Change value 3', change_3);
    test('Change value 8', change_8);
    test('Change value 12', change_12);
    test('Change value 20', change_20);
    test('Change value 22', change_22);
  });
}

change_3(){
  // Given
  List<Money> result = changer.change(3);
  
  // Then
  expect(result.length, equals(1));
  var only = result[0];
  expect(only, equals(new Money(3, 0, 0, 0)));
}

change_8(){
  // Given
  List<Money> result = changer.change(8);
  
  // Then
  expect(result.length, equals(2));
  expect(result, contains(new Money(8, 0, 0, 0)));
  expect(result, contains(new Money(1, 1, 0, 0)));
}

change_12(){
  // Given
  List<Money> result = changer.change(12);
  
  // Then
  expect(result.length, equals(3));
  expect(result, contains(new Money(12, 0, 0, 0)));
  expect(result, contains(new Money(5, 1, 0, 0)));
  expect(result, contains(new Money(1, 0, 1, 0)));
}

change_20(){
  // Given
  List<Money> result = changer.change(20);
  
  // Then
  expect(result.length, equals(5));
  expect(result, contains(new Money(20, 0, 0, 0)));
  expect(result, contains(new Money(13, 1, 0, 0)));
  expect(result, contains(new Money(6, 2, 0, 0)));
  expect(result, contains(new Money(9, 0, 1, 0)));
  expect(result, contains(new Money(2, 1, 1, 0)));
}

change_22(){
  // Given
  List<Money> result = changer.change(22);
  
  // Then
  expect(result.length, equals(8));
  expect(result, contains(new Money(22, 0, 0, 0)));
  expect(result, contains(new Money(15, 1, 0, 0)));
  expect(result, contains(new Money(8, 2, 0, 0)));
  expect(result, contains(new Money(1, 3, 0, 0)));
  expect(result, contains(new Money(11, 0, 1, 0)));
  expect(result, contains(new Money(4, 1, 1, 0)));
  expect(result, contains(new Money(0, 0, 2, 0)));
  expect(result, contains(new Money(1, 0, 0, 1)));
}

