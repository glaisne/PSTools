function Set-Clean () {

    $error.Clear()
    [gc]::Collect()
    cls
}
