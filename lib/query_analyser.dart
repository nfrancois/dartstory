library query_analyser;

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
    if(query.contains("*")){
      var values = query.split("*");
      try {
        num result = _operation.multiply(int.parse(values[0]), int.parse(values[1]));
        return result.toString();
      } on FormatException catch (fe) {
        print("Erreur. Pas un entier. $fe");
        return  _UNKNOWN_QUERY;
      }      
    } else {
      var values = query.split(" ");
      try {
        num result = _operation.add(int.parse(values[0]), int.parse(values[1]));
        return result.toString();
      } on FormatException catch (fe) {
        print("Erreur. Pas un entier. $fe");
        return  _UNKNOWN_QUERY;
      }
    }
  }
  
}

class Operation {
  
  num doOperation(num a, String op, num b){
    switch(op){
      case "*":
        return multiply(a,b);
      case "+":
        return add(a,b);
    }
  }
  
  num add(num a, num b) => a+b;
  
  num multiply(num a, num b) => a*b;
  
}

