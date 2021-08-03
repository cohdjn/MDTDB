<#
    .SYNOPSIS
        Get an existing make/model, or a list of all makes/models.

    .DESCRIPTION
        Get an existing make/model, or a list of all makes/models.

    .EXAMPLE
        # List all makes/models in the database.
        PS C:\> Get-MDTMakeModel

    .EXAMPLE
        # List the details of a Microsoft Virtual Machine.
        PS C:\> Get-MDTMakeModel -Make 'Microsoft' -Model 'Virtual Machine'

    .PARAMETER Id
        Specifies the ID of the make/model to retrieve.

    .PARAMETER Make
        Specifies the make of the computer.

    .PARAMETER Model
        Specifies the model of the computer.
#>
function Get-MDTMakeModel
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
        $Make = '',

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [System.String]
        $Model = ''
    )

    process
    {
        if ($Id -eq '' -and $Make -eq '' -and $Model -eq '')
        {
            $sqlCommand = "SELECT * FROM MakeModelSettings"
        }
        elseif ($Id -ne '')
        {
            $sqlCommand = "SELECT * FROM MakeModelSettings WHERE ID = $Id"
        }
        elseif ($Make -ne '' -and $Model -ne '')
        {
            $sqlCommand = "SELECT * FROM MakeModelSettings WHERE Make = '$Make' AND Model = '$Model'"
        }
        elseif ($Make -ne '')
        {
            $sqlCommand = "SELECT * FROM MakeModelSettings WHERE Make = '$Make'"
        }
        else
        {
            $sqlCommand = "SELECT * FROM MakeModelSettings WHERE Model = '$Model'"
        }

        $adapter = New-Object -TypeName System.Data.SqlClient.SqlDataAdapter($sqlCommand, $mdtSQLConnection)
        $dataSet = Get-MDTData -Adapter $adapter -Table 'MakeModelSettings'

        return $dataSet.Tables[0].Rows
    }
}
