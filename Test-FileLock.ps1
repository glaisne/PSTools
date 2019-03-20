function Test-FileLock
{
    param
    (
        [parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [Alias("FullName")]
        [string]$Path,
        [switch]$PassThru
    )
    begin {}
    Process
    {
     $oFile = New-Object System.IO.FileInfo $Path

     if ((Test-Path -Path $Path) -eq $false)
     {
         if ($PassThru.IsPresent -eq $false)
         {
             Write-Output $false
         }
         return
     }
         
     try
     {
         $oStream = $oFile.Open([System.IO.FileMode]::Open, [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::None)
         if ($oStream)
         {
          $oStream.Close()
         }
         if ($PassThru.IsPresent -eq $false)
         {
             Write-Output $false
         }
         else
         {
             Get-Item $Path
         }
     }
     catch
     {
         # file is locked by a process.
         if ($PassThru.IsPresent -eq $false)
         {
             Write-Output $true
         }
     }
    }
    end {}
}
