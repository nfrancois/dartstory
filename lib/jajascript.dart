library jajascript;

import 'dart:json';

class JajaCommand {
  final String vol;
  final int depart;
  final int duree;
  final int prix;
  
  bool hasPrevious = false;
  
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
  
  JajaOptimization(this.gain, this.path);
  
  String toString() => "gain=$gain path=$path";
  
  String toJson() => JSON.stringify({"gain":gain, "path": new List.from(path)});
  
}

class JajaOptimizer {
  
  final List<JajaCommand> commands;
  final List<JajaCommand> _allPaths = [];
  final Map<JajaCommand, List<JajaCommand>> _nexts;
  final Map<String, JajaOptimization> _optimCache = {};
  
  JajaOptimizer(this.commands): _nexts =  new Map<JajaCommand, List<JajaCommand>>();
  
  JajaOptimization optimize(){
    _findAllPath();
    // Trouver les meilleurs
    return _findBestFromPath();
  }
  
  void _findAllPath(){
    // TODO idée générer moins de paths
    // Ex : AF1 -> AF2 -> AF3
    //      AF1 -> AF3 <=== Ne pas générer
    // D'abord un tri par heure de départ
    // TODO Constuire arbre depuis racines ?
    commands.sort((a, b) => a.depart - b.depart);
    // Trouver tous les chemins possibles
    var lenght = commands.length;
    for(int i=0; i<lenght; i++){
      JajaCommand current = commands[i];
      _nexts[current] = [];
      if(!current.hasPrevious){// Le chemin n'est pas encore exploré
        _allPaths.add(current);
      }
      for(int j=i+1; j<commands.length; j++){
        var maybeNext = commands[j];
        if(current.inSamePath(maybeNext)){
          _nexts[current].add(maybeNext);
          maybeNext.hasPrevious = true;
        }
      }
    }    
  }
  
  JajaOptimization _findBestFromPath(){
    JajaOptimization bestOptim = new JajaOptimization.empty();
    var bestGain = 0;
    _allPaths.forEach((start) {
      //var start = command;
      var currentGain = start.prix;
      //print(">Depart=${start.vol} | suivants=${next[start]}");
      var currentOptim = new JajaOptimization.empty();
      //var currentOptim = new JajaOptimization(start.prix, []);
      var bestOptimFromCurrent = _findBest(start);
      if(bestOptimFromCurrent.gain>bestGain){
        bestOptim = bestOptimFromCurrent;
        bestGain = bestOptim.gain;
      }
      // TODO ajouter le début + gain racine
      //print(">>>>>optim = $bestOptimFromCurrent");
    });
    return bestOptim;   
  }
  
  JajaOptimization _findBest(JajaCommand toExplore){
    //print("**Explore=${toExplore.vol}");
    if(_optimCache.containsKey(toExplore.vol)){
      //print("${toExplore.vol} from cache ==> ${_optimCache[toExplore.vol]}");
      return _optimCache[toExplore.vol];
    }
    var toExploreNexts = _nexts[toExplore];
    // print("**toExploreNexts=$toExploreNexts");
    if(toExploreNexts.isEmpty){// Destination finale
      //print("Fin de chemin ${toExplore.prix}");
      var optim = new JajaOptimization(toExplore.prix, new Queue.from([toExplore.vol]));
      //print("${toExplore.vol} in cache ==> $optim");
      _optimCache[toExplore.vol] = optim;
      return optim;
    } else {
      var bestNextGain = 0;
      var bestNextOptim =  new JajaOptimization.empty();
      // TODO un find ?
      toExploreNexts.forEach((nextCommand) {
        var actualNextOptim =_findBest(nextCommand);
        //print("--->Explore=${toExplore.vol} actual=${actualNextOptim.gain} best=$bestNextGain");
        if(actualNextOptim.gain>bestNextGain){
          bestNextOptim = actualNextOptim;
          bestNextGain = actualNextOptim.gain;
        }
      });
      //print("**********bestNextOptim = $bestNextOptim");
      var newGain = bestNextOptim.gain + toExplore.prix;
      var newPath = new Queue.from(bestNextOptim.path);
      newPath.addFirst(toExplore.vol);
      var optim = new JajaOptimization(newGain, newPath);
      //print("${toExplore.vol} in cache ==> $optim");
      _optimCache[toExplore.vol] = optim;      
      return optim;
    }
  }
  
  
}