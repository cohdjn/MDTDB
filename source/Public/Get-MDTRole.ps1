<#
    .SYNOPSIS
        Get an existing role, or a list of all roles.

    .DESCRIPTION
        Get an existing role, or a list of all roles.

    .EXAMPLE
        # List all roles in the database.
        PS C:\> Get-MDTRole

    .EXAMPLE
        # List the details of a role with name Laptops.
        PS C:\> Get-MDTRole -Name 'Laptops'

    .PARAMETER Id
        Specifies the ID of the role to retrieve.

    .PARAMETER Name
        Specifies the name of the role to retrieve.
#>
function Get-MDTRole
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
        $Name = ''
    )

    process
    {
        if ($Id -eq '' -and $Name -eq '')
        {
            $sqlCommand = "SELECT * FROM RoleSettings"
        }
        elseif ($Id -ne '')
        {
            $sqlCommand = "SELECT * FROM RoleSettings WHERE ID = $Id"
        }
        else
        {
            $sqlCommand = "SELECT * FROM RoleSettings WHERE Role = '$Name'"
        }

        $adapter = New-Object -TypeName System.Data.SqlClient.SqlDataAdapter($sqlCommand, $mdtSQLConnection)
        $dataSet = Get-MDTData -Adapter $adapter -Table 'RoleSettings'

        return $dataset.Tables[0].Rows
    }
}
