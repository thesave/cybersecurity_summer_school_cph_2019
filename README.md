Jolie code examples presented at the Cybersecurity Summer School, Aug. 2019, Copenhagen.

For the introduction slides used in the demo, please to [Introduction to Jolie](http://www.saveriogiallorenzo.com/teaching/slides/001_Introduction.pdf)

Brief outline of the content of the repo:

- 001_client_server:
  - introducing *interfaces*
  - *deployment/behaviour* division
  - input and output operations (OneWays)
- 002_calculator: 
  - custom types
  - multiple inputports (using different protocols, e.g., a binary protocol like *sodep* and a request-response protocol like *http*)
  - input and output operations (RequestResponse)
  - making an always-on server: *concurrent* execution
  - sequential and parallel composition
  - interface evolution (add new operations to existing interfaces)
  - mutually-exclusive composition of operations (input-guarded choices)
- 003_architecture:
  - definition of a "complex" microservice: a circuit breaker
  - composition of the circuit breaker as a service in the calculator