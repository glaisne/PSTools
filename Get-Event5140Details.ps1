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

<#
Message            : A network share object was accessed.

                     Subject:
                         Security ID:        S-1-5-18
                         Account Name:        GRN-EQDC-01$
                         Account Domain:        EQUIS
                         Logon ID:        0xe66912a4

                     Network Information:
                         Object Type:        File
                         Source Address:        ::1
                         Source Port:        60594

                     Share Information:
                         Share Name:        \\*\IPC$
                         Share Path:

                     Access Request Information:
                         Access Mask:        0x1
                         Accesses:        %%4416

#>

function get-Event5140Details
{
    [CmdletBinding()]
    [OutputType([psobject])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        [System.Diagnostics.EventLogEntry[]]$Event
    )

    Begin
    {
        $EventMessageSubjectRegEx = "Subject:\r\n\tSecurity ID:\s+(?<Subject_SecurityID>[S\-0-9a-z\\\.]+)\r\n\tAccount Name:\s+(?<Subject_AccountName>[\w\-\$\.]+)\r\n\tAccount Domain:\s+(?<Subject_AccountDomain>[\-0-9a-z]+)\r\n\tLogon ID:\s+(?<Subject_LogonID>[x\-0-9a-f]+)"
        $EventMessageNetworkInformationRegex = "Network Information:\s*Object Type:\s+(?<NetworkInfo_ObjectType>\w*)\s*Source Address:\s+(?<NetworkInfo_SourceAddress>[\-a-f:0-9\.]+)\s*Source Port:\s+(?<NetworkInfo_SourcePort>[0-9]+)"
        $EventMessageShareInformationRegex = "Share Information:\r\n\tShare Name:\s+(?<ShareInfo_ShareName>[ \.\w\\\*\$-]+)\r\n\tShare Path:\s+(?<ShareInfo_SharePath>[ \?\w\\\:\-\.]*)"
        $EventMessageAccessReqInformationRegex = "Access Request Information:\r\n\tAccess Mask:\s+(?<AccessInfo_AccessMask>[x\da-f]+)\r\n\tAccesses:\s+(?<AccessInfo_Accesses>[\%\d\(\)\w ]+)"
        $EventMessageRegex = "A network share object was accessed.\s*$EventMessageSubjectRegEx\s*$EventMessageNetworkInformationRegex\s*$EventMessageShareInformationRegex\s*$EventMessageAccessReqInformationRegex"        
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
                #$matches
            }
            else
            {
                write-host -fore red -back black 'EventMessageSubjectRegEx'
                $Entry.Message 
                break
            }

            if ($Entry.message -match $EventMessageNetworkInformationRegex)
            {
                write-host -fore green -back black 'EventMessageNetworkInformationRegex'
                #$matches
            }
            else
            {
                write-host -fore red -back black 'EventMessageNetworkInformationRegex'
                $Entry.Message 
                break
            }


            if ($Entry.message -match $EventMessageShareInformationRegex)
            {
                write-host -fore green -back black 'EventMessageShareInformationRegex'
                #$matches
            }
            else
            {
                write-host -fore red -back black 'EventMessageShareInformationRegex'
                $Entry.Message 
                break
            }


            if ($Entry.message -match $EventMessageAccessReqInformationRegex)
            {
                write-host -fore green -back black 'EventMessageAccessReqInformationRegex'
                #$matches
            }
            else
            {
                write-host -fore red -back black 'EventMessageAccessReqInformationRegex'
                $Entry.Message 
                break
            }


            if ($Entry.message -match $EventMessageRegex)
            {
                write-host -fore green -back black 'EventMessageRegex'
                #$matches
            }
            else
            {
                write-host -fore red -back black 'EventMessageRegex'
                $Entry.Message 
                break
            }

            #>

            $matches = $null
            $Entry.message -match $EventMessageRegex | Out-Null

            $result = new-object psobject -Property @{
                TimeGenerated               = $Entry.TimeGenerated
                Subject_SecurityID          = $matches.Subject_SecurityID
                Subject_AccountName         = $matches.Subject_AccountName
                Subject_AccountDomain       = $matches.Subject_AccountDomain
                Subject_LogonID             = $matches.Subject_LogonID
                NewLogon_AccountDomain      = $matches.NetworkInfo_ObjectType
                NewLogon_LogonGUID          = $matches.NetworkInfo_SourceAddress
                NewLogon_SecurityID         = $matches.NetworkInfo_SourcePort
                NewLogon_AccountName        = $matches.ShareInfo_ShareName
                NewLogon_LogonID            = $matches.ShareInfo_SharePath
                NetworkInfo_NetworkAddress  = $matches.AccessInfo_AccessMask
                NetworkInfo_SourcePort      = $matches.AccessInfo_Accesses
            }
            write-output $result
        }
    }
    End
    {
    }
}
