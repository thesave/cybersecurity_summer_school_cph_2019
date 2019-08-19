include "console.iol"
include "time.iol"
include "CB_constants.iol"
include "StatsInterface.iol"
include "TargetServiceInterface.iol"
include "CircuitBreakerInterface.iol"

interface extender CircuitBreaker_InterfaceExtender {
  RequestResponse: *( void )( void ) throws ServiceLoadExceded
}

outputPort TargetService { 
  Interfaces: TargetServiceInterface 
}

outputPort Stats { Interfaces: StatsInterface }
embedded { Jolie: "Stats.ol" in Stats }

inputPort CB {
  Location: "socket://localhost:8000"
  Protocol: http
  Aggregates: TargetService with CircuitBreaker_InterfaceExtender 
}

define getState { synchronized( state ){ state = global.state } }
define setState { synchronized( state ){ global.state = state } }

define trip {
  state = CB_Open; 
  setState;
  scheduleTimeout@Time( int(resetTimeout*1000) { .operation = "resetTO" } )( resetTO_id )
}

define checkErrorRate {
  getState;
  if ( state == CB_Closed ){
    shouldTrip@Stats()( shouldTrip );
    if( shouldTrip ){ trip }
  }
  else if ( state == CB_HalfOpen ){ trip }
}

define cancelCallTO {
    cancelTimeout@Time( callTO_id )()
}

define bindTS { TargetService << TS }

courier CB {
  [ interface TargetServiceInterface( request )( response ) ]{
    getState;
    if ( state == CB_Closed ) {
      scheduleTimeout@Time( int(callTimeout*1000) { .operation = "callTO" } )( callTO_id );
      install( default => cancelCallTO; failure@Stats(); checkErrorRate );
      bindTS;
      forward( request )( response );
      success@Stats(); cancelCallTO
    }
    else if ( state == CB_Open ){ throw( ServiceLoadExceded ) }
    else if ( state == CB_HalfOpen ){
      println@Console( "HalfOpen request" )();
      checkRate@Stats()( canPass );
      println@Console( "canPass: " + canPass )();
      if( canPass ){ 
        scheduleTimeout@Time( int(callTimeout*1000) { .operation = "callTO" } )( callTO_id );
        install( default => cancelCallTO; failure@Stats(); checkErrorRate );
        bindTS;
        forward( request )( response );
        success@Stats(); cancelCallTO
      }
      else { throw( ServiceLoadExceded ) }
    }
  }
}

inputPort CBInternal {
  Location: "local"
  Interfaces: CircuitBreakerInterface
}

init
{
  callTimeout   -> global.callTimeout; /* timeout after X seconds without a response */ 
  tripThreshold -> global.tripThreshold; /* open the circuit if the X% error rate gets equal or more than */
  rollingWindow -> global.rollingWindow; /* monitor errors over a rolling window of X seconds */
  resetTimeout  -> global.resetTimeout; /* attempt to reset the circuit after X seconds since opened the circuit */
  // DEFAULT VALUES
  callTimeout   = 0.1;
  tripThreshold = 2;
  rollingWindow = 60;
  resetTimeout  = 30;
  TS -> global.TS;
  state = CB_Closed;
  setState
}

execution{ concurrent }

main {
  [ register( b ) ]{ TS << b }
  [ setTripThreshold( b ) ]{ tripThreshold = b; setThreshold@Stats( tripThreshold ) }
  [ setCallTimeout( callTimeout ) ]
  [ setResetTimeout( resetTimeout ) ]
  [ setResetWindow( setResetWindow ) ]
  [ callTO() ]{ timeout@Stats(); checkErrorRate }
  [ resetTO() ]{ synchronized( state ){
      if( global.state == CB_Open ){ reset@Stats(); global.state = CB_HalfOpen }
    }
  }
}