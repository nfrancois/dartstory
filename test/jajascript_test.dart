library javascript_test;

import "package:unittest/unittest.dart";
import "../lib/jajascript.dart";

main(){
  group('Jajascript Tests', (){
    test('Pas de conflits entre 2 JavaCommand', should_no_have_conflict_consecutif);
    test('Pas de conflits entre 2 JavaCommand', should_no_have_conflict_distant);
    test('Conflits entre 2 JavaCommand', should_have_conflict_same_depart);
    test('Conflits entre 2 JavaCommand', should_have_conflict_too_long_fligh);    
    test("Render to JSon a result", should_convert_optimization_to_json);
    test("Parse simple command", should_parse_simple_command);
    test('When 1 element, easy solution', should_have_one_solution);
    test('2 vols consecutif', should_chain_fly);
    test('2 vols avec conflits', should_choice_better_fly_in_2);
    test('2 vols avec conflits', should_accept_2_of_3);
    test("Question de l'énoncé", enonce_sample);
    test('3 vols ', should_accept_all_3);
 });
}

should_convert_optimization_to_json(){
  // Given
  var optimization =  new JajaOptimization(10, new Queue.from(["AF514"]));
  
  // When
  var json = optimization.toJson();
  
  // Then
  expect(json, '{"gain":10,"path":["AF514"]}');
  
}

should_parse_simple_command(){
  // Given
  var jsonCommand =  '[{"VOL": "AF514", "DEPART":0, "DUREE":5, "PRIX": 10}]';

  // When
  var command = JajaCommand.parseFromJson(jsonCommand);
  
  // Then
  expect(command, isNotNull);
  expect(command.length, 1);
  var first = command[0];
  expect(first.vol, "AF514");
  expect(first.depart, 0);
  expect(first.duree, 5);
  expect(first.prix, 10);
}


should_no_have_conflict_consecutif(){
  // Given
  var first = new JajaCommand("AF1", 0, 1, 5);
  var second = new JajaCommand("AF2", 1, 1, 5);
  
  // When
  var r1 = first.inSamePath(second);
  var r2 = second.inSamePath(first);
  
  // Then
  expect(r1, isTrue);
  expect(r2, isFalse);  
}

should_no_have_conflict_distant(){
  // Given
  var first = new JajaCommand("AF1", 0, 1, 2);
  var second = new JajaCommand("AF2", 4, 1, 5);
  
  // When
  var r1 = first.inSamePath(second);
  var r2 = second.inSamePath(first);
  
  // Then
  expect(r1, isTrue);
  expect(r2, isFalse);  
}

should_have_conflict_same_depart(){
  // Given
  var first = new JajaCommand("AF1", 0, 2, 5);
  var second = new JajaCommand("AF2", 0, 1, 5);
  
  // When
  var r1 = first.inSamePath(second);
  var r2 = second.inSamePath(first);
  
  // Then
  expect(r1, isFalse);
  expect(r2, isFalse);   
}

should_have_conflict_too_long_fligh(){
  // Given
  var first = new JajaCommand("AF1", 0, 3, 5);
  var second = new JajaCommand("AF2", 1, 1, 5);
  
  // When
  var r1 = first.inSamePath(second);
  var r2 = second.inSamePath(first);
  
  // Then
  expect(r1, isFalse);
  expect(r2, isFalse);  
}

should_have_one_solution(){
  // Given
  var command = new JajaCommand("AF514", 0, 5, 10);

  // When
  var optim = new JajaOptimizer([command]).optimize();
  
  // Then
  expect(optim, isNotNull);
  expect(optim.gain, 10);
  expect(optim.path, equals(["AF514"]));
}

should_chain_fly(){
  // Given
  var command = [new JajaCommand("AF1", 0, 1, 10), new JajaCommand("AF2", 1, 1, 10)]; 

  // When
  var optim = new JajaOptimizer(command).optimize();
  
  // Then
  expect(optim, isNotNull);
  expect(optim.gain, 20);
  expect(optim.path, equals(["AF1", "AF2"]));
}

should_choice_better_fly_in_2(){
  // Given
  var command = [new JajaCommand("AF1", 0, 1, 6), new JajaCommand("AF2", 0, 1, 5)]; 

  // When
  var optim = new JajaOptimizer(command).optimize();
  
  // Then
  expect(optim, isNotNull);
  expect(optim.gain, 6);
  expect(optim.path, equals(["AF1"])); 
}

should_accept_all_3(){
  // Given
  var command = [new JajaCommand("AF1", 0, 1, 2),  new JajaCommand("AF3", 4, 1, 6), new JajaCommand("AF2", 2, 1, 4),]; 

  // When
  var optim = new JajaOptimizer(command).optimize();
  
  // Then
  expect(optim, isNotNull);
  expect(optim.gain, 12);
  expect(optim.path, equals(["AF1", "AF2", "AF3"]));   
}

//  {"VOL": "AF1", "DEPART":0, "DUREE":1, "PRIX": 4},
//  {"VOL": "AF2", "DEPART":0, "DUREE":1, "PRIX": 2},
//  {"VOL": "AF3", "DEPART":2, "DUREE":1, "PRIX": 6}

should_accept_2_of_3(){
  // Given
  var command = [new JajaCommand("AF1", 0, 1, 2),  new JajaCommand("AF2", 0, 1, 2), new JajaCommand("AF3", 2, 1, 6)]; 

  // When
  var optim = new JajaOptimizer(command).optimize();
  
  // Then
  expect(optim, isNotNull);
  expect(optim.gain, 8);
  expect(optim.path, equals(["AF1", "AF3"]));   
}


enonce_sample(){
  // Given
  var command = [new JajaCommand("MONAD42", 0, 5, 10), new JajaCommand("META18", 3, 7, 14), new JajaCommand("LEGACY01", 5, 9, 8), new JajaCommand("YAGNI17", 5, 9, 7)]; 

  // When
  var optim = new JajaOptimizer(command).optimize();
  
  // Then
  print(optim);
  expect(optim, isNotNull);
  expect(optim.gain, 18);
  expect(optim.path, equals(["MONAD42","LEGACY01"])); 
}