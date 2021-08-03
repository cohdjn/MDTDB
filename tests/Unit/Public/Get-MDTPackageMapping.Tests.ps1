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
        ARPName = 'My Application'
        Package = 'My Package'
    }

    class mockSqlDataAdapter
    {
        [System.String]
        $SqlCommand

        [System.String]
        $SqlConnection
    }

    Describe Get-MDTPackageMapping {
        Mock -CommandName New-Object `
            -MockWith { New-Object -TypeName mockSqlDataAdapter } `
            -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlDataAdapter' }

        Mock -CommandName Get-MDTData -MockWith { return $dataSet }

        It 'Should return valid data without any arguments' {
            $returnData = Get-MDTPackageMapping
            ($returnData | Measure-Object).Count | Should -Be 1
        }

        It 'Should return valid data with the ARPName argument' {
            $returnData = Get-MDTPackageMapping -ARPName $mocks.ARPName
            ($returnData | Measure-Object).Count | Should -Be 1
        }

        It 'Should return valid data with the Package argument' {
            $returnData = Get-MDTPackageMapping -Package $mocks.Package
            ($returnData | Measure-Object).Count | Should -Be 1
        }

        It 'Should return valid data with all arguments present' {
            $returnData = Get-MDTPackageMapping -ARPName $mocks.ARPName -Package $mocks.Package
            ($returnData | Measure-Object).Count | Should -Be 1
        }
    }
}
