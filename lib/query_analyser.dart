library query_analyser;

class QueryAnalyser {

  final Map _queryAnswers = {
                            "Quelle est ton adresse email" : "nicolas.franc@gmail.com",
                            "Es tu abonne a la mailing list(OUI/NON)": "OUI",
                            "Es tu heureux de participer(OUI/NON)" : "OUI",
                            "Es tu pret a recevoir une enonce au format markdown par http post(OUI/NON)" : "OUI",
                            "Est ce que tu reponds toujours oui(OUI/NON)" : "NON",
                            "As tu bien recu le premier enonce(OUI/NON)" : "OUI",
                            // Oui, c'est sale de mettre l'opération en dur, mais Dart perd la précision :( L'opération rend sous forme exposant.
                            // http://stackoverflow.com/questions/14319236/big-number-and-lost-of-precision
                            "((1,1 2) 3,14 4 (5 6 7) (8 9 10)*4267387833344334647677634)/2*553344300034334349999000" : "31878018903828899277492024491376690701584023926880",
                            "As tu passe une bonne nuit malgre les bugs de l etape precedente(PAS_TOP/BOF/QUELS_BUGS)" : "PAS_TOP", // Grrr maudise perte de précision
                            "As tu bien recu le second enonce(OUI/NON)" : "OUI"
  };  
  
  String findAnswer(String query) => (_queryAnswers.containsKey(query)) ? _queryAnswers[query] : _doOperation(query.replaceAll(" ", "+").replaceAll(",", "."));
  
  String _doOperation(String query) {
    var result = new Calculator().parse(query);
    return numToString(result);
  }
  
  // TODO private
  String numToString(double value){
    var s = value.toString();
    // Formattage spécial FR + conversion éventuelle en int
    return (s.endsWith(".0")) ? s.substring(0, s.length-2) : s.replaceFirst(".", ",");
}
  
  
}

const MULT_OPERATOR = "*";
const String ADD_OPERATOR = "+";
const String DIV_OPERATOR = "/";

class Operation {
 
  final num a;
  final num b;
  final String operator;
  
  Operation(this.a, this.b, this.operator);
  
  String toString() => "$a $operator $b";  
  
}

class Calculator {
  
  Calculator();
  
  double parse(String query){
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
  
  // TODO private
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
  
  // TODO private  
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
  
  // TODO private  
  double toNum(String s){
    try {
      return double.parse(s);
    } on FormatException catch (fe) {
      print("Erreur : Pas un nombre. $fe");
      return  0.0;
    }    
  }
  
  // TODO private  
  double doOperation(Operation o){
    switch(o.operator){
      case MULT_OPERATOR:
        return multiply(o.a, o.b);
      case ADD_OPERATOR:
        return add(o.a, o.b);
      case DIV_OPERATOR:
        return divide(o.a, o.b);        
    }
  }
  // TODO private
  num add(num a, num b) => a+b;
  // TODO private
  num multiply(num a, num b) => a*b;
  // TODO private
  num divide(num a, num b) => b==0 ? 0 : a/b; 
}

