# Infrastructure Validation with Pester

This small script allows various infrastructure targets to be defined in a json file which Pester will use to run connectivity tests against and return results. 

Supported types of connectivity tests include Pings, TCP ports, and DNS A records, though adding your own types is straight forward. 

## Usage

Clone the repository, define your own json file or rename `targets.example.json` to `targets.json`, and execute Run.ps1.

Example

```powershell
Starting discovery in 1 files.
Discovering in C:\Code\InfrastructureValidation\Connectivity.Tests.ps1.
Found 8 tests. 5ms
Discovery finished in 8ms.
Running tests.

Running tests from 'C:\Code\InfrastructureValidation\Connectivity.Tests.ps1'
Describing Ping
  [+] Pings IP 1.1.1.1 21ms (19ms|1ms)
  [+] Pings IP 8.8.8.8 43ms (43ms|0ms)
  [+] Pings IP google.com 40ms (40ms|1ms)

Describing TCP
  [+] Tests TCP for xkln.net:80 13ms (11ms|2ms)
  [+] Tests TCP for xkln.net:443 15ms (14ms|1ms)
  [+] Tests TCP for google.com:80 33ms (32ms|1ms)
  [+] Tests TCP for google.com:443 33ms (32ms|0ms)

Describing DNS
  [+] Resolves DNS for resolver1.opendns.com 14ms (12ms|2ms)
Tests completed in 420ms
Tests Passed: 8, Failed: 0, Skipped: 0 NotRun: 0
```