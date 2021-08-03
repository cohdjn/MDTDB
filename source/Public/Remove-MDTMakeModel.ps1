<#
    .SYNOPSIS
        Remove an existing make and model.

    .DESCRIPTION
        Remove an existing make and model from the database.

    .EXAMPLE
        PS C:\> Get-MDTMakeModel -Make 'VMware' -Model 'Virtual Machine' | Remove-MDTMakeModel

    .PARAMETER Id
        Specifies the ID of the make and model to remove.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function Remove-MDTMakeModel
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
            $sqlCommand = "DELETE FROM MakeModelIdentity WHERE ID = $Id"

            Write-Verbose -Message "Issuing command: $sqlCommand"
            $cmd = New-Object -TypeName System.Data.SqlClient.SqlCommand($sqlCommand, $mdtSQLConnection)
            $null = $cmd.ExecuteScalar()

            Write-Output "Removed make/model with ID [$Id]."
        }
    }
}
