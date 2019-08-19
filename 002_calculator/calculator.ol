include "common.iol"
include "console.iol"

// "http://localhost:8080/sum?x=5&y=6"

inputPort In2 {
  Location: "socket://localhost:8080"
  Protocol: http { .format = "json" }
  Interfaces: CalculatorInterface
}

inputPort In {
  Location: "socket://localhost:8000"
  Protocol: sodep
  Interfaces: CalculatorInterface
}

execution{ concurrent }

main
{
  [
  sum( a )( b ) {
      println@Console( a.x + " + " + a.y )();
      b = a.x + a.y
  }
  ]
  [
  prod( a )( b ) {
      println@Console( a.x + " x " + a.y )();
      b = a.x * a.y
  }]
}
