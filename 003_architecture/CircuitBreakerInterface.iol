type RegisterType: void {
  .location: string
  .protocol: string
}

interface CircuitBreakerInterface {
  OneWay: callTO( void ), resetTO( void ), 
          register( RegisterType ), setTripThreshold( double ), 
          setCallTimeout( double ), setResetTimeout( double ), 
          setResetWindow( double )
}
