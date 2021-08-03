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

    $mocks = @{
        Id = '1'
    }

    class mockSqlDataAdapter
    {
        [System.String]
        $SqlCommand

        [System.String]
        $SqlConnection
    }

    Describe Get-MDTComputerApplication {
        Mock -CommandName New-Object `
            -MockWith { New-Object -TypeName mockSqlDataAdapter } `
            -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlDataAdapter' }

        Mock -CommandName Get-MDTData -MockWith { return $dataSet }

        It 'Should not throw any errors' {
            { Get-MDTComputerApplication -Id $mocks.Id } | Should -Not -Throw
        }

        It 'Should return valid data from the database' {
            $returnData = Get-MDTComputerApplication -Id $mocks.Id
            ($returnData | Measure-Object).Count | Should -Be 1
        }
    }
}
