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
        Id   = '1'
        Make = 'Sooper Dooper Computer Inc'
        Model = 'Kelly LeBrock'
    }

    class mockSqlDataAdapter
    {
        [System.String]
        $SqlCommand

        [System.String]
        $SqlConnection
    }

    Describe Get-MDTMakeModel {
        Mock -CommandName New-Object `
            -MockWith { New-Object -TypeName mockSqlDataAdapter } `
            -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlDataAdapter' }

        Mock -CommandName Get-MDTData -MockWith { return $dataSet }

        It 'Should return valid data without any arguments' {
            $returnData = Get-MDTMakeModel
            ($returnData | Measure-Object).Count | Should -Be 1
        }

        It 'Should return valid data with the Id argument' {
            $returnData = Get-MDTMakeModel -Id $mocks.Id
            ($returnData | Measure-Object).Count | Should -Be 1
        }

        It 'Should return valid data with the Make argument' {
            $returnData = Get-MDTMakeModel -Make $mocks.Make
            ($returnData | Measure-Object).Count | Should -Be 1
        }

        It 'Should return valid data with the Model argument' {
            $returnData = Get-MDTMakeModel -Model $mocks.Model
            ($returnData | Measure-Object).Count | Should -Be 1
        }

        It 'Should return valid data with Make and Model arguments' {
            $returnData = Get-MDTMakeModel -Make $mocks.Make -Model $mocks.Model
            ($returnData | Measure-Object).Count | Should -Be 1
        }
    }
}
