﻿$ModuleName   = "PSTools"
$ModulePath   = "C:\Program Files\WindowsPowerShell\Modules"
$TargetPath = "$($ModulePath)\$($ModuleName)"

if(-Not(Test-Path $TargetPath))
{
    mkdir $TargetPath | out-null
}

$filelist = @"
ConvertFrom-UnixTime.ps1
Convert-IPToBinary.ps1
Get-DNSHostName.ps1
Get-Event4624Details.ps1
Get-Event5140Details.ps1
Get-IPAddress.ps1
Get-MD5Hash.ps1
Get-ScheduledTask.ps1
Get-TimeZone.ps1
Get-UserProfile.ps1
Get-WebCertificateExpirationDate.ps1
PSTools.psm1
Test-FileLock.ps1
Test-IsAdministrator.ps1
Test-Port.ps1
Test-SystemResponseTime.ps1
Write-AsCSV.ps1
ZipFiles.ps1
"@

$filelist -split "`n" | % { Copy-Item -Verbose -Path "$pwd\$($_.trim())" -Destination "$($TargetPath)\$($_.trim())" }