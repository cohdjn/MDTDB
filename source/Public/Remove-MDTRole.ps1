<#
    .SYNOPSIS
        Remove an existing role.

    .DESCRIPTION
        Remove an existing role from the database.

    .EXAMPLE
        PS C:\> Get-MDTRole -Name 'Desktops' | Remove-MDTRole

    .PARAMETER Id
        Specifies the ID of the role to remove.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function Remove-MDTRole
{
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]

    param
    (
        [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
        [System.String]
        $Id,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force
    )

    process
    {
        if ($Force -or $PSCmdlet.ShouldProcess($Id))
        {
            $sqlCommand = "DELETE FROM RoleIdentity WHERE ID = $Id"

            Write-Verbose -Message "Issuing command: $sqllCommand"
            $cmd = New-Object -TypeName System.Data.SqlClient.SqlCommand($sqlCommand, $mdtSQLConnection)
            $null = $cmd.ExecuteScalar()

            Write-Output "Removed role with ID [$Id]."
        }
    }
}
