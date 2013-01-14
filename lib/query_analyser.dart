library query_analyser;

class QueryAnalyser {

  final Map _queryAnswers = {
                            "Quelle est ton adresse email" : "nicolas.franc@gmail.com",
                            "Es tu abonne a la mailing list(OUI/NON)": "OUI",
                            "Es tu heureux de participer(OUI/NON)" : "OUI",
                            "Es tu pret a recevoir une enonce au format markdown par http post(OUI/NON)" : "OUI",
                            "Est ce que tu reponds toujours oui(OUI/NON)" : "NON",
                            "As tu bien recu le premier enonce(OUI/NON)" : "OUI"
  };  
  
  String findAnswer(String query) => (_queryAnswers.containsKey(query)) ? _queryAnswers[query] : _doOperation(query.replaceAll(" ", "+"));
  
  String _doOperation(String query) {
    var result = new Calculator().parse(query);
    return numToString(result);
  }
  
  String numToString(num value){
    var s = value.toString();
    if(s.contains("e+")){
      s = value.toInt().toString();
    } else if(!(num is int)){
      //if(num is double){ // Fail WTF ???
      s = (s.endsWith(".0")) ? s.substring(0, s.length-2) : s.replaceFirst(".", ",");
    }
    return s;
}
  
  
}

const MULT_OPERATOR = "*";
const String ADD_OPERATOR = "+";
const String DIV_OPERATOR = "/";
const _UNKNOWN_QUERY = "Unknown query";

class Operation {
 
  final num a;
  final num b;
  final String operator;
  
  Operation(this.a, this.b, this.operator);
  
  
}

class Calculator {
  
  Calculator();
  
  num parse(String query){
    if(isInParenth(query)){
      return parse(query.substring(1, query.length-1));
    }
    var operatorIndex = indexOfSeparationOperator(query);
    if(operatorIndex == -1){
      return toNum(query);
    }
    var operator = query[operatorIndex];
    num a = parse(query.substring(0, operatorIndex));
    num b = parse(query.substring(operatorIndex+1, query.length));
    var operation = new Operation(a,b, operator);
    return doOperation(operation);    
  }
  
  int indexOfSeparationOperator(String query){
    var parentLevel = 0;
    var bestOp = -1;
    for(int i=0; i<query.length; i++){
      var char = query[i];
      if(char == "("){
        parentLevel++;
      } else if(char == ")"){
        parentLevel--;
      } else if(parentLevel == 0){
        if(char == ADD_OPERATOR){
          return i;
        } else if(char == MULT_OPERATOR || char == DIV_OPERATOR){
          bestOp = i;
        }
      }
    }
    return bestOp;    
  }
  
  bool isInParenth(String query){
    bool startAndStopInParenth = query[0] == "(" && query[query.length-1] == ")";
    if(!startAndStopInParenth){
      return false;
    }
    var parentLevel = 0;
    for(int i=0; i<query.length; i++){
      var char = query[i];
      if(char == "("){
        parentLevel++;
      } else if(char == ")"){
        parentLevel--;
      }
      if(parentLevel == 0){
        return i == query.length-1;
      }
    }
    return true;
  }
  
  num toNum(String s){
    num value = 0;
    try {
      if(s.contains(",")){
        value = double.parse(s.replaceAll(",", "."));
      } else {
        value = int.parse(s);
      }
    } on FormatException catch (fe) {
      print("Erreur. Pas un entier. $fe");
    }    
    return  value;
  }
  
  num doOperation(Operation o){
    switch(o.operator){
      case MULT_OPERATOR:
        return multiply(o.a, o.b);
      case ADD_OPERATOR:
        return add(o.a, o.b);
      case DIV_OPERATOR:
        return divide(o.a, o.b);        
    }
  }
  
  num add(num a, num b) => a+b;
  
  num multiply(num a, num b) => a*b;

  num divide(num a, num b) => b==0 ? 0 : a/b; 
}

