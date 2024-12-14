#Requires -Modules @{ ModuleName="Pester"; ModuleVersion="5.0.0" }
param(
    $TargetsFile = "targets.json",
    [switch]$Loop
)

$HR = [System.Environment]::NewLine + "─"*100 + [System.Environment]::NewLine*2
$PesterContainer = New-PesterContainer -Path "." -Data @{ TargetsFile=$TargetsFile}

if ($Loop) {
    while ($true) {Get-Date; Write-Host ""; Invoke-Pester -Container $PesterContainer -Output Detailed; $HR; Start-Sleep -Seconds 10}
}
else {
    Invoke-Pester -Container $PesterContainer -Output Detailed
}