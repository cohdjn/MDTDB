<#
    .SYNOPSIS
        Remove an existing package mapping.

    .DESCRIPTION
        Remove an existing package mapping from the database.

    .EXAMPLE
        PS C:\> Get-MDTPackageMapping -ARPName 'XYZ' | Remove-MDTPackageMapping

    .PARAMETER ARPName
        Specifies the name as shown in Add/Remove Programs.

    .PARAMETER Package
        Specifies the name of the package to remove.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function Remove-MDTPackageMapping
{
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]

    param
    (
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [System.String]
        $ARPName = '',

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [System.String]
        $Package = '',

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force
    )

    process
    {
        if ($ARPName -eq '' -and $Package -eq '')
        {
            $target = 'All Packages'
            $sqlCommand = "DELETE FROM PackageMapping"
        }
        elseif ($ARPName -ne '' -and $Package -ne '')
        {
            $target = "$ARPName $Package"
            $sqlCommand = "DELETE FROM PackageMapping WHERE ARPName = '$ARPName' AND Packages = '$Package'"
        }
        elseif ($ARPName -ne '')
        {
            $target = $ARPName
            $sqlCommand = "DELETE FROM PackageMapping WHERE ARPName = '$ARPName'"
        }
        else
        {
            $target = $Package
            $sqlCommand = "DELETE FROM PackageMapping WHERE Packages = '$Package'"
        }

        if ($Force -or $PSCmdlet.ShouldProcess($target))
        {
            Write-Verbose -Message "Issuing command: $sqlCommand"
            $settingsCmd = New-Object -TypeName System.Data.SqlClient.SqlCommand($sqlCommand, $mdtSQLConnection)
            $null = $settingsCmd.ExecuteScalar()

            Write-Output "Removed package mapping for target [$target]."
        }
    }
}
