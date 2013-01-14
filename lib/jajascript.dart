library jajascript;

import 'dart:json';

class JajaCommand {
  final String vol;
  final int depart;
  final int duree;
  final int prix;
  
  JajaCommand(this.vol, this.depart, this.duree, this.prix);
  
  String toString() => "vol=$vol depart=$depart duree=$duree prix=$prix";
  
  static List<JajaCommand> parseFromJson(String jsonCommand){
    var objectsMap = JSON.parse(jsonCommand);
    var queue = objectsMap.map((o) => new JajaCommand(o["VOL"], o["DEPART"], o["DUREE"], o["PRIX"]));
    return new List.from(queue);
  }
 
}

class JajaOptimization {
  final int gain;
  final List<String> path;
  
  JajaOptimization(this.gain, this.path);
  
  String toString() => "gain=$gain path=$path";
  
  String toJson() => JSON.stringify({"gain":gain, "path":path});
}

class JajaOptimizer {
  
  JajaOptimization optimize(List<JajaCommand> commands){
    return new JajaOptimization(commands[0].prix, [commands[0].vol]);
  }
  
}
