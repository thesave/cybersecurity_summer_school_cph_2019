include "console.iol"
include "time.iol"
include "string_utils.iol"
include "TargetServiceInterface.iol"
include "CircuitBreakerInterface.iol"

inputPort In {
  Location: "socket://localhost:9000"
  Protocol: sodep
  Interfaces: TargetServiceInterface
}

outputPort CircuitBreaker { Interfaces: CircuitBreakerInterface }
embedded { Jolie: "CircuitBreaker.ol" in CircuitBreaker }

execution{ concurrent }

init {
  register@CircuitBreaker( global.inputPorts.In );
  setTripThreshold@CircuitBreaker( 5 /* % */ );
  setCallTimeout@CircuitBreaker( 0.2 /* secs */ );
  setResetTimeout@CircuitBreaker( 10 /* secs */ )
}

main
{
  sum( a )( b ) {
      sleep@Time( 1000 )();
      println@Console( a.x + " + " + a.y )();
      b = a.x + a.y
  }
}
