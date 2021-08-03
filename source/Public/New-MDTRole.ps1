<#
    .SYNOPSIS
        Create a new role.

    .DESCRIPTION
        Create a new role object in the MDT database.

    .EXAMPLE
        PS C:\> New-MDTRole -Name 'Laptops' -Settings @{SkipWizard="YES"; DoCapture="YES"}

    .PARAMETER Name
        Specifies the name of the role.

    .PARAMETER Settings
        Specifies the settings of the new role.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function New-MDTRole
{
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
    [OutputType([System.Data.DataRowCollection])]

    param
    (
        [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory=$true)]
        [System.String]
        $Name,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [System.Collections.Hashtable]
        $Settings,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force
    )

    process
    {
        if ($Force -or $PSCmdlet.ShouldProcess($Name))
        {
            $sqlCommand = "INSERT INTO RoleIdentity (Role) VALUES ('$name') SELECT @@IDENTITY"

            Write-Verbose -Message "Issuing command: $sqlCommand"
            $identityCmd = New-Object -TypeName System.Data.SqlClient.SqlCommand($sqlCommand, $mdtSQLConnection)
            $identity = $identityCmd.ExecuteScalar()

            if ($PSBoundParameters.ContainsKey('Settings'))
            {
                # Insert the settings row, adding the values as specified in the hash table
                $settingsColumns = $settings.Keys -join ','
                $settingsValues = $settings.Values -join "','"
                $sqlCommand = "INSERT INTO Settings (Type, ID, $settingsColumns) VALUES ('R', $identity, '$settingsValues')"

                Write-Verbose -Message "Issusing command: $sqlCommand"
                $settingsCmd = New-Object -TypeName System.Data.SqlClient.SqlCommand($sqlCommand, $mdtSQLConnection)
                $null = $settingsCmd.ExecuteScalar()
            }

            Write-Output "New role added with ID [$identity]."

            return Get-MDTRole -Id $identity
        }
    }
}
