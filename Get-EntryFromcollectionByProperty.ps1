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
function Get-EntryFromcollectionByProperty
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([Object])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $PropertyName,
        
        [Parameter(Mandatory = $true,
            Position = 1)]
        [ValidateNotNullOrEmpty()]
        [Object]
        $PropertyValue,

        [Parameter(Mandatory = $true,
            Position = 2)]
        [ValidateNotNullOrEmpty()]
        [Object[]]
        $Collection,

        [switch]
        $ReturnAll
    )

    $TestEntry = $collection | select -first 1

    if (($TestEntry | gm -Name $PropertyName | measure).count -ne 1)
    {
        Throw "Test entry in collection does not have property named $PropertyName"
    }

    foreach ($entry in $Collection)
    {
        if ($entry.$PropertyName -as $propertyValue.gettype().fullname -eq $PropertyValue)
        {
            $entry
            if (-not $ReturnAll)
            {
                break
            }
        }
    }
}
