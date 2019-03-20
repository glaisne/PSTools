function Get-UserProfile
{
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
    [CmdletBinding()]
    Param
    (
        # Param1 help description
        [Parameter(ValueFromPipeline=$true,
                   Position=0)]
        [string[]] $UserName = $Null
    )

    Begin
    {
        Write-Verbose "Getting the root profile path..."
        $RootProfilePath = $($Env:Userprofile).substring(0,$($ENV:Userprofile).LastIndexOf('\'))


    }
    Process
    {
        if ($Username -eq $null)
        {
            Write-Verbose "No UserName was specified, getting all user profiles."

            $UserRegistryFiles = @()
            foreach ($UserDirectory in Get-ChildItem -Path $RootProfilePath | ?{$_.mode -match "^d.*"})
            {
                $UserRegistryFiles += Get-ChildItem -Path $UserDirectory -Filter "NTUser.dat" -Force -ErrorAction SilentlyContinue
            }

            #$UserRegistryFiles = Get-ChildItem -Path $RootProfilePath -Filter "NTUser.dat" -Force -Recurse -ErrorAction SilentlyContinue

            Foreach ($UserRegistryFile in $UserRegistryFiles)
            {
                try
                {
                    $ProfileLocked = Test-FileLock $($UserRegistryFile.FullName)

                    $Profile = New-Object PSObject -Property @{
                        Path = $UserRegistryFile.Directory
                        CreationTime = $UserRegistryFile.CreationTime
                        LastAccessTime = $UserRegistryFile.LastAccessTime
                        LastWriteTime = $UserRegistryFile.LastWriteTime
                        Locked = $ProfileLocked
                    }
                }
                catch
                {
                }

                Write-Output $Profile
            }


        }
        else
        {
            Foreach ($UN in $Username)
            {
                Write-Verbose "Getting User profile for user $UN"

                $UserRegistryFile = $null
                Try
                {
                    $UserRegistryFile = Get-ChildItem -Path "$RootProfilePath\$UN" -Filter "NTUser.dat" -Force -ErrorAction Stop
                }
                catch {}

                if ($UserRegistryFile -ne $null)
                {
                    $ProfileLocked = Test-FileLock $($UserRegistryFile.FullName)

                    $Profile = New-Object PSObject -Property @{
                        Path = $UserRegistryFile.Directory
                        CreationTime = $UserRegistryFile.CreationTime
                        LastAccessTime = $UserRegistryFile.LastAccessTime
                        LastWriteTime = $UserRegistryFile.LastWriteTime
                        Locked = $ProfileLocked
                    }

                    Write-Output $Profile
                }
            }
        }
    }
    End
    {
    }
}