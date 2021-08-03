<#
    .SYNOPSIS
        Remove an existing location.

    .DESCRIPTION
        Remove an existing location from the database.

    .EXAMPLE
        PS C:\> Get-MDTLocation -Name 'Seattle' | Remove-MDTLocation

    .PARAMETER Id
        Specifies the ID of the location to remove.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function Remove-MDTLocation
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
            $sqlCommand = "DELETE FROM LocationIdentity WHERE ID = $Id"

            Write-Verbose -Message "Issuing command: $sqlCommand"
            $cmd = New-Object -TypeName System.Data.SqlClient.SqlCommand($sqlCommand, $mdtSQLConnection)
            $null = $cmd.ExecuteScalar()

            Write-Output "Removed location with ID [$Id]."
        }
    }
}
