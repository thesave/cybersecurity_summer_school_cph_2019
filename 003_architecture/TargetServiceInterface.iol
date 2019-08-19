type CalcRequest:void {
  .x: int
  .y: int
}

interface TargetServiceInterface {
  RequestResponse: sum( CalcRequest )( int )
}