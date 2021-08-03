<#
    .SYNOPSIS
        Modify the settings of an existing make and model.

    .DESCRIPTION
        Modify the settings of an existing make and model.

    .EXAMPLE
        PS C:\> Get-MDTMakeModel -Make 'Microsoft' -Model 'Virtual Machine' | Set-MDTMakeModel -settings @{ComputerName="BLAH"}

    .PARAMETER Id
        Specifies the ID to modify.

    .PARAMETER Settings
        Specifies the settings to add to the make and model.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function Set-MDTMakeModel
{
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]

    param
    (
        [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $Settings,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force
    )

    process
    {
        if ($Force -or $PSCmdlet.ShouldProcess($Id))
        {
            $sqlCommand = 'UPDATE Settings SET '
            foreach ($setting in $Settings.GetEnumerator())
            {
                $sqlCommand += "$($setting.Key) = '$($setting.Value)', "
            }
            $sqlCommand = $sqlCommand.TrimEnd(', ')
            $sqlCommand += "WHERE ID = $Id AND Type = 'M'"

            Write-Verbose -Message "Issuing command: $sqlCommand"
            $settingsCmd = New-Object -TypeName System.Data.SqlClient.SqlCommand($sqlCommand, $mdtSQLConnection)
            $null = $settingsCmd.ExecuteScalar()

            Write-Output "Updated make/model with ID [$Id]."
            Get-MDTMakeModel -Id $Id
        }
    }
}
