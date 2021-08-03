<#
    .SYNOPSIS
        Create a new make and model.

    .DESCRIPTION
        Create a new make and model in the database.

    .EXAMPLE
        PS C:\> New-MDTMakeModel -Make 'Microsoft' -Model 'Virtual Machine' -Settings @{SkipWizard="YES"; DoCapture="YES"}

    .PARAMETER Make
        Specifies the manufacturer name. Should match what is returned from a WMI query.

    .PARAMETER Model
        Specifies the model name. Should match what i returned from a WMI query.

    .PARAMETER Settings
        Specifies the settings of the new make and model.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function New-MDTMakeModel
{
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
    [OutputType([System.Data.DataRowCollection])]

    param
    (
        [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
        [System.String]
        $Make,

        [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
        [System.String]
        $Model,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [System.Collections.Hashtable]
        $Settings,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force
    )

    process
    {
        if ($Force -or $PSCmdlet.ShouldProcess("$Make $Model"))
        {
            $sqlCommand = "INSERT INTO MakeModelIdentity (Make, Model) VALUES ('$make', '$model') SELECT @@IDENTITY"

            Write-Verbose -Message "Issuing command: $sqlCommand"
            $identityCmd = New-Object System.Data.SqlClient.SqlCommand($sqlCommand, $mdtSQLConnection)
            $identity = $identityCmd.ExecuteScalar()

            if ($PSBoundParameters.ContainsKey('Settings'))
            {
                # Insert the settings row, adding the values as specified in the hash table
                $settingsColumns = $Settings.Keys -join ","
                $settingsValues = $Settings.Values -join "','"
                $sqlCommand = "INSERT INTO Settings (Type, ID, $settingsColumns) VALUES ('M', $identity, '$settingsValues')"

                Write-Verbose -Message "Issuing command: $sqlCommand"
                $settingsCmd = New-Object System.Data.SqlClient.SqlCommand($sqlCommand, $mdtSQLConnection)
                $null = $settingsCmd.ExecuteScalar()
            }

            Write-Output "New computer make/model with ID [$identity]."

            return Get-MDTMakeModel -Id $identity
        }
    }
}
