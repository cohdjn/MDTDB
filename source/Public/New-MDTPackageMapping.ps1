<#
    .SYNOPSIS
        Create a new package mapping.

    .DESCRIPTION
        Create a new package mapping in the database.

    .EXAMPLE
        PS C:\> New-MDTPackageMapping -ARPName 'XYZ' -Package 'XXX00001:Test'

    .PARAMETER ARPName
        Specifies the name as shown in Add/Remove Programs.

    .PARAMETER Package
        Specifies the name of the package to be added.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function New-MDTPackageMapping
{
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
    [OutputType([System.Data.DataRowCollection])]

    param
    (
        [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
        [System.String]
        $ARPName,

        [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
        [System.String]
        $Package,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force
    )

    process
    {
        if ($Force -or $PSCmdlet.ShouldProcess($ARPName))
        {
            $sqlCommand = "INSERT INTO PackageMapping (ARPName, Packages) VALUES ('$ARPName','$Package')"

            Write-Verbose -Message "Issuing command: $sqlCommand"
            $identityCmd = New-Object -TypeName System.Data.SqlClient.SqlCommand($sqlCommand, $mdtSQLConnection)
            $identity = $identityCmd.ExecuteScalar()
            Write-Output "New package mapping added with ID [$identity]."

            return Get-MDTPackageMapping -ARPName $ARPName
        }
    }
}
