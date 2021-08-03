<#
    .SYNOPSIS
        Remove an existing computer entry.

    .DESCRIPTION
        Remove an existing computer entry from the database.

    .EXAMPLE
        PS C:\> Get-MDTComputer -AssetTag '123ABC' | Remove-MDTComputer

    .PARAMETER Id
        Specifies the ID of the computer to remove.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function Remove-MDTComputer
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
            $sqlCommand = "DELETE FROM ComputerIdentity WHERE ID = $Id"

            Write-Verbose "Issuing command: $sqlCommand"
            $cmd = New-Object -TypeName System.Data.SqlClient.SqlCommand($sqlCommand, $mdtSQLConnection)
            $null = $cmd.ExecuteScalar()

            Write-Output "Removed computer with ID [$Id]."
        }
    }
}
