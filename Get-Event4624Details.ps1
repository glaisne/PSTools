<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function get-Event4624Details
{
    [CmdletBinding()]
    [OutputType([psobject])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        [AllowNull()]
        [System.Diagnostics.EventLogEntry[]]$Event
    )

    Begin
    {
        $EventMessageSubjectRegEx = "Subject:\r\n\tSecurity ID:\s+(?<Subject_SecurityID>[S\-0-9a-f]+)\r\n\tAccount Name:\s+(?<Subject_AccountName>[\-0-9a-z\$]+)\r\n\tAccount Domain:\s+(?<Subject_AccountDomain>[\-0-9a-z]+)\r\n\tLogon ID:\s+(?<Subject_LogonID>[x\-0-9a-f]+)"
        $EventMessageLogonTypeRegEx = "Logon Type:\s*(?<LogonType>\d*)"
        $EventMessageNewLogonRegex = "New Logon:\r\n\tSecurity ID:\s+(?<NewLogon_SecurityID>s[\-0-9]+)\r\n\tAccount Name:\s+(?<NewLogon_AccountName>[\w\.\$-]+)\r\n\tAccount Domain:\s+(?<NewLogon_AccountDomain>[\w ]+)\r\n\tLogon ID:\s+(?<NewLogon_LogonID>0x[0-9a-f]+)\r\n\tLogon GUID:\s+(?<NewLogon_LogonGUID>{[-0-9a-f]+})"
        $EventMessageProcessInformationRegex = "Process Information:\r\n\tProcess ID:\s+(?<ProcessInfo_processId>0x[0-9a-f]+)\r\n\tProcess Name:\s+(?<ProcessInfo_ProcessName>[\w-\.\\:]+)"
        $EventMessageNetworkInformationRegex = "Network Information:\r\n\tWorkstation Name:\s+(?<NetworkInfo_WorkstationName>[\w\-]*)\r\n\tSource Network Address:\s+(?<NetworkInfo_NetworkAddress>[\-a-f:0-9\.]+)\r\n\tSource Port:\s+(?<NetworkInfo_SourcePort>[\-0-9]+)"
        $EventMessageDetailedAuthenticationInformation = "Detailed Authentication Information:\r\n\tLogon Process:\s+(?<AuthInfo_LogonProcess>\w+)\r\n\tAuthentication Package:\s+(?<AuthInfo_AuthPackage>\w+)\r\n\tTransited Services:\s+(?<AuthInfo_TransitedServices>\w+)\r\n\tPackage Name (NTLM only):\s+(?<AuthInfo_PackageName>\w+)\r\n\tKey Length:\s+(?<AuthInfo_KeyLength>\d+..)"
        $EventMessageRegex = "An account was successfully logged on.\s*$EventMessageSubjectRegEx\s*$EventMessageLogonTypeRegEx\s*$EventMessageNewLogonRegex\s*$EventMessageProcessInformationRegex\s*$EventMessageNetworkInformationRegex"
    }
    Process
    {
        foreach ($Entry in $Event)
        {
            <#
            write-host -fore yellow "$($Entry.Index)"

            if ($Entry.message -match $EventMessageSubjectRegEx)
            {
                write-host -fore green -back black 'EventMessageSubjectRegEx'
                $matches
            }
            else
            {
                write-host -fore red -back black 'EventMessageSubjectRegEx'
            }

            if ($Entry.message -match $EventMessageLogonTypeRegEx)
            {
                write-host -fore green -back black 'EventMessageLogonTypeRegEx'
                $matches
            }
            else
            {
                write-host -fore red -back black 'EventMessageLogonTypeRegEx'
            }


            if ($Entry.message -match $EventMessageNewLogonRegex)
            {
                write-host -fore green -back black 'EventMessageNewLogonRegex'
                $matches
            }
            else
            {
                write-host -fore red -back black 'EventMessageNewLogonRegex'
            }


            if ($Entry.message -match $EventMessageProcessInformationRegex)
            {
                write-host -fore green -back black 'EventMessageProcessInformationRegex'
                $matches
            }
            else
            {
                write-host -fore red -back black 'EventMessageProcessInformationRegex'
            }


            if ($Entry.message -match $EventMessageNetworkInformationRegex)
            {
                write-host -fore green -back black 'EventMessageNetworkInformationRegex'
                $matches
            }
            else
            {
                write-host -fore red -back black 'EventMessageNetworkInformationRegex'
            }


            if ($Entry.message -match $EventMessageRegex)
            {
                write-host -fore green -back black 'EventMessageRegex'
                $matches
            }
            else
            {
                write-host -fore red -back black 'EventMessageRegex'
            }
            #>

            $matches = $null
            $Entry.message -match $EventMessageRegex | Out-Null

            $result = new-object psobject -Property @{
                TimeGenerated               = $Entry.TimeGenerated
                NewLogon_AccountDomain      = $matches.NewLogon_AccountDomain
                NetworkInfo_NetworkAddress  = $matches.NetworkInfo_NetworkAddress
                Subject_AccountDomain       = $matches.Subject_AccountDomain
                NetworkInfo_SourcePort      = $matches.NetworkInfo_SourcePort
                ProcessInfo_processId       = $matches.ProcessInfo_processId
                Subject_AccountName         = $matches.Subject_AccountName
                LogonType                   = $matches.LogonType
                Subject_SecurityID          = $matches.Subject_SecurityID
                NewLogon_LogonGUID          = $matches.NewLogon_LogonGUID
                NewLogon_SecurityID         = $matches.NewLogon_SecurityID
                NetworkInfo_WorkstationName = $matches.NetworkInfo_WorkstationName
                NewLogon_AccountName        = $matches.NewLogon_AccountName
                NewLogon_LogonID            = $matches.NewLogon_LogonID
                Subject_LogonID             = $matches.Subject_LogonID
                ProcessInfo_ProcessName     = $matches.ProcessInfo_ProcessName
            }
            write-output $result
        }
    }
    End
    {
    }
}


