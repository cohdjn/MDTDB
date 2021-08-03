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

    $goodMocks = @{
        ARPName = 'Pester Test'
        Package = 'Pester Package'
    }

    class mockSqlCommandObject
    {
        [System.String]
        $SqlCommand

        [System.String]
        $SqlConnection

        [void]
        ExecuteScalar() { }
    }

    Describe Set-MDTPackageMapping {
        Mock -CommandName Get-MDTPackageMapping

        Mock -CommandName New-Object `
            -MockWith { New-Object -TypeName mockSqlCommandObject } `
            -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlCommand' }

        It 'Should not throw under any circumstances' {
            { Set-MDTPackageMapping -ARPName $goodMocks.ARPName -Package $goodMocks.Package -Force } | Should -Not -Throw
        }

        It 'Should return valid data' {
            Mock -CommandName Write-Output
            Mock -CommandName Get-MDTPackageMapping -MockWith { return $dataSet.Tables[0].Rows }
            
            $updatePackage = Set-MDTPackageMapping -ARPName $goodMocks.ARPName -Package $goodMocks.Package -Force
            ($updatePackage | Measure-Object).Count | Should -Be 1
        }

        It 'Should output something to the console' {
            Mock -CommandName Write-Output
            Mock -CommandName Get-MDTPackageMapping -MockWith { return $dataSet.Tables[0].Rows }

            Set-MDTPackageMapping -ARPName $goodMocks.ARPName -Package $goodMocks.Package -Force
            Assert-MockCalled -CommandName Write-Output -Exactly -Times 1 -Scope It
        }
    }
}
