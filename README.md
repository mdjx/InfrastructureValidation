# Infrastructure Validation with Pester

This small script allows various infrastructure targets to be defined in a json file which Pester will use to run connectivity tests against and return results. 

Supported types of connectivity tests include ping, TCP ports, and DNS A record validation, though adding your own types is straight forward. 

I've used this when making infrastructure or system changes (such as switch or router upgrades) as a fast way to validate the changes and ensure all services and systems are reachable.

## Usage

Clone the repository, define your own json file or rename `targets.example.json` to `targets.json`, and execute Run.ps1. This will run all tests every 10 seconds.

You can run `Run.ps1` without any parameters, or you can specify a custom json file with the `-TargetsFile` param. When one isn't specified the default it looks for is `targets.json`.

Example

```powershell
PS C:\Code\InfrastructureValidation> .\Run.ps1 

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