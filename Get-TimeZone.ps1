function Get-TimeZone()
{
    $EAP = $ErrorActionPreference
    Try
    {
        $ErrorActionPreference = stop
        [System.TimeZoneInfo]::Local.Id
    }
    Catch
    {
        #Try something simpler
        (Get-WmiObject -Class win32_TimeZone).StandardName
    }
    $ErrorActionPreference = $EAP
}