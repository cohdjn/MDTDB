<#
    .SYNOPSIS
        Get an existing location, or a list of locations.

    .DESCRIPTION
        Get an existing location, or a list of locations.

    .EXAMPLE
        # List all locations in the database.
        PS C:\> Get-MDTLocation

    .EXAMPLE
        # List the details of a location Las Vegas.
        PS C:\> Get-MDTLocation -Name 'Las Vegas'

    .PARAMETER Id
        Specifies the ID of the location to retrieve.

    .PARAMETER Name
        Specifies the name of the location to retrieve.

    .PARAMETER Detail
        Returns every gateway value for a location.
#>
function Get-MDTLocation
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
        $Name = '',

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [System.Management.Automation.SwitchParameter]
        $Detail
    )

    process
    {
        if ($Id -eq '' -and $Name -eq '')
        {
            if ($Detail)
            {
                $sqlCommand = 'SELECT * FROM LocationSettings'
            }
            else
            {
                $sqlCommand = 'SELECT DISTINCT ID, Location FROM LocationSettings'
            }
        }
        elseif ($Id -ne '')
        {
            if ($Detail)
            {
                $sqlCommand = "SELECT * FROM LocationSettings WHERE ID = $Id"
            }
            else
            {
                $sqlCommand = "SELECT DISTINCT ID, Location FROM LocationSettings WHERE ID = $Id"
            }
        }
        else
        {
            if ($Detail)
            {
                $sqlCommand = "SELECT * FROM LocationSettings WHERE Location = '$Name'"
            }
            else
            {
                $sqlCommand = "SELECT DISTINCT ID, Location FROM LocationSettings WHERE Location = '$Name'"
            }
        }

        $adapter = New-Object -TypeName System.Data.SqlClient.SqlDataAdapter($sqlCommand, $mdtSQLConnection)
        $dataSet = Get-MDTData -Adapter $adapter -Table 'LocationSettings'

        return $dataSet.Tables[0].Rows
    }
}
