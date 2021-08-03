<#
    .SYNOPSIS
        Create a new computer entry.

    .DESCRIPTION
        Create a new computer entry in the database.

    .EXAMPLE
        PS C:\> New-MDTComputer -AssetTag '789XYZ' -Settings @{SkipWizard="YES"; DoCapture="YES"}

    .PARAMETER AssetTag
        Specifies the asset tag of the new computer.

    .PARAMETER MacAddress
        Specifies the MAC address of the new computer.

    .PARAMETER SerialNumber
        Specifies the serial number of the new computer.

    .PARAMETER Uuid
        Specifies the UUID of the new computer.

    .PARAMETER Description
        Specifies the description of the new computer.

    .PARAMETER Settings
        Specifies the settings of the new computer.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function New-MDTComputer
{
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
    [OutputType([System.Data.DataRowCollection])]

    param
    (
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [System.String]
        $AssetTag,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [ValidatePattern('^([0-9a-fA-F][0-9a-fA-F]:){5}([0-9a-fA-F][0-9a-fA-F])$')]
        [System.String]
        $MacAddress,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [System.String]
        $SerialNumber,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [ValidatePattern('^[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}$')]
        [System.String]
        $Uuid,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [System.String]
        $Description,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [System.Collections.Hashtable]
        $Settings,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force
    )

    process
    {
        if ($PSBoundParameters.ContainsKey('AssetTag'))
        {
            $target = $AssetTag
        }
        elseif ($PSBoundParameters.ContainsKey('MacAddress'))
        {
            $target = $MacAddress
        }
        elseif ($PSBoundParameters.ContainsKey('SerialNumber'))
        {
            $target = $SerialNumber
        }
        elseif ($PSBoundParameters.ContainsKey('Uuid'))
        {
            $target = $Uuid
        }
        else
        {
            throw 'You must specify at least one of the following: AssetTag, MacAddress, SerialNumber, Uuid.'
        }

        if ($Force -or $PSCmdlet.ShouldProcess($target))
        {
            # Insert a new computer row and get the identity result.
            $sqlCommand = 'INSERT INTO ComputerIdentity (AssetTag, SerialNumber, MacAddress, UUID, Description) ' +
                "VALUES ('$AssetTag', '$SerialNumber', '$MacAddress', '$Uuid', '$Description') SELECT @@IDENTITY"

            Write-Verbose -Message "Issuing command: $sqlCommand"
            $identityCmd = New-Object -TypeName System.Data.SqlClient.SqlCommand($sqlCommand, $mdtSQLConnection)
            $identity = $identityCmd.ExecuteScalar()

            # Insert the settings row, adding the values as specified in the hash table.
            $settingsColumns = $Settings.Keys -join ','
            $settingsValues = $Settings.Values -join "','"
            $sqlCommand = "INSERT INTO Settings (Type, ID, $settingsColumns) VALUES ('C', $identity, '$settingsValues')"

            Write-Verbose -Message "Issuing command: $sqlCommand"
            $settingsCmd = New-Object -TypeName System.Data.SqlClient.SqlCommand($sqlCommand, $mdtSQLConnection)
            $null = $settingsCmd.ExecuteScalar()
            Write-Output "New computer added with ID [$identity]."

            return Get-MDTComputer -Id $identity
        }
    }
}
