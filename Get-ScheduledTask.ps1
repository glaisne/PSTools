function Get-ScheduledTask
{
<#
.Synopsis
   Short description
.DESCRIPTION
   This function, if used against a remote system 
   requires These two firewall rules enabled:
       Windows Management Instrumentation (DCOM-In)
       Windows Management Instrumentation (WMI-In)
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
    [CmdletBinding()]
    Param
    (
        # ComputerName
        [Parameter(ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string] $ComputerName,

        # Identity
        [String] $Identity
    )

    Begin
    {

        function Get-AllTaskSubFolders {
            [cmdletbinding()]
            param (
                # Set to use $Schedule as default parameter so it automatically list all files
                # For current schedule object if it exists.
                $FolderRef = $Schedule.getfolder("\")
            )
            $ArrFolders = @()
            if(($folders = $folderRef.getfolders(1))) 
            {
                foreach ($folder in $folders) 
                {
                    $ArrFolders += $folder
                    if($folder.getfolders(1)) 
                    {
                        Get-AllTaskSubFolders -FolderRef $folder
                    }
                }
            }
            write-output $ArrFolders
        }


    }
    Process
    {
        if (-Not $PSBoundParameters.ContainsKey('identity'))
        {
            $GetAll = $true
        }
        else
        {
            $GetAll = $False
        }


        Write-verbose "Working on computer $ComputerName`..."
        Write-Verbose "Loading Scheduled Tasks..."

        $EAP = $ErrorActionPreference
        Try
        {
            $ErrorActionPreference = 'stop'
            $schedule = new-object -com('Schedule.Service')
        }
        Catch [System.Management.Automation.RuntimeException]
        {
            $Err = $_
            Write-Error "$($Err.Exception.Message)`nException: $($Err.Exception.GetType().FullName)"
            $ErrorActionPreference = $EAP
            Return
        }
        Catch
        {
            $Err = $_
            write-Error $Err.Exception.Message
            $ErrorActionPreference = $EAP
            Return
        }
        $ErrorActionPreference = $EAP
            
            
        Write-Verbose "Connecting to $ComputerName..."


        $EAP = $ErrorActionPreference
        Try
        {
            $ErrorActionPreference = 'stop'
            if ($PSBoundParameters.ContainsKey('ComputerName'))
            {
                Write-Verbose "Connecting to $ComputerName..."
                $Schedule.connect($ComputerName)
            }
            else
            {
                Write-Verbose "Connecting to Localhost..."
                $Schedule.connect()
            }
             
        }
        Catch [System.Management.Automation.RuntimeException]
        {
            $Err = $_
            Write-Error "$($Err.Exception.Message)`nException: $($Err.Exception.GetType().FullName)"
            $ErrorActionPreference = $EAP
            Continue
        }
        Catch
        {
            $Err = $_
            write-Error $Err.Exception.Message
            $ErrorActionPreference = $EAP
            Continue
        }



        $identifiedTasks = @()

        $STRootFolder = $Schedule.getfolder("\")

        $STAllFolders = Get-AllTaskSubFolders -FolderRef $STRootFolder

        $STAllFolders += $STRootFolder

        foreach ($Folder in $STAllFolders | sort path) 
        {

            foreach ($Task in $Folder.getTasks(1) | sort name)
            {
                write-verbose "Task Name = $($Task.Name), Task Path = $($Task.Path)"
                if ($GetAll -eq $True -or `
                    $($Task.Name) -eq $Identity -or `
                    $($Task.Path) -eq $Identity )
                {
                    $return = New-Object -TypeName PSCustomObject -Property @{
	                    'Name' = $Task.name
                        'Path' = $Task.path
                        'State' = $Task.state
                        'Enabled' = $Task.enabled
                        'LastRunTime' = $Task.lastruntime
                        'LastTaskResult' = $Task.lasttaskresult
                        'NumberOfMissedRuns' = $Task.numberofmissedruns
                        'NextRunTime' = $Task.nextruntime
                        'Author' =  ([xml]$Task.xml).Task.RegistrationInfo.Author
                        'UserId' = ([xml]$Task.xml).Task.Principals.Principal.UserID
                        'Description' = ([xml]$Task.xml).Task.RegistrationInfo.Description
                    }
                    write-output $return
                }
            }
        }
    }
    End
    {
    }
}
