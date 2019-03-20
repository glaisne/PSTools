function ZipFiles( $zipfilename, $sourcedir )
{
    [Reflection.Assembly]::LoadWithPartialName( "System.IO.Compression.FileSystem" ) | out-null

    try
    {
        write-verbose "Trying .NET 4.5 version of file compression"
        $compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
        [System.IO.Compression.ZipFile]::CreateFromDirectory( $sourcedir, $zipfilename, $compressionLevel, $false )
    }
    catch
    {
        write-verbose ".NET 4.5 version of compression didn't work."
    }

    if (-Not $(Test-Path $ZipFileName) )
    {
        [System.IO.Compression.ZipFile]::CreateFromDirectory( $sourcedir, $zipfilename )
    }
    
}
