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
function Make-Toast
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([OutputType])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            Position = 0)]
        [String]
        $Message,

        [String]
        $Title = 'PowerShell',

        # Param2 help description
        [int32]
        $Seconds = 30
    )
    
    get-variable |? {$_.name -like "ps*"} | sort Name

    write-verbose "`$PSCommandPath = $($PSCommandPath)"
    #write-verbose "`$MyInvocation.MyCommand.Path = $($MyInvocation.MyCommand.Path)"
    #write-verbose "`$MyInvocation.MyCommand.Path = $($MyInvocation.MyCommand.Path)"

    $ScriptPath = split-path -path $PSCommandPath -Parent
    write-verbose "`$ScriptPath = $($ScriptPath)"

    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    
    $objNotifyIcon = New-Object System.Windows.Forms.NotifyIcon 
    
    test-path "$ScriptPath\powershell.ico"

    $objNotifyIcon.Icon = "$ScriptPath\powershell.ico"
    $objNotifyIcon.BalloonTipIcon = "info" 
    $objNotifyIcon.BalloonTipText = $Message 
    $objNotifyIcon.BalloonTipTitle = $Title
     
    $objNotifyIcon.Visible = $True 
    $objNotifyIcon.ShowBalloonTip($($Seconds * 1000))
}