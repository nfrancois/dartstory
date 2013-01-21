library jajascript;

import 'dart:json';

class JajaCommand {
  final String vol;
  final int depart;
  final int duree;
  final int prix;
  
  final List<JajaCommand> _next = [];
  
  bool hasPrevious = false;
  //bool hasAfter = false;
  
  JajaCommand(this.vol, this.depart, this.duree, this.prix);
  
  String toString() => "vol=$vol depart=$depart duree=$duree prix=$prix";
  
  static List<JajaCommand> parseFromJson(String jsonCommand){
    var objectsMap = JSON.parse(jsonCommand);
    var queue = objectsMap.map((o) => new JajaCommand(o["VOL"], o["DEPART"], o["DUREE"], o["PRIX"]));
    return new List.from(queue);
  }
  
  bool inSamePath(JajaCommand other) => depart+duree<=other.depart;
  
  bool operator ==(JajaCommand o) => o.vol == vol && o.depart == depart && o.duree == duree && o.prix == prix;
  
  // Override hashCode using strategy from Effective Java, Chapter 11.
  int get hashCode {
    int result = 17;
    result = 37 * result + vol.hashCode;
    result = 37 * result + depart.hashCode;
    result = 37 * result + duree.hashCode;
    result = 37 * result + prix.hashCode;
    return result;
  }  
 
}

class JajaOptimization {
  final int gain;
  final Queue<String> path;// TODO list
  
  JajaOptimization.empty() : gain = 0, path = new DoubleLinkedQueue();
  
  JajaOptimization.fusion(JajaCommand command, JajaOptimization optim) : gain = command.prix + optim.gain, path = new Queue.from(optim.path){
    path.addFirst(command.vol);
  }
  
  JajaOptimization(this.gain, this.path);
  
  String toString() => "gain=$gain path=$path";
  
  String toJson() => JSON.stringify({"gain":gain, "path": new List.from(path)});
  
}

class JajaOptimizer {
  
  final List<JajaCommand> commands;
  final List<JajaCommand> _allPaths = [];
  //final Map<JajaCommand, List<JajaCommand>> _nexts;
  //final Map<JajaCommand, List<JajaCommand>> _previous;
  final Map<String, JajaOptimization> _optimCache = {};
  
  JajaOptimizer(this.commands);
  //: _nexts =  new Map<JajaCommand, List<JajaCommand>>(), _previous =  new Map<JajaCommand, List<JajaCommand>>();
  
  JajaOptimization optimize(){
    return _algov1();
  }
  
  JajaOptimization _algov2(){
    /*
    commands.sort((a, b) {// Ordonné par heure puis durée
      int departDiff = a.depart - b.depart;
      return departDiff == 0 ? a.duree - b.duree : departDiff;
    });
    */
    
    print("Algo v2");
    commands.sort((a, b) => a.depart - b.depart);
    var bestOptim = new JajaOptimization.empty();
    var lenght = commands.length;    
    for(int i=0; i<lenght; i++){
      JajaCommand current = commands[i];
      // ???
      for(int j=i+1; j<lenght; j++){
        var nextCommand = commands[j];
        if(current.inSamePath(nextCommand)){
          
        }
        
      }     
    }
    return bestOptim;
  }
  
  JajaOptimization _algov1(){
    print("Algo v1");
    _findAllPath();
    return _findBestFromPath();   
  }
  
  
  _findAllPath(){// FIXME problème mémoire quand 10 000 commmandes!!!
    print("Find paths");
    commands.sort((a, b) => a.depart - b.depart);
    /*
    commands.sort((a, b) {// Ordonné par heure puis durée
      int departDiff = a.depart - b.depart;
      return departDiff == 0 ? a.duree - b.duree : departDiff;
    });
    */
    // Trouver tous les chemins possibles
    var lenght = commands.length;
    for(int i=0; i<lenght; i++){
      JajaCommand current = commands[i];
      if(!current.hasPrevious){// Le chemin n'est pas encore exploré
        _allPaths.add(current);
      }
      var buzyMin = 999999;// TODO trouver un meilleur nom de variable
      var findNext = false;
      for(int j=i+1; j<lenght; j++){
        var next = commands[j];
        if(!current.inSamePath(next)){
          continue;// Incompatible, on passe au suivant
        }
        // Test optim ---- debut
        if(findNext && next.depart >= buzyMin ){
          break; // On a le temps de faire un voyage => arret de la recherche des suivants
        }
        //print("Next from ${current.vol} => ${next.vol}");
        // On fait gaffe à pas aller trop loin en terme de suivant
        var nextComebackMin = next.depart+next.duree;
        if(nextComebackMin < buzyMin){
          buzyMin = nextComebackMin;
        }
        // Test optim ---- fin
        findNext = true;
        next.hasPrevious = true;
        current._next.add(next);
      }
    }  
    print("All paths=${_allPaths.length}");
  }
  
  JajaOptimization _findBestFromPath(){
    print("Find best path}");
    JajaOptimization bestOptim = new JajaOptimization.empty();
    _allPaths.forEach((start) {
      var currentOptim = new JajaOptimization.empty();
      var bestOptimFromCurrent = _findBest(start);
      if(bestOptimFromCurrent.gain>bestOptim.gain){
        bestOptim = bestOptimFromCurrent;
      }
    });
    return bestOptim;   
  }
  
  JajaOptimization _findBest(JajaCommand toExplore){
    if(_optimCache.containsKey(toExplore.vol)){
      return _optimCache[toExplore.vol];
    }
    var toExploreNexts = toExplore._next;
    if(toExploreNexts.isEmpty){// Destination finale
      var optim = new JajaOptimization(toExplore.prix, new Queue.from([toExplore.vol]));
      _optimCache[toExplore.vol] = optim;
      return optim;
    } else {// Recherche de la meilleure optim pour le noeud
      var bestNextOptim =  new JajaOptimization.empty();
      toExploreNexts.forEach((nextCommand) {
        var actualNextOptim =_findBest(nextCommand);
        if(actualNextOptim.gain>bestNextOptim.gain){
          bestNextOptim = actualNextOptim;
        }
      });
      var optim = new JajaOptimization.fusion(toExplore, bestNextOptim);
      _optimCache[toExplore.vol] = optim;      
      return optim;
    }
  }
  
  
}