function Replace-InFile() 
{
    param
    (
        [string] $Path, 
        [regex] $Find, 
        [string] $Replace
    )
    if (-not (test-path $path -ea 0))
    {
        Write-Error "Access denied $path"
        return
    }

    $Content = (Get-Content $path)
    $content -replace $find.tostring(), $replace | Set-Content $path
}
