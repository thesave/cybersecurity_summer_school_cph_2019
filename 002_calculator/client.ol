include "common.iol"
include "console.iol"
include "time.iol"

outputPort Calculator {
  Location: "socket://localhost:8000"
  Protocol: sodep
  Interfaces: CalculatorInterface
}

main
{
  { root.x = 17 | root.y = 25 };
  sum@Calculator( root )( sum );
  prod@Calculator( root )( prod );
	println@Console( "sum: " + sum + " prod: " + prod )()
}
