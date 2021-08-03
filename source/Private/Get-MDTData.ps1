<#
    .SYNOPSIS
        Private helper function to retrieve data from the MDT SQL databse.

    .DESCRIPTION
        Private helper function to retrieve data from the MDT SQL databse.

    .EXAMPLE
        PS C:\> Get-MDTData -Adapter $Adapter -Table $Table

    .PARAMETER Adapter
        Specifies the SQL data adapter for the database.

    .PARAMETER Table
        Specifies the name of the table to retrieve the record(s) from.
#>
function Get-MDTData
{
    param
    (
        [Parameter()]
        $Adapter,

        [Parameter()]
        $Table
    )

    $dataSet = New-Object -TypeName System.Data.DataSet
    $null = $Adapter.Fill($dataSet, $Table)

    return $dataSet
}
