﻿function Get-MD5Hash {
    param (
        [Parameter(Mandatory)]
        [string] 
        $Path
    )
    # This Get-MD5 function sourced from:
    # http://blogs.msdn.com/powershell/archive/2006/04/25/583225.aspx
    $HashAlgorithm = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
    $Path = (resolve-path $Path).ProviderPath
    $Stream = [System.IO.File]::OpenRead($Path)
    try {
        $HashByteArray = $HashAlgorithm.ComputeHash($Stream)
    } finally {
        $Stream.Dispose()
    }

    return [System.BitConverter]::ToString($HashByteArray).ToLowerInvariant() -replace '-',''
}