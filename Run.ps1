param($TargetsFile = "targets.json")

#[System.Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$HR = [System.Environment]::NewLine + "─"*100 + [System.Environment]::NewLine*2
$PesterContainer = New-PesterContainer -Path "." -Data @{ TargetsFile=$TargetsFile}

while ($true) {Get-Date; Write-Host ""; Invoke-Pester -Container $PesterContainer -Output Detailed; $HR; Start-Sleep -Seconds 5}



