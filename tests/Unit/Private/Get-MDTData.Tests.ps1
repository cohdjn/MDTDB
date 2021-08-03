$ProjectPath = "$PSScriptRoot\..\..\.." | Convert-Path
$ProjectName = ((Get-ChildItem -Path $ProjectPath\*\*.psd1).Where{
        ($_.Directory.Name -match 'source|src' -or $_.Directory.Name -eq $_.BaseName) -and
        $(try { Test-ModuleManifest $_.FullName -ErrorAction Stop } catch { $false } )
    }).BaseName


Import-Module $ProjectName

InModuleScope $ProjectName {
    $testTable = New-Object -TypeName System.Data.DataTable
    $testTable.Columns.Add('Test')
    $testTable.Rows.Add('TEST123')

    $dataSet = New-Object -TypeName System.Data.DataSet
    $dataSet.Tables.Add($testTable)

    class mockSqlDataAdapter
    {
        [System.String]
        $SqlCommand

        [System.String]
        $SqlConnection

        [void]
        Fill([System.Data.DataSet]$DataSet, [System.String]$Table) { }
    }

    Describe Get-MDTData {
        Mock -CommandName New-Object `
            -MockWith { New-Object -TypeName mockSqlDataAdapter } `
            -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlDataAdapter' }

        It 'Should not throw under any circumstances' {
            $sqlCommand = 'SELECT 1'
            $adapter = New-Object -TypeName System.Data.SqlClient.SqlDataAdapter($sqlCommand, $mdtSQLConnection)
            { Get-MDTData -Adapter $adapter -Table 'master' } | Should -Not -Throw
        }
    }
}
