library test;

import "package:unittest/unittest.dart";
import "package:dart_story/query_analyser.dart";

Calculator calculator;

main(){
  group('Calculator Tests', (){
    setUp(() => calculator = new Calculator());
    test('"1" is 1', to_num_one);
    test('"42" is 42', to_num_double);
    test('"1,5" is 1,5', one_is_one_and_half);
    test('1+1', add_1_and_1);
    test('1+1', add_2_and_4);
    test('2*3', multiply_2_by_3);
    test('1*5', multiply_1_by_5);
    test('4/2', divide_4_by_2);
    test('Multiplication', should_do_multiplication);
    test('Addition', should_do_addition);
    test('Division', should_do_divisiion);
    test('No operation', should_not_find_operator);
    test('No operation but parenth', should_not_find_operator_in_parenth);
    test('find addition', should_find_add);
    test('find multiplication', should_find_div);
    test('find division', should_find_mult);
    test('find with priority', should_find_operator_prio);
    test('find with priority', should_find_operator_prio_2);
    test('Not find add in ()', should_not_find_add_in_parenth);
    test('Not find mult in ()', should_not_find_mult_in_parenth);
    test('Not find div in ()', should_not_find_div_in_parenth);
    test('in ()', should_be_in_parenth);
    test('multi (() )', should_be_in_multi_parenth);
    test('no  ()', should_not_be_parenth);
    test('multi ()()', should_not_be_parenth_but_contains);
    //test('Big value', should_calculate_with_big_int);
    test('parse 1+1', should_parse_addition);
    test('parse 2*3', should_parse_multiplication);
    test('parse 4/2', should_parse_division);
    test('parse (2+3)*4/20', should_parse_operation_multi_operator);
    test('parse 1,5*4', should_parse_float_operation);
  });  
}

should_parse_addition(){
  // When
  var result = calculator.parse("1+1");
  
  // Then
  expect(result, equals(2)); 
  
}

should_parse_multiplication(){
  // When
  var result = calculator.parse("2*3");
  
  // Then
  expect(result, equals(6)); 
  
}

should_parse_division(){
  // When
  var result = calculator.parse("4/2");
  
  // Then
  expect(result, equals(2.0)); 
}

should_parse_operation_multi_operator(){
  // When
  var result = calculator.parse("(2+3)*4/20");
  
  // Then
  expect(result, equals(1.0)); 
}


to_num_one(){
  // When
  var result = calculator.toNum("1");
  
  // Then
  expect(result, equals(1));
}

to_num_double(){
  // When
  var result = calculator.toNum("1.5");
  
  // Then
  expect(result, equals(1.5));
}

 one_is_one_and_half(){
   // When
   var result = calculator.add(1, 1);
   
   // Then
   expect(result, equals(2));
 }


add_1_and_1(){
  // When
  var result = calculator.add(1, 1);
  
  // Then
  expect(result, equals(2));
}

add_2_and_4(){
  // When
  var result = calculator.add(2, 4);
  
  // Then
  expect(result, equals(6));
}


multiply_2_by_3(){
  // When
  var result = calculator.multiply(2, 3);
  
  // Then
  expect(result, equals(6)); 
}

multiply_1_by_5(){
  // When
  var result = calculator.multiply(1, 5);
  
  // Then
  expect(result, equals(5)); 
}

divide_4_by_2(){
  // When
  var result = calculator.divide(4, 2);
  
  // Then
  expect(result, equals(2)); 
}


should_do_multiplication(){
  // When 
  var result = calculator.doOperation(new Operation(1, 1, "*"));
  
  // Then
  expect(result, equals(1));
}

should_do_addition(){
  // When 
  var result = calculator.doOperation(new Operation(1, 1, "+"));
  
  // Then
  expect(result, equals(2));
}

should_do_divisiion(){
  // When 
  var result = calculator.doOperation(new Operation(4, 2, "/"));
  
  // Then
  expect(result, equals(2));
}

should_not_find_operator(){
  // When 
  var result = calculator.indexOfSeparationOperator("42");
  
  // Then
  expect(result, equals(-1));  
}

should_not_find_operator_in_parenth(){
  // When 
  var result = calculator.indexOfSeparationOperator("(42)");
  
  // Then
  expect(result, equals(-1));  
}

should_find_add(){
  // When 
  var result = calculator.indexOfSeparationOperator("42+2");
  
  // Then
  expect(result, equals(2));    
}

should_find_div(){
  // When 
  var result = calculator.indexOfSeparationOperator("42/2");
  
  // Then
  expect(result, equals(2));     
}

should_find_mult(){
  // When 
  var result = calculator.indexOfSeparationOperator("42*2");
  
  // Then
  expect(result, equals(2));  
}

should_find_operator_prio(){
  // When 
  var result = calculator.indexOfSeparationOperator("1+2*2");
  
  // Then
  expect(result, equals(1));  
}

should_find_operator_prio_2(){
  // When 
  var result = calculator.indexOfSeparationOperator("2*2+1");
  
  // Then
  expect(result, equals(3));  
}

should_not_find_add_in_parenth(){
  // When 
  var result = calculator.indexOfSeparationOperator("(42+2)");
  
  // Then
  expect(result, equals(-1));     
}

should_not_find_mult_in_parenth(){
  // When 
  var result = calculator.indexOfSeparationOperator("(42/2)");
  
  // Then
  expect(result, equals(-1));     
}

should_not_find_div_in_parenth(){
  // When 
  var result = calculator.indexOfSeparationOperator("(42*2)");
  
  // Then
  expect(result, equals(-1));  
}

should_be_in_parenth(){
  // When 
  var result = calculator.isInParenth("(42)");
  
  // Then
  expect(result, isTrue);    
}

should_be_in_multi_parenth(){
  // When 
  var result = calculator.isInParenth("((42+3)*2)");
  
  // Then
  expect(result, isTrue);    
}

should_not_be_parenth(){
  // When 
  var result = calculator.isInParenth("42");
  
  // Then
  expect(result, isFalse);    
}

should_not_be_parenth_but_contains(){
  // When 
  var result = calculator.isInParenth("(42 2)*(4+5)");
  
  // Then
  expect(result, isFalse);    
}

// Ignore : precision is bad
should_calculate_with_big_int(){
  // When
  var result = calculator.parse("((1.1+2)+3.14+4+(5+6+7)+(8+9+10)*4267387833344334647677634)/2*553344300034334349999000");
  // Then
  print(result.toInt());
  expect(result, equals(31878018903828899277492024491376690701584023926880));  

  //int asInt = val.toInt();
  //print("$asInt $val");
}

should_parse_float_operation(){
  // When 
  var result = calculator.parse("1.5*4");
  
  // Then
  expect(result, 6.0);     
}


