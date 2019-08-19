include "console.iol"
include "TargetServiceInterface.iol"

outputPort TargetService {
  Location: "socket://localhost:8000"
  Protocol: http
  Interfaces: TargetServiceInterface
}

main
{
  sum@TargetService( { .x = 5, .y = 6 } )( res );
  println@Console( "Sum: " + i++ + ": " + res )();
  sum@TargetService( { .x = 4, .y = 3 } )( res );
  println@Console( "Sum: " + i++ + ": " + res )();
  sum@TargetService( { .x = 3, .y = 4 } )( res );
  println@Console( "Sum: " + i++ + ": " + res )()
}