include "StatsInterface.iol"
include "console.iol"

inputPort StatsIn {
  Location: "local"
  Interfaces: StatsInterface
}

execution{ concurrent }

init { 
  timeout -> global.stats.timeout;
  success -> global.stats.success;
  failure -> global.stats.failure;
  threshold -> global.stats.threshold
}

main 
{
  [ setThreshold( global.stats.threshold ) ]
  [ timeout() ]{ synchronized( stats ){ timeout++; println@Console( "Timeout" )() } }
  [ success() ]{ synchronized( stats ){ success++; println@Console( "Success" )() } }
  [ failure() ]{ synchronized( stats ){ failure++; println@Console( "Failure" )() } }
  [ reset() ]{ synchronized( stats ){ 
    println@Console( "Reset" )();
    global.stats.failure=global.stats.timeout=global.stats.success=0 }
  }
  [ checkRate()( canPass ){
    synchronized( stats ){
      rate = 0;
      if( success + timeout + failure > 0 ){ 
        rate = ( timeout + failure ) / ( success + timeout + failure )
      };
      canPass = ( rate * 100 ) >= threshold;
      println@Console( "CheckRate: rate " + rate + " canPass: " + canPass )()
  }}]
  [ shouldTrip()( shouldTrip ){
    synchronized( stats ){
      rate = 0;
      if( success + timeout + failure > 0 ){ 
        rate = ( timeout + failure ) / ( success + timeout + failure )
      };
      shouldTrip = ( rate * 100 ) >= threshold;
      println@Console( "ShouldTrip: rate " + rate + " shouldTrip: " + shouldTrip )()
  }}]
}