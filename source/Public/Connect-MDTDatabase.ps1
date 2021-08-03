<#
    .SYNOPSIS
        Establish a connection to an MDT database.

    .DESCRIPTION
        Establish a connection to an MDT database.

    .EXAMPLE
        PS C:\> Connect-MDTDatabase -SqlServer MYSERVER -Instance SQLExpress -Database BDDAdminDB

    .PARAMETER DrivePath
        Specifies the drive path if one is already established.

    .PARAMETER SqlServer
        Specifies the name of the SQL Server hosting the MDT database.

    .PARAMETER Instance
        Specifies the instance name hosting the MDT database.

    .PARAMETER Database
        Specifies the name of the MDT database.
#>
function Connect-MDTDatabase
{
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '')]

    param
    (
        [Parameter(Position = 1)]
        [System.String]
        $DrivePath = '',

        [Parameter()]
        [System.String]
        $SqlServer = '',

        [Parameter()]
        [System.String]
        $Instance = '',

        [Parameter()]
        [System.String]
        $Database
    )

    if ($DrivePath -eq '' -and $SqlServer -eq '')
    {
        throw 'You must specify either DrivePath or SqlServer to connect.'
    }

    if ($null -ne $mdtDatabase)
    {
        Clear-Variable -Name mdtDatabase -Force
    }

    # If a drive path is specified, use PowerShell to build the connection string.
    # Otherwise, build it from the other parameters.
    if ($DrivePath -ne '')
    {
        $mdtProperties = Get-ItemProperty -Path $DrivePath
        $mdtSQLConnectString = "Server=$($mdtProperties.'Database.SQLServer')"

        if ($mdtProperties.'Database.Instance' -ne '')
        {
            $mdtSQLConnectString = "$mdtSQLConnectString\$($mdtProperties.'Database.Instance')"
        }

        $mdtSQLConnectString = "$mdtSQLConnectString; Database='$($mdtProperties.'Database.Name')'; Integrated Security=true;"
    }
    else
    {
        if ($Database -eq '')
        {
            throw 'You must specify the name of the database.'
        }

        $mdtSQLConnectString = "Server=$($SqlServer)"

        if ($Instance -ne '')
        {
            $mdtSQLConnectString = "$mdtSQLConnectString\$Instance"
        }

        $mdtSQLConnectString = "$mdtSQLConnectString; Database='$Database'; Integrated Security=true;"
    }

    Write-Verbose -Message "Connecting with connection string: [$mdtSQLConnectString]"
    $global:mdtSQLConnection = New-Object -TypeName System.Data.SqlClient.SqlConnection
    $global:mdtSQLConnection.ConnectionString = $mdtSQLConnectString
    try
    {
        $global:mdtSQLConnection.Open()
        Write-Output "Connected to SQL Server [$SqlServer] and database [$Database].`n"
    }
    catch {
        throw 'An error occurred trying to connect to the SQL Server.  Please review your settings.'
    }
}
