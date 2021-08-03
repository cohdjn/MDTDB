<#
    .SYNOPSIS
        Deletes data from the MDT SQL database.

    .DESCRIPTION
        Private function that deletes data from the SQL database.

    .EXAMPLE
        PS C:\> Clear-MDTArray -Id $Id -Type 'C' -Table 'Settings_Administrators'

    .PARAMETER Id
        Specifies the ID to be removed.

    .PARAMETER Type
        Specifies the type of record to be removed.

    .PARAMETER Table
        Specifies the name of the table where the record(s) will be deleted.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function Clear-MDTArray
{
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]

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

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force
    )

    if ($Force -or $PSCmdlet.ShouldProcess($Id))
    {
        $sqlCommand = "DELETE FROM $Table WHERE ID = $Id AND Type = '$Type'"

        Write-Verbose -Message "Issuing command: $sqlCommand"
        $cmd = New-Object -TypeName System.Data.SqlClient.SqlCommand($sqlCommand, $mdtSQLConnection)
        $null = $cmd.ExecuteScalar()
    }
}
