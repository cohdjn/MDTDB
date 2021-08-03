<#
    .SYNOPSIS
        Modify the settings of an existing computer entry.

    .DESCRIPTION
        Modify the settings of an existing computer entry.

    .EXAMPLE
        PS C:\> Get-MDTComputer -AssetTag '789XYZ' | Set-MDTComputer -Settings @{ComputerName="BLAH"}

    .PARAMETER Id
        Specifies the ID to modify.

    .PARAMETER Settings
        Specifies the settings to add to the computer.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function Set-MDTComputer
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
        $sqlCommand = 'UPDATE Settings SET '
        foreach ($setting in $Settings.GetEnumerator())
        {
            $sqlCommand += "$($setting.Key) = '$($setting.Value)', "
        }
        $sqlCommand = $sqlCommand.TrimEnd(', ')
        $sqlCommand += " WHERE ID = $Id AND Type = 'C'"

        if ($Force -or $PSCmdlet.ShouldProcess($Id))
        {
            Write-Verbose "Issuing command: $sqlCommand"
            $settingsCmd = New-Object -TypeName System.Data.SqlClient.SqlCommand($sqlCommand, $mdtSQLConnection)
            $null = $settingsCmd.ExecuteScalar()

            Write-Output "Updated computer with ID [$Id]."
            return Get-MDTComputer -Id $Id
        }
    }
}
