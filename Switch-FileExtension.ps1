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
function Switch-FileExtension
{
    [CmdletBinding()]
    [OutputType([String])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            Position = 0)]
        [String[]]
        $Path,

        # Param2 help description
        [String]
        $NewExtension
    )

    Begin
    {
    }
    Process
    {
        $Path.replace($Path.Substring($Path.LastIndexOf('.')), ".$($NewExtension.TrimStart('.'))")
    }
    End
    {
    }
}

