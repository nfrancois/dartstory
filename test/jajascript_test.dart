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
    test("Question de l'énoncé", enonce_sample);
    test('3 vols ', should_accept_all_3);
    test('2 vols avec conflits', should_accept_2_of_3);
    test('Une grosse requete venant de mes logs heroku', request_15);
    test('Enchevrés', multi_conflits);
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
  var command = [new JajaCommand("AF1", 0, 1, 4),  new JajaCommand("AF2", 0, 1, 2), new JajaCommand("AF3", 2, 1, 6)]; 

  // When
  var optim = new JajaOptimizer(command).optimize();
  
  // Then
  expect(optim, isNotNull);
  expect(optim.gain, 10);
  expect(optim.path, equals(["AF1", "AF3"]));   
}


enonce_sample(){
  // Given
  var command = [new JajaCommand("MONAD42", 0, 5, 10), new JajaCommand("META18", 3, 7, 14), new JajaCommand("LEGACY01", 5, 9, 8), new JajaCommand("YAGNI17", 5, 9, 7)]; 

  // When
  var optim = new JajaOptimizer(command).optimize();
  
  // Then
  expect(optim, isNotNull);
  expect(optim.gain, 18);
  expect(optim.path, equals(["MONAD42","LEGACY01"])); 
}

request_15(){
  // Given
	var json = '[ { "VOL": "gigantic-yardage-94", "DEPART": 0, "DUREE": 4, "PRIX": 12 }, { "VOL": "hilarious-venus-15", "DEPART": 1, "DUREE": 2, "PRIX": 2 }, { "VOL": "puny-reforestation-66", "DEPART": 2, "DUREE": 6, "PRIX": 6 }, { "VOL": "sleepy-map-91", "DEPART": 4, "DUREE": 5, "PRIX": 8 }, { "VOL": "wicked-pinkeye-49", "DEPART": 5, "DUREE": 2, "PRIX": 7 }, { "VOL": "cooperative-gymnasium-66", "DEPART": 5, "DUREE": 4, "PRIX": 7 }, { "VOL": "high-pitched-publisher-18", "DEPART": 6, "DUREE": 2, "PRIX": 6 }, { "VOL": "mute-sinker-5", "DEPART": 7, "DUREE": 6, "PRIX": 4 }, { "VOL": "upset-saxophonist-98", "DEPART": 9, "DUREE": 5, "PRIX": 21 }, { "VOL": "wicked-risk-3", "DEPART": 10, "DUREE": 2, "PRIX": 1 }, { "VOL": "envious-pigeon-54", "DEPART": 10, "DUREE": 4, "PRIX": 8 }, { "VOL": "high-pitched-speaker-3", "DEPART": 11, "DUREE": 2, "PRIX": 1 }, { "VOL": "sleepy-underclassman-46", "DEPART": 12, "DUREE": 6, "PRIX": 6 }, { "VOL": "innocent-volt-76", "DEPART": 14, "DUREE": 5, "PRIX": 19 }, { "VOL": "repulsive-radiologist-13", "DEPART": 15, "DUREE": 2, "PRIX": 9 }, { "VOL": "friendly-podiatrist-27", "DEPART": 15, "DUREE": 4, "PRIX": 15 }, { "VOL": "beautiful-thermodynamics-77", "DEPART": 16, "DUREE": 2, "PRIX": 8 }, { "VOL": "attractive-quartet-20", "DEPART": 17, "DUREE": 6, "PRIX": 2 }, { "VOL": "angry-lecturer-11", "DEPART": 19, "DUREE": 5, "PRIX": 6 }, { "VOL": "worried-resistance-62", "DEPART": 20, "DUREE": 2, "PRIX": 18 }, { "VOL": "disturbed-oarsman-20", "DEPART": 20, "DUREE": 4, "PRIX": 7 }, { "VOL": "skinny-tweed-99", "DEPART": 21, "DUREE": 2, "PRIX": 3 }, { "VOL": "chubby-wisdom-62", "DEPART": 22, "DUREE": 6, "PRIX": 3 }, { "VOL": "dull-wedding-42", "DEPART": 24, "DUREE": 5, "PRIX": 6 }, { "VOL": "frantic-stutterer-95", "DEPART": 25, "DUREE": 2, "PRIX": 21 }, { "VOL": "bewildered-upstairs-70", "DEPART": 25, "DUREE": 4, "PRIX": 10 }, { "VOL": "grotesque-catapult-82", "DEPART": 26, "DUREE": 2, "PRIX": 10 }, { "VOL": "ashamed-wildebeest-14", "DEPART": 27, "DUREE": 6, "PRIX": 4 }, { "VOL": "hushed-signpost-73", "DEPART": 29, "DUREE": 5, "PRIX": 19 }, { "VOL": "enchanting-ape-8", "DEPART": 30, "DUREE": 2, "PRIX": 24 }, { "VOL": "eager-geyser-16", "DEPART": 30, "DUREE": 4, "PRIX": 11 }, { "VOL": "fast-spout-4", "DEPART": 31, "DUREE": 2, "PRIX": 7 }, { "VOL": "funny-symmetry-17", "DEPART": 32, "DUREE": 6, "PRIX": 5 }, { "VOL": "busy-moose-22", "DEPART": 34, "DUREE": 5, "PRIX": 23 }, { "VOL": "late-larynx-20", "DEPART": 35, "DUREE": 2, "PRIX": 5 }, { "VOL": "tiny-pinball-36", "DEPART": 35, "DUREE": 4, "PRIX": 9 }, { "VOL": "helpless-accelerator-34", "DEPART": 36, "DUREE": 2, "PRIX": 9 }, { "VOL": "homely-scallop-60", "DEPART": 37, "DUREE": 6, "PRIX": 5 }, { "VOL": "great-driver-77", "DEPART": 39, "DUREE": 5, "PRIX": 12 }, { "VOL": "weary-violinist-38", "DEPART": 40, "DUREE": 2, "PRIX": 23 }, { "VOL": "quaint-treadmill-74", "DEPART": 40, "DUREE": 4, "PRIX": 12 }, { "VOL": "concerned-brow-85", "DEPART": 41, "DUREE": 2, "PRIX": 9 }, { "VOL": "comfortable-greenery-75", "DEPART": 42, "DUREE": 6, "PRIX": 3 }, { "VOL": "clear-spouse-40", "DEPART": 44, "DUREE": 5, "PRIX": 18 }, { "VOL": "calm-quake-98", "DEPART": 45, "DUREE": 2, "PRIX": 18 }, { "VOL": "aggressive-skirt-96", "DEPART": 45, "DUREE": 4, "PRIX": 7 }, { "VOL": "frail-muffin-60", "DEPART": 46, "DUREE": 2, "PRIX": 3 }, { "VOL": "large-sandblaster-74", "DEPART": 47, "DUREE": 6, "PRIX": 6 }, { "VOL": "smoggy-lava-39", "DEPART": 49, "DUREE": 5, "PRIX": 15 }, { "VOL": "silly-kneecap-20", "DEPART": 50, "DUREE": 2, "PRIX": 22 }, { "VOL": "round-smokehouse-66", "DEPART": 50, "DUREE": 4, "PRIX": 11 }, { "VOL": "breakable-firehouse-71", "DEPART": 51, "DUREE": 2, "PRIX": 1 }, { "VOL": "short-penicillin-9", "DEPART": 52, "DUREE": 6, "PRIX": 6 }, { "VOL": "sparkling-technology-16", "DEPART": 54, "DUREE": 5, "PRIX": 18 }, { "VOL": "tiny-roadrunner-58", "DEPART": 55, "DUREE": 2, "PRIX": 22 }, { "VOL": "misty-rage-51", "DEPART": 55, "DUREE": 4, "PRIX": 7 }, { "VOL": "gifted-footwear-23", "DEPART": 56, "DUREE": 2, "PRIX": 5 }, { "VOL": "dizzy-toilet-61", "DEPART": 57, "DUREE": 6, "PRIX": 1 }, { "VOL": "bloody-pecan-43", "DEPART": 59, "DUREE": 5, "PRIX": 19 }, { "VOL": "beautiful-genius-38", "DEPART": 60, "DUREE": 2, "PRIX": 1 }, { "VOL": "blue-shrewdness-81", "DEPART": 60, "DUREE": 4, "PRIX": 13 }, { "VOL": "wicked-numismatist-13", "DEPART": 61, "DUREE": 2, "PRIX": 10 }, { "VOL": "blue-mafioso-82", "DEPART": 62, "DUREE": 6, "PRIX": 2 }, { "VOL": "disturbed-turquoise-42", "DEPART": 64, "DUREE": 5, "PRIX": 12 }, { "VOL": "ugliest-posy-20", "DEPART": 65, "DUREE": 2, "PRIX": 12 }, { "VOL": "loud-hotel-53", "DEPART": 65, "DUREE": 4, "PRIX": 8 }, { "VOL": "average-caviar-13", "DEPART": 66, "DUREE": 2, "PRIX": 10 }, { "VOL": "time-haircut-9", "DEPART": 67, "DUREE": 6, "PRIX": 7 }, { "VOL": "testy-trefoil-49", "DEPART": 69, "DUREE": 5, "PRIX": 23 }, { "VOL": "magnificent-milk-79", "DEPART": 70, "DUREE": 2, "PRIX": 6 }, { "VOL": "elated-sister-82", "DEPART": 70, "DUREE": 4, "PRIX": 8 }, { "VOL": "charming-tile-96", "DEPART": 71, "DUREE": 2, "PRIX": 7 }, { "VOL": "curious-swordplay-44", "DEPART": 72, "DUREE": 6, "PRIX": 7 }, { "VOL": "foolish-yardage-8", "DEPART": 74, "DUREE": 5, "PRIX": 19 }, { "VOL": "shy-gravel-30", "DEPART": 75, "DUREE": 2, "PRIX": 15 } ]';
  var commmands = JajaCommand.parseFromJson(json);
 
  // When
  var optim = new JajaOptimizer(commmands).optimize();
  
  // Then
  expect(optim, isNotNull);
  expect(optim.gain, 304); 
  expect(optim.path, equals(["gigantic-yardage-94","sleepy-map-91","upset-saxophonist-98","innocent-volt-76","worried-resistance-62","frantic-stutterer-95","enchanting-ape-8","busy-moose-22","weary-violinist-38","clear-spouse-40","silly-kneecap-20","tiny-roadrunner-58","bloody-pecan-43","disturbed-turquoise-42","testy-trefoil-49","foolish-yardage-8"]));
  optim.toJson();
  
}


multi_conflits(){
  // Given
  var command = [new JajaCommand("MONAD42", 0, 1, 10), new JajaCommand("META18", 1, 3, 10), new JajaCommand("LEGACY01", 2, 5, 1), new JajaCommand("YAGNI17", 4, 6, 10)]; 

  // When
  var optim = new JajaOptimizer(command).optimize();
  
  // Then
  expect(optim, isNotNull);
  expect(optim.gain, 30);
  expect(optim.path, equals(["MONAD42","META18", "YAGNI17"])); 
}