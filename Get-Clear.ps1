function Get-Clear () {

    $error.Clear()
    [gc]::Collect()
    cls
}
