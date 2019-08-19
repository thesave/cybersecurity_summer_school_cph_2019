interface StatsInterface {
  OneWay: setThreshold( double ), timeout( void ), success( void ),
     failure( void ), reset( void )
  RequestResponse: checkRate( void )( bool ), shouldTrip( void )( bool )
}