<#
    .SYNOPSIS
        Create a new location.

    .DESCRIPTION
        Create a new location in the MDT database.

    .EXAMPLE
        PS C:\> New-MDTLocation -Name 'Portland' -Gateways @('1.2.3.4','2.3.4.5') -Settings @{SkipWizard="YES"; DoCapture="YES"}

    .PARAMETER Name
        Specifies the name of the new location.

    .PARAMETER Gateways
        Specifies the gateways of the new location.

    .PARAMETER Settings
        Specifies the settings of the new location.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function New-MDTLocation
{
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
    [OutputType([System.Data.DataRowCollection])]

    param
    (
        [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [ValidateScript({$PSItem -match [System.Net.IPAddress]$PSItem})]
        [System.Array]
        $Gateways,

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
            $sqlCommand = "INSERT INTO LocationIdentity (Location) VALUES ('$Name') SELECT @@IDENTITY"

            Write-Verbose -Message "Issuing command: $sqlCommand"
            $identityCmd = New-Object -TypeName System.Data.SqlClient.SqlCommand($sqlCommand, $mdtSQLConnection)
            $identity = $identityCmd.ExecuteScalar()

            if ($PSBoundParameters.ContainsKey('Gateways'))
            {
                $null = Set-MDTLocation -Id $identity -Gateways $Gateways
            }

            if ($PSBoundParameters.ContainsKey('Settings'))
            {
                $settingsColumns = $settings.Keys -join ','
                $settingsValues = $settings.Values -join "','"

                $sqlCommand = "INSERT INTO Settings (Type, ID, $settingsColumns) VALUES ('L', $identity, '$settingsValues')"

                Write-Verbose -Message "Issuing command: $sqlCommand"
                $settingsCmd = New-Object -TypeName System.Data.SqlClient.SqlCommand($sqlCommand, $mdtSQLConnection)
                $null = $settingsCmd.ExecuteScalar()
            }

            Write-Output "New location added with ID [$identity]."

            return Get-MDTLocation -Id $identity
        }
    }
}
