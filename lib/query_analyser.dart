library query_analyser;

const MULTIPLY_OPERATOR = "*";
const ADD_OPERATOR = " ";

class QueryAnalyser {

  const _UNKNOWN_QUERY = "Unknown query";
  final Operation _operation;
  
  QueryAnalyser() : _operation = new Operation();
  
  final Map _queryAnswers = {
                            "Quelle est ton adresse email" : "nicolas.franc@gmail.com",
                            "Es tu abonne a la mailing list(OUI/NON)": "OUI",
                            "Es tu heureux de participer(OUI/NON)" : "OUI",
                            "Es tu pret a recevoir une enonce au format markdown par http post(OUI/NON)" : "OUI",
                            "Est ce que tu reponds toujours oui(OUI/NON)" : "NON",
                            "As tu bien recu le premier enonce(OUI/NON)" : "OUI"
  };  
  
  String findAnswer(String query) => (_queryAnswers.containsKey(query)) ? _queryAnswers[query] : _doOperation(query);
  
  String _doOperation(String query){
    num result = 0;
    String operator;
    var values;
    if(query.contains(MULTIPLY_OPERATOR)){
      operator = MULTIPLY_OPERATOR;
    } else if (query.contains(ADD_OPERATOR)){
      operator = ADD_OPERATOR;
    } else {
      return _UNKNOWN_QUERY;
    }
    values = query.split(operator);
    try {
        result = _operation.doOperation(int.parse(values[0]), operator, int.parse(values[1]));
    } on FormatException catch (fe) {
      print("Erreur. Pas un entier. $fe");
      return  _UNKNOWN_QUERY;
    }      
    return result.toString(); 
  }
  
}

class Operation {
  
  // TODO à tester
  num doOperation(num a, String op, num b){
    switch(op){
      case MULTIPLY_OPERATOR:
        return multiply(a,b);
      case ADD_OPERATOR:
        return add(a,b);
    }
  }
  
  num add(num a, num b) => a+b;
  
  num multiply(num a, num b) => a*b;
  
}

