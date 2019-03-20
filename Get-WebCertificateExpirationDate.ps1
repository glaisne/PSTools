function Get-WebCertificateExpirationDate
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$True,
                   ParameterSetName="DNSEntry",
                   Position=0)]
        [String[]] $DNSEntry,
        [int]      $TimeOut = 5000
    )

    BEGIN 
    {
    }
    PROCESS
    {
        Foreach ($Entry in $DNSEntry)
        {
            write-verbose "DNSEntry = $Entry"

            #$DNSEntry = $Object.DNSEntry
            write-verbose "working on 'https://$Entry"
            $webRequest = [Net.WebRequest]::Create("https://$Entry")

            write-verbose "Default timeout = $($webRequest.timeout)"

            if ($Timeout -ne $webRequest.Timeout)
            {
                write-verbose "Setting timeout to  = $TimeOut"
                $webRequest.Timeout = $TimeOut
            }

            try 
            { 
                $webRequest.GetResponse() | Out-Null
            }catch
            {
               Write-Warning "Unable to access 'https://$Entry'"
            }

            $cert = $null
            $cert = $webRequest.ServicePoint.Certificate

            if ($cert -eq $null)
            {
                $HasCertificate = $False
                $ExpirationDate = $Null
                $DaysRemaining  = $Null
            }
            else
            {
                $HasCertificate = $True
                $ExpirationDate = $(get-date $cert.GetExpirationDateString())
                $DaysRemaining  = $(New-TimeSpan -End $(get-date $cert.GetExpirationDateString())).Days
            }

            Write-Output $(New-Object PSObject -Property @{
                ComputerName = $Entry
                HasCertificate = $HasCertificate
                ExpirationDate = $ExpirationDate
                DaysRemaining  = $DaysRemaining 
            })

        }
    }
    END
    {
    }
}