function Get-ClosestDayOfWeek
{
<#
.Synopsis
   Gets the closest day of week by name from a given date.
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
    [CmdletBinding()]
    [OutputType([datetime])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        [datetime[]]$StartDate,
        
        [Parameter(Mandatory=$true,
                   Position=1)]
        [ValidateSet("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")]
        [string] $DayOfWeek
        
    )

    foreach ($sDate in $StartDate)
    {

        $TargetDays = new-object System.Collections.ArrayList
        for ($i = -7; $i -lt 7; $i++)
        { 
            if ($sDate.AddDays($i).DayOfWeek -eq $DayOfWeek)
            {
                $TargetDays.Add($i) | Out-Null
            }
        }

        $ClosestTargetDay = 14  # start with an out fo range number.

        if ($TargetDays -contains 0)
        {
            Write-output $sDate
        }
        else
        {

            Foreach ($TargetDay in $TargetDays)
            {
                if ($TargetDay -lt 0)
                {
                    if (($TargetDay * -1) -lt $ClosestTargetDay)
                    {
                        $ClosestTargetDay = $TargetDay
                    }
                }
                else
                {
                    if ($TargetDay -lt $ClosestTargetDay)
                    {
                        $ClosestTargetDay = $TargetDay
                    }
                }
            }
            Write-output $($sDate.AddDays($ClosestTargetDay))
        }
    }
}

