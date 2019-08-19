include "interface.iol"
include "console.iol"

// DEPLOYMENT
outputPort B {
  Location: "socket://localhost:8000"
  Protocol: sodep
  Interfaces: SendNumberInterface
}
// DEPLOYMENT

// ------- BEHAVIOUR ----
main
{
  sendNumber @ B ( 5 )
}
// ------- BEHAVIOUR ----
