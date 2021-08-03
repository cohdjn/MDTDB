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
        GoodId = '5'
        BadId  = @(1,2,3)

        GoodType = 'C'
        BadType  = 'Z'

        GoodTable = 'Settings_Administrators'
        BadTable  = 'Settings_SuperEvilAdministrators'

        GoodColumn = 'ID'
        BadColumn  = @(1,2,3)
    }

    class mockSqlDataAdapter
    {
        [System.String]
        $SqlCommand

        [System.String]
        $SqlConnection
    }

    Describe Get-MDTArray {
        Mock -CommandName New-Object `
            -MockWith { New-Object -TypeName mockSqlDataAdapter } `
            -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlDataAdapter' }

        Mock -CommandName Get-MDTData -MockWith { return $dataSet }

        Context 'When bad parameters are passed' {
            It 'Should throw when Id is not a string' {
                { Get-MDTArray -Id $mocks.BadId -Type $mocks.GoodType -Table $mocks.GoodTable -Column $mocks.GoodColumn } | Should -Throw
            }

            It 'Should throw when Type is not a valid code' {
                { Get-MDTArray -Id $mocks.GoodId -Type $mocks.BadType -Table $mocks.GoodTable -Column $mocks.GoodColumn } | Should -Throw
            }

            It 'Should throw when Table is not a valid name' {
                { Get-MDTArray -Id $mocks.GoodId -Type $mocks.GoodType -Table $mocks.BadTable -Column $mocks.GoodColumn } | Should -Throw
            }

            It 'Should throw when Column is not a string' {
                { Get-MDTArray -Id $mocks.GoodId -Type $mocks.GoodType -Table $mocks.GoodTable -Column $mocks.BadColumn } | Should -Throw
            }
        }

        Context 'When good parameters are passed' {
            It 'Should not throw any errors' {
                { Get-MDTArray -Id $mocks.GoodId -Type $mocks.GoodType -Table $mocks.GoodTable -Column $mocks.GoodColumn } | Should -Not -Throw
            }

            It 'Should return valid data from the database' {
                $returnData = Get-MDTArray -Id $mocks.GoodId -Type $mocks.GoodType -Table $mocks.GoodTable -Column $mocks.GoodColumn
                ($returnData | Measure-Object).Count | Should -Be 1
            }
        }
    }
}
