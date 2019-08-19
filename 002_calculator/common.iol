type CalcRequest:void {
	.x: int
	.y: int
}

interface CalculatorInterface {
  RequestResponse: sum( CalcRequest )( int ), 
                   prod( CalcRequest )( int )
}