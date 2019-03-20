function ConvertFrom-UnixTime {
<#
.Synopsis
   Converts a Unix time into a datetime object.
.DESCRIPTION
   Converts a Unix time into a datetime object.
.EXAMPLE
   This example converts a Unix Time (int) to standard DateTime object.

   ConvertFrom-UnixTime 1000000000
.Link
   http://github.com/glaisne/pstools
#>
  param(
      [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
    [Int32]
    $UnixTime
  )
  begin {
    $startdate = Get-Date –Date '01/01/1970' 
  }
  process {
    $timespan = New-Timespan -Seconds $UnixTime
    $startdate + $timespan
  }
}

