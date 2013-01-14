library javascript_test;

import "package:unittest/unittest.dart";
import "../lib/jajascript.dart";

JajaOptimizer _optimizer;

main(){
  group('Jajascript Tests', (){
    setUp(() => _optimizer = new JajaOptimizer());
    test("Render to JSon a result", should_convert_optimization_to_json);
    test("Parse simple command", should_parse_simple_command);
    test('When 1 element, easy solution', should_have_one_solution);
    
 });
}

should_convert_optimization_to_json(){
  // Given
  var optimization =  new JajaOptimization(10, ["AF514"]);
  
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

should_have_one_solution(){
  // Given
  var command = new JajaCommand("AF514", 0, 5, 10);

  // When
  var optim = _optimizer.optimize([command]);
  
  // Then
  expect(optim, isNotNull);
  expect(optim.gain, 10);
  expect(optim.path, equals(["AF514"]));
}
