function Get-Sample 
{
    [CmdletBinding()]
    [Alias()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                ValueFromPipeline=$true,
                Position=0)]
        [object]
        $Object
    )

    Begin
    {
    }
    Process
    {
        $_ | fl * -force
        throw (new-object System.Management.Automation.PipelineStoppedException)
    }
    End
    {
    }
}
