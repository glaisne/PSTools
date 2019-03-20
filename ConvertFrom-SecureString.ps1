
<#
Taken from https://www.powershelladmin.com/wiki/Powershell_prompt_for_password_convert_securestring_to_plain_text
Date Taken: 12/11/2017

#>
function ConvertFrom-SecureString
{
    param(
        [Parameter(Mandatory = $true)]
        [System.Security.SecureString]
        $SecurePassword
    )

    # Create a "password pointer"
    $PasswordPointer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword)
    
    # Get the plain text version of the password
    $PlainTextPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto($PasswordPointer)
    
    # Free the pointer
    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($PasswordPointer)
    
    # Return the plain text password
    $PlainTextPassword
    
}
