param($TargetsFile = "targets.json")

BeforeDiscovery {
    $Targets = Get-Content $TargetsFile | ConvertFrom-Json

    $Targets.Ping = $Targets.Ping | ForEach-Object {
        if ($_ -is [string]) {
            [PSCustomObject]@{ Target = $_; DisplayName = $_ }
        } else {
            $Name = if ($_.Label) { "$($_.Label) ($($_.Target))" } else { $_.Target }
            $_ | Add-Member -NotePropertyName DisplayName -NotePropertyValue $Name -PassThru
        }
    }

    $Bindings = $Targets.TCP | ForEach-Object {
        $Entry = $_
        $_.Port | ForEach-Object {
            $Name = if ($Entry.Label) { "$($Entry.Label) ($($Entry.Target):$_)" } else { "$($Entry.Target):$_" }
            [PSCustomObject]@{ Target = $Entry.Target; Port = $_; DisplayName = $Name }
        }
    }

    $Targets.DNS.Targets | ForEach-Object {
        $Name = if ($_.Label) { "$($_.Label) ($($_.Target))" } else { $_.Target }
        $_ | Add-Member -NotePropertyName DisplayName -NotePropertyValue $Name
    }
}


if ($Targets.Ping.Count -gt 0) {
    Describe "Ping" {
        It "Pings <_.DisplayName>" -ForEach $Targets.Ping {
        (Get-CimInstance -ClassName Win32_PingStatus -Filter "(Address='$($_.Target)') and timeout=1000").StatusCode | Should -Be 0
        }
    }
}


if ($Targets.TCP.Count -gt 0) {
    Describe "TCP" {
            It "Tests TCP for <_.DisplayName>" -ForEach $Bindings {
                $TcpClient = New-Object System.Net.Sockets.TcpClient
                try {$Result = $TcpClient.ConnectAsync($_.Target, $_.Port).Wait(150)} finally {$TcpClient.Close()}
                $Result | Should -Be $true
            }
    }
}


if ($Targets.DNS.Targets.Count -gt 0) {
    Describe "DNS" {
        It "Resolves DNS for <_.DisplayName>" -ForEach $Targets.DNS.Targets {
        (Resolve-DnsName -Type A -Name $_.Target -DnsOnly -Server $Targets.DNS.Server).IPAddress | Should -Be $_.ShouldResolveTo
        }
    }
}
