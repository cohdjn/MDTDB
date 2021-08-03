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
        Name = 'Las Vegas'
    }

    class mockSqlDataAdapter
    {
        [System.String]
        $SqlCommand

        [System.String]
        $SqlConnection
    }

    Describe Get-MDTLocation {
        Mock -CommandName New-Object `
            -MockWith { New-Object -TypeName mockSqlDataAdapter } `
            -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlDataAdapter' }

        Mock -CommandName Get-MDTData -MockWith { return $dataSet }

        It 'Should return valid data without any arguments' {
            $returnData = Get-MDTLocation
            ($returnData | Measure-Object).Count | Should -Be 1
        }

        It 'Should return valid detailed data without any arguments' {
            $returnData = Get-MDTLocation -Detail
            ($returnData | Measure-Object).Count | Should -Be 1
        }

        It 'Should return valid data with the Id argument' {
            $returnData = Get-MDTLocation -Id $mocks.Id
            ($returnData | Measure-Object).Count | Should -Be 1
        }

        It 'Should return valid detailed data with the Id argument' {
            $returnData = Get-MDTLocation -Id $mocks.Id -Detail
            ($returnData | Measure-Object).Count | Should -Be 1
        }

        It 'Should return valid data with the Name argument' {
            $returnData = Get-MDTLocation -Name $mocks.Name
            ($returnData | Measure-Object).Count | Should -Be 1
        }

        It 'Should return valid detailed data with the Name argument' {
            $returnData = Get-MDTLocation -Name $mocks.Name -Detail
            ($returnData | Measure-Object).Count | Should -Be 1
        }
    }
}
