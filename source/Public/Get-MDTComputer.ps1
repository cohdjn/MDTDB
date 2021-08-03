<#
    .SYNOPSIS
        Get an existing computer entry, or a list of all computer entries.

    .DESCRIPTION
        Get an existing computer entry, or a list of all computer entries.

    .EXAMPLE
        # List all computers in the database.
        PS C:\> Get-MDTComputer

    .EXAMPLE
        # List the details of a computer with asset tag 789XYZ.
        PS C:\> Get-MDTComputer -AssetTag '789XYZ'

    .PARAMETER Id
        Specifies the ID of the computer to retrieve.

    .PARAMETER AssetTag
        Specifies the asset tag of the computer to retrieve.

    .PARAMETER MacAddress
        Specifies the MAC address of the computer to retrieve.

    .PARAMETER SerialNumber
        Specifies the serial number of the computer to retrieve.

    .PARAMETER Uuid
        Specifies the UUID of the computer to retrieve.

    .PARAMETER Description
        Specifies the description of the computer to retrieve.
#>
function Get-MDTComputer
{
    [CmdletBinding()]
    [OutputType([System.Data.DataRowCollection])]

    param
    (
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [System.String]
        $Id = '',

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [System.String]
        $AssetTag = '',

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [System.String]
        $MacAddress = '',

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [System.String]
        $SerialNumber = '',

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [System.String]
        $Uuid = '',

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [System.String]
        $Description = ''
    )

    process
    {
        if ($Id -eq '' -and $AssetTag -eq '' -and $MacAddress -eq '' -and `
            $SerialNumber -eq '' -and $Uuid -eq '' -and $Description -eq '')
        {
            $sqlCommand = 'SELECT * FROM ComputerSettings'
        }
        elseif ($Id -ne '')
        {
            $sqlCommand = "SELECT * FROM ComputerSettings WHERE ID = $Id"
        }
        else
        {
            $sqlCommand = 'SELECT * FROM ComputerSettings WHERE'
            if ($AssetTag -ne '')
            {
                $sqlCommand += " AssetTag='$AssetTag' AND"
            }

            if ($MacAddress -ne '')
            {
                $sqlCommand += " MacAddress='$MacAddress' AND"
            }

            if ($SerialNumber -ne '')
            {
                $sqlCommand += " SerialNumber='$SerialNumber' AND"
            }

            if ($Uuid -ne '')
            {
                $sqlCommand += " UUID='$Uuid' AND"
            }

            if ($Description -ne '')
            {
                $sqlCommand += " Description='$Description' AND"
            }
            $sqlCommand = $sqlCommand.TrimEnd(' AND')
        }

        $adapter = New-Object -TypeName System.Data.SqlClient.SqlDataAdapter($sqlCommand, $mdtSQLConnection)
        $dataSet = Get-MDTData -Adapter $adapter -Table 'ComputerSettings'

        return $dataSet.Tables[0].Rows
    }
}
