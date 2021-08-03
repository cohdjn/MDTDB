<#
    .SYNOPSIS
        Modify the settings of an existing role.

    .DESCRIPTION
        Modify the settings of an existing role.

    .EXAMPLE
        PS C:\> Get-MDTRole -Name 'Laptops' | Set-MDTRole -Settings @{ComputerName="BLAH"}

    .PARAMETER Id
        Specifies the ID to modify.

    .PARAMETER Settings
        Specifies the settings to add to the role.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function Set-MDTRole
{
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    [OutputType([System.Data.DataRowCollection])]

    param
    (
        [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory =$true)]
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
            $sqlCommand += " WHERE ID = $Id AND Type = 'R'"

            Write-Verbose -Message "Issuing command: $sqlCommand"
            $settingsCmd = New-Object -TypeName System.Data.SqlClient.SqlCommand($sql, $mdtSQLConnection)
            $null = $settingsCmd.ExecuteScalar()

            Write-Output "Updated role with ID [$Id]."
            return Get-MDTRole -Id $Id
        }
    }
}
