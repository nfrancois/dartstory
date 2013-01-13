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
  
  String findAnswer(String query) => (_queryAnswers.containsKey(query)) ? _queryAnswers[query] : _doOperation(query);
  
  String _doOperation(String query) => new Calculator().parse(query).toString(); 
  
}

const MULTIPLY_OPERATOR = "*";
const String ADD_OPERATOR = " ";
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
    if(query.startsWith("(") && query.endsWith(")")){
      return parse(query.substring(1, query.length-1));
    }
    var firstAddition = query.indexOf(ADD_OPERATOR);
    var firstMultiply = query.indexOf(MULTIPLY_OPERATOR);
    if(firstAddition==-1 && firstMultiply==-1){// Pas d'opération
      return toNum(query);
    }
    var firstOp;
    var operator;
    if(firstAddition < firstMultiply){
      firstOp = firstMultiply;
      operator = MULTIPLY_OPERATOR;
    } else {
      firstOp = firstAddition;
      operator = ADD_OPERATOR;
    }
    num a = parse(query.substring(0, firstOp));
    num b = parse(query.substring(firstOp+1, query.length));
    var operation = new Operation(a,b, operator);
    return doOperation(operation);    
  }
  
  num toNum(String s){
    try {
      return int.parse(s);
    } on FormatException catch (fe) {
      print("Erreur. Pas un entier. $fe");
      return  0;
    }    
  }
  
  num doOperation(Operation o){
    switch(o.operator){
      case MULTIPLY_OPERATOR:
        return multiply(o.a, o.b);
      case ADD_OPERATOR:
        return add(o.a, o.b);
    }
  }
  
  num add(num a, num b) => a+b;
  
  num multiply(num a, num b) => a*b;
  
}

