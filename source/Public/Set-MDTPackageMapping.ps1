<#
    .SYNOPSIS
        Modify an existing package mapping.

    .DESCRIPTION
        Modify an existing package mapping in the database.

    .EXAMPLE
        PS C:\> Get-MDTPackageMapping -ARPName 'XYZ' | Set-MDTPackageMapping -Package 'XXX00002:Test'

    .PARAMETER ARPName
        Specifies the name as shown in Add/Remove Programs.

    .PARAMETER Package
        Specifies the name of the package to modify.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function Set-MDTPackageMapping
{
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    [OutputType([System.Data.DataRowCollection])]

    param
    (
        [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
        [System.String]
        $ARPName,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [System.String]
        $Package = $null,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force
    )

    process
    {
        if ($Force -or $PSCmdlet.ShouldProcess($Id))
        {
            $sqlCommand = "UPDATE PackageMapping SET Packages = '$Package' WHERE ARPName = '$ARPName'"
            Write-Verbose -Message "Issuing command: $sqlCommand"
            $settingsCmd = New-Object -TypeName System.Data.SqlClient.SqlCommand($sqlCommand, $mdtSQLConnection)
            $null = $settingsCmd.ExecuteScalar()

            Write-Output "Updated package mapping for [$ARPName]."
            return Get-MDTPackageMapping -ARPName $ARPName
        }
    }
}
