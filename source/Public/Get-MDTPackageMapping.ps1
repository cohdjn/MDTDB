<#
    .SYNOPSIS
        Get the mapping between an Add/Remove Programs name and a package, or list all mapping entries.

    .DESCRIPTION
        Get the mapping between an Add/Remove Programs name and a package, or list all mapping entries.

    .EXAMPLE
        PS C:\> Get-MDTPackageMapping -ARPName 'XYZ'

    .PARAMETER ARPName
        Specifies the name of the mapping to be retrieved.

    .PARAMETER Package
        Specifies the name of the package to be retrieved.
#>
function Get-MDTPackageMapping
{
    [CmdletBinding()]
    [OutputType([System.Data.DataRowCollection])]

    param
    (
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [System.String]
        $ARPName = '',

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [System.String]
        $Package = ''
    )

    process
    {
        if ($ARPName -eq '' -and $Package -eq '')
        {
            $sqlCommand = "SELECT * FROM PackageMapping"
        }
        elseif ($ARPName -ne '' -and $Package -ne '')
        {
            $sqlCommand = "SELECT * FROM PackageMapping WHERE ARPName = '$ARPName' AND Packages = '$Package'"
        }
        elseif ($ARPName -ne '')
        {
            $sqlCommand = "SELECT * FROM PackageMapping WHERE ARPName = '$ARPName'"
        }
        else
        {
            $sqlCommand = "SELECT * FROM PackageMapping WHERE Packages = '$Package'"
        }

        $adapter = New-Object -TypeName System.Data.SqlClient.SqlDataAdapter($sqlCommand, $mdtSQLConnection)
        $dataSet = Get-MDTData -Adapter $adapter -Table 'PackageMapping'

        return $dataset.Tables[0].Rows
    }
}
