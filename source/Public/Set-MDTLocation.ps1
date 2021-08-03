<#
    .SYNOPSIS
        Modify the settings of an existing location.

    .DESCRIPTION
        Modify the settings of an existing location.

    .EXAMPLE
        PS C:\> Get-MDTLocation -Name 'Portland' | Set-MDTLocation -Settings @{ComputerName="BLAH"}

    .PARAMETER Id
        Specifies the ID to modify.

    .PARAMETER Gateways
        Specifies the gateways to add to the location.

    .PARAMETER Settings
        Specifies the settings to add to the location.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function Set-MDTLocation
{
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]

    param
    (
        [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
        [System.String]
        $Id,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [ValidateScript({$PSItem -match [System.Net.IPAddress]$PSItem})]
        [System.Array]
        $Gateways = $null,

        [Parameter()]
        [System.Collections.Hashtable]
        $Settings = $null,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force
    )

    process
    {
        if ($Force -or $PSCmdlet.ShouldProcess($Id))
        {
            $changes = $false
            if ($null -ne $Settings)
            {
                $changes = $true
                $sqlCommand = "UPDATE Settings SET "
                foreach ($setting in $Settings.GetEnumerator())
                {
                    $sqlCommand += "$($setting.Key) = '$($setting.Value)', "
                }
                $sqlCommand = $sqlCommand.TrimEnd(', ')
                $sqlCommand += " WHERE ID = $Id AND Type = 'L'"

                Write-Verbose -Message "Issuing command: $sqlCommand"
                $settingsCmd = New-Object -TypeName System.Data.SqlClient.SqlCommand($sqlCommand, $mdtSQLConnection)
                $null = $settingsCmd.ExecuteScalar()
            }

            if ($null -ne $Gateways)
            {
                $changes = $true
                # Delete the existing gateways first.
                $sqlCommand = "DELETE FROM LocationIdentity_DefaultGateway WHERE ID = $Id"
                Write-Verbose -Message "Issuing command: $sqlCommand"
                $cmd = New-Object -TypeName System.Data.SqlClient.SqlCommand($sqlCommand, $mdtSQLConnection)
                $null = $cmd.ExecuteScalar()

                # Now insert the specified values.
                foreach ($gateway in $Gateways)
                {
                    $sqlCommand = "INSERT INTO LocationIdentity_DefaultGateway (ID, DefaultGateway) VALUES ($Id, '$gateway')"
                    Write-Verbose -Message "Issuing command: $sqlCommand"
                    $settingsCmd = New-Object -TypeName System.Data.SqlClient.SqlCommand($sqlCommand, $mdtSQLConnection)
                    $null = $settingsCmd.ExecuteScalar()
                }
            }

            if ($changes)
            {
                Write-Output "Updated location with ID [$Id]."
            }
            else
            {
                Write-Output "No changes were made to location with ID [$Id]."
            }

            return Get-MDTLocation -Id $Id
        }
    }
}
