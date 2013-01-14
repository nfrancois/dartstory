library scalaskel;

import 'dart:json';

class Money {
  final int foo;
  final int bar;
  final int qix;
  final int baz;
  
  Money(this.foo, this.bar, this.qix, this.baz);
  
  String toJson(){
    var object = new Map();
    _addToMapIfNotZero(object, "foo", foo);
    _addToMapIfNotZero(object, "bar", bar);
    _addToMapIfNotZero(object, "qix", qix);
    _addToMapIfNotZero(object, "baz", baz);
    return JSON.stringify(object);
  }
  
  _addToMapIfNotZero(Map map, String key, int value){
    if(value>0){
      map[key] = value;
    } 
    
  }

  String toString() => "foo=$foo bar=$bar qix=$qix baz=$baz";
  
  bool operator ==(Money m) => m.foo == foo && m.bar == bar && m.qix == qix && m.baz == baz;
  
  // Override hashCode using strategy from Effective Java, Chapter 11.
  int get hashCode {
    int result = 17;
    result = 37 * result + foo.hashCode;
    result = 37 * result + bar.hashCode;
    result = 37 * result + qix.hashCode;
    result = 37 * result + baz.hashCode;
    return result;
  }
}

class MoneyChanger {
  
  const FOO_VALUE = 1;
  const BAR_VALUE = 7;
  const QIX_VALUE = 11;
  const BAZ_VALUE = 21;
  
  // TODO recursive ?
  List<Money> change(int value){
    var results = new List<Money>();
    var bazMax = value ~/ BAZ_VALUE;
    for(int iBazMax=0; iBazMax<=bazMax; iBazMax++){
      var bazNb = iBazMax;
      var qixMax = (value - bazNb*BAZ_VALUE) ~/ QIX_VALUE;
      for(int iQixMax=0; iQixMax<=qixMax; iQixMax++){
        var qixNb = iQixMax;
        var barMax = (value  - bazNb*BAZ_VALUE - qixNb*QIX_VALUE) ~/ BAR_VALUE;
        for(int iBarMax=0; iBarMax<=barMax; iBarMax++){
          var barNb = iBarMax; 
          var fooNb = value - bazNb*BAZ_VALUE - qixNb*QIX_VALUE - barNb*BAR_VALUE;
          results.add(new Money(fooNb, barNb, qixNb, bazNb)); 
        }
      }
    }
    return results;
  }
  
}