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

        GoodColumn = 'ID'
        BadColumn = @(1,2,3)

        GoodArray = @(1,2,3)
        BadArray = 'BadArray'
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

    Describe Set-MDTArray {
        Context 'When bad parameters are passed' {
            It 'Should throw when Id is not a string' {
                { Set-MDTArray `
                    -Id $mocks.BadId `
                    -Type $mocks.GoodType `
                    -Table $mocks.GoodTable `
                    -Column $mocks.GoodColumn `
                    -Array $mocks.GoodArray `
                    -Force } | Should -Throw
            }

            It 'Should throw when Type is not a valid code' {
                { Set-MDTArray `
                    -Id $mocks.GoodId `
                    -Type $mocks.BadType `
                    -Table $mocks.GoodTable `
                    -Column $mocks.GoodColumn `
                    -Array $mocks.GoodArray `
                    -Force } | Should -Throw
            }

            It 'Should throw when Table is not a valid name' {
                { Set-MDTArray `
                    -Id $mocks.GoodId `
                    -Type $mocks.GoodType `
                    -Table $mocks.BadTable `
                    -Column $mocks.GoodColumn `
                    -Array $mocks.GoodArray `
                    -Force } | Should -Throw
            }

            It 'Should throw when Column is not a string' {
                { Set-MDTArray `
                    -Id $mocks.GoodId `
                    -Type $mocks.GoodType `
                    -Table $mocks.GoodTable `
                    -Column $mocks.BadColumn `
                    -Array $mocks.GoodArray `
                    -Force } | Should -Throw

            }
            It 'Should throw when Array is not an array' {
                { Set-MDTArray `
                    -Id $mocks.GoodId `
                    -Type $mocks.GoodType `
                    -Table $mocks.GoodTable `
                    -Column $mocks.GoodColumn `
                    -Array $mocks.BadArray `
                    -Force } | Should -Throw
            }
        }

        Context 'When good parameters are passed' {
            Mock -CommandName Clear-MDTArray

            Mock -CommandName New-Object `
                -MockWith { New-Object -TypeName mockSqlCommandObject } `
                -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlCommand' }

            It 'Should not throw any errors' {
                { Set-MDTArray `
                    -Id $mocks.GoodId `
                    -Type $mocks.GoodType `
                    -Table $mocks.GoodTable `
                    -Column $mocks.GoodColumn `
                    -Array $mocks.GoodArray `
                    -Force } | Should -Not -Throw
            }

            It 'Should return nothing' {
                $returnData = Set-MDTArray `
                    -Id $mocks.GoodId `
                    -Type $mocks.GoodType `
                    -Table $mocks.GoodTable `
                    -Column $mocks.GoodColumn `
                    -Array $mocks.GoodArray `
                    -Force
                $returnData | Should -BeNullOrEmpty
            }
        }
    }
}
