<#
    .SYNOPSIS
        Retrieves data from the MDT SQL database.

    .DESCRIPTION
        Private function that retrieves data from the SQL database.

    .EXAMPLE
        PS C:\> Get-MDTArray -Id $Id -Type 'C' -Table 'Settings_Administrators' -Column 'Administrators'

    .PARAMETER Id
        Specifies the ID to be retrieved.

    .PARAMETER Type
        Specifies the type of record to be retrieved.

    .PARAMETER Table
        Specifies the name of the table to retrieve the record(s) from.

    .PARAMETER Column
        Specifies which piece of data from the record to return.
#>
function Get-MDTArray
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [ValidateSet('C', 'L', 'M', 'R')]
        [System.String]
        $Type,

        [Parameter(Mandatory = $true)]
        [ValidateSet('PackageMapping', 'Settings_Administrators', 'Settings_Applications', 'Settings_Packages', 'Settings_Roles')]
        [System.String]
        $Table,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Column
    )

    $sqlCommand = "SELECT $Column FROM $Table WHERE ID = $Id AND Type = '$Type' ORDER BY Sequence"

    Write-Verbose -Message "Issuing command: $sqlCommand"
    $adapter = New-Object -TypeName System.Data.SqlClient.SqlDataAdapter($sqlCommand, $mdtSQLConnection)
    $dataSet = Get-MDTData -Adapter $adapter -Table $Table

    return $dataSet.Tables[0].Rows
}
