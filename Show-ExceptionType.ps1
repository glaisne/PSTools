# taken from Don Jones:
# https://github.com/devops-collective-inc/big-book-of-powershell-error-handling/blob/master/attachments/code/examples/DetermineExceptionType.ps1

function Show-ExceptionType
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [System.Exception]
        $Exception
    )

    $indent = 0

    $e = $Exception

    while ($e)
    {
        Write-Host ("{0,$indent}{1}" -f '', $e.GetType().FullName)
        
        $indent += 2
        $e = $e.InnerException
    }

}