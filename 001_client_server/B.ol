include "interface.iol"
include "console.iol"

// DEPLOYMENT
inputPort MyInput {
  Location: "socket://localhost:8000/"
  Protocol: sodep
  Interfaces: SendNumberInterface
}

// BEHAVIOUR
main
{
	sendNumber( x ); // Receive x from any client
	println@Console( "the number is: " + x )()
}