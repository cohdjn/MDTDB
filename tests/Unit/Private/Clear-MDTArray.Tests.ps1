$ProjectPath = "$PSScriptRoot\..\..\.." | Convert-Path
$ProjectName = ((Get-ChildItem -Path $ProjectPath\*\*.psd1).Where{
        ($_.Directory.Name -match 'source|src' -or $_.Directory.Name -eq $_.BaseName) -and
        $(try { Test-ModuleManifest $_.FullName -ErrorAction Stop } catch { $false } )
    }).BaseName


Import-Module $ProjectName

InModuleScope $ProjectName {
    $mocks = @{
        GoodId = '5'
        BadId  = @(1,2,3)

        GoodType = 'C'
        BadType  = 'Z'

        GoodTable = 'Settings_Administrators'
        BadTable  = 'Settings_SuperEvilAdministrators'
    }

    Describe Clear-MDTArray {
        class mockSqlCommandObject
        {
            [System.String]
            $SqlCommand

            [System.String]
            $SqlConnection

            [void]
            ExecuteScalar() { }
        }

        Context 'When bad parameters are passed' {
            It 'Should throw when Id is not a string' {
                { Clear-MDTArray -Id $mocks.BadId -Type $mocks.GoodType -Table $mocks.GoodTable -Force } | Should -Throw
            }

            It 'Should throw when Type is not a valid code' {
                { Clear-MDTArray -Id $mocks.GoodId -Type $mocks.BadType -Table $mocks.GoodTable -Force } | Should -Throw
            }

            It 'Should throw when Table is not a valid table' {
                { Clear-MDTArray -Id $mocks.GoodId -Type $mocks.GoodType -Table $mocks.BadTable -Force } | Should -Throw
            }
        }

        Context 'When good parameters are passed' {
            Mock -CommandName New-Object `
                -MockWith { New-Object -TypeName mockSqlCommandObject } `
                -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlCommand' }

            It 'Should not throw any errors' {
                { Clear-MDTArray -Id $mocks.GoodId -Type $mocks.GoodType -Table $mocks.GoodTable -Force } | Should -Not -Throw
            }

            It 'Should return nothing' {
                $returnData = Clear-MDTArray -Id $mocks.GoodId -Type $mocks.GoodType -Table $mocks.GoodTable -Force
                $returnData | Should -BeNullOrEmpty
            }
        }
    }
}
