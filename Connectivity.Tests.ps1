param($TargetsFile = "targets.json")

BeforeDiscovery {
    $Targets = Get-Content $TargetsFile | ConvertFrom-Json
}


if ($Targets.Ping.Count -gt 0) {
    Describe "Ping" {
        It "Pings IP <_>" -ForEach $Targets.Ping {
        (Get-CimInstance -ClassName Win32_PingStatus -Filter "(Address='$_') and timeout=1000").StatusCode | Should -Be 0
        }
    }
}


if ($Targets.TCP.Count -gt 0) {
    Describe "TCP" {
        $Bindings = $Targets.TCP | % {$Dest = $_.Target; $_.Port | % {"$($Dest):$_"}}
            It "Tests TCP for <_>" -ForEach $Bindings {
                $IP, $Port = $_.Split(":")
                $TcpClient = New-Object System.Net.Sockets.TcpClient
                try {$Result = $TcpClient.ConnectAsync($IP, $Port).Wait(150)} finally {$TcpClient.Close()}
                $Result | Should -Be $true
            }
    }
}


if ($Targets.DNS.Targets.Count -gt 0) {
    Describe "DNS" {
        It "Resolves DNS for <_.Target>" -ForEach $Targets.DNS.Targets {
        (Resolve-DnsName -Type A -Name $_.Target -DnsOnly -Server $Targets.DNS.Server).IPAddress | Should -Be $_.ShouldResolveTo
        }
    }
}
