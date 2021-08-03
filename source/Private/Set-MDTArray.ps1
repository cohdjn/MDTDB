<#
    .SYNOPSIS
        Writes data into the MDT SQL database.

    .DESCRIPTION
        Private function that writes data into the SQL database.

    .EXAMPLE
        PS C:\> Set-MDTArray -Id $id -Type 'C' -Table 'Settings_Administrators' -Column 'Administrators' -Array $Administrators

    .PARAMETER Id
        Specifies the ID to be created.

    .PARAMETER Type
        Specifies the type of record to be created.

    .PARAMETER Table
        Specifies the name of the table to create the record(s) in.

    .PARAMETER Column
        Specifies what kind of data is being created.

    .PARAMETER Array
        Specifies the data to be created in the database.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function Set-MDTArray
{
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]

    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [ValidateSet('C', 'L', 'M', 'R')]
        [System.String]
        $Type,

        [Parameter(Mandatory = $true)]
        [ValidateSet('PackageMapping', 'Settings_Administrators', 'Settings_Applications', 'Settings_Packages', 'Settings_Roles')]
        [System.String]
        $Table,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Column,

        [Parameter(Mandatory = $true)]
        [System.Array]
        $Array,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force
    )

    if ($Force -or $PSCmdlet.ShouldProcess($Id))
    {
        $seq = 1
        Clear-MDTArray -Id $Id -Type $Type -Table $Table -Force

        foreach ($item in $Array)
        {
            $sqlCommand = "INSERT INTO $Table (Type, ID, Sequence, $Column) VALUES ('$Type', $Id, $seq, '$item')"

            Write-Verbose -Message "Issuing command: $sqlCommand"
            $cmd = New-Object -TypeName System.Data.SqlClient.SqlCommand($sqlCommand, $mdtSQLConnection)
            $null = $cmd.ExecuteScalar()

            $seq++
        }
    }
}
