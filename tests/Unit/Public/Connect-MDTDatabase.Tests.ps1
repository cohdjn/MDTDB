$ProjectPath = "$PSScriptRoot\..\..\.." | Convert-Path
$ProjectName = ((Get-ChildItem -Path $ProjectPath\*\*.psd1).Where{
        ($_.Directory.Name -match 'source|src' -or $_.Directory.Name -eq $_.BaseName) -and
        $(try { Test-ModuleManifest $_.FullName -ErrorAction Stop } catch { $false } )
    }).BaseName


Import-Module $ProjectName

InModuleScope $ProjectName {
    class mockGoodSqlConnectionObject
    {
        [System.String]
        $ConnectionString

        [void]
        Open() { }
    }

    class mockBadSqlConnectionObject
    {
        [System.String]
        $ConnectionString

        [void]
        Open() { throw }
    }

    Describe Connect-MDTDatabase {
        BeforeEach {
            Clear-Variable -Name mdtSQLConnection -Scope Global -Force -ErrorAction SilentlyContinue
        }

        Context 'When called with insufficient arguments defined' {
            It 'Should throw an error when DrivePath and SqlServer are missing' {
                { Connect-MDTDatabase } | Should -Throw
            }

            It 'Should throw an error when SqlServer is defined and Database is missing' {
                { Connect-MDTDatabase -SqlServer 'localhost' } | Should -Throw
            }
        }

        Context 'When called using DrivePath' {
            It 'Should clear the mdtDatabase variable if it exists' {
                Mock -CommandName Get-ItemProperty -MockWith {
                    return [PSCustomObject]@{
                        'Database.SQLServer' = 'localhost'
                        'Database.Instance' = 'SQLEXPRESS'
                        'Database.Name' = 'MDT'
                    }
                }
    
                Mock -CommandName New-Object `
                    -MockWith { New-Object -TypeName mockGoodSqlConnectionObject } `
                    -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlConnection' }

                $global:mdtDatabase = 'Pester Test'

                {  Connect-MDTDatabase -DrivePath 'DS001:' } | Should -Not -Throw
            }

            It 'Should not throw any errors if the SQL connection succeeds' {
                Mock -CommandName Get-ItemProperty -MockWith {
                    return [PSCustomObject]@{
                        'Database.SQLServer' = 'localhost'
                        'Database.Instance' = 'SQLEXPRESS'
                        'Database.Name' = 'MDT'
                    }
                }
    
                Mock -CommandName New-Object `
                    -MockWith { New-Object -TypeName mockGoodSqlConnectionObject } `
                    -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlConnection' }

                {  Connect-MDTDatabase -DrivePath 'DS001:' } | Should -Not -Throw
            }

            It 'Should create global variable mdtConection on successful connection' {
                Mock -CommandName New-Object `
                    -MockWith { New-Object -TypeName mockGoodSqlConnectionObject } `
                    -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlConnection' }

                Mock -CommandName Get-ItemProperty -MockWith {
                    return [PSCustomObject]@{
                        'Database.SQLServer' = 'localhost'
                        'Database.Instance' = 'SQLEXPRESS'
                        'Database.Name' = 'MDT'
                    }
                }
        
                Connect-MDTDatabase -DrivePath 'DS001:'
                $global:mdtSQLConnection | Should -Not -BeNullOrEmpty
            }

            It 'Should output something to the console' {
                Mock -CommandName Write-Output

                Mock -CommandName New-Object `
                    -MockWith { New-Object -TypeName mockGoodSqlConnectionObject } `
                    -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlConnection' }

                Mock -CommandName Get-ItemProperty -MockWith {
                    return [PSCustomObject]@{
                        'Database.SQLServer' = 'localhost'
                        'Database.Instance' = 'SQLEXPRESS'
                        'Database.Name' = 'MDT'
                    }
                }

                Connect-MDTDatabase -DrivePath 'DS001:'
                Assert-MockCalled -CommandName Write-Output -Exactly -Times 1 -Scope It
            }

            It 'Should throw an error if the SQL connection fails' {
                Mock -CommandName New-Object `
                    -MockWith { New-Object -TypeName mockBadSqlConnectionObject } `
                    -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlConnection' }

                {  Connect-MDTDatabase -DrivePath 'DS001:' } | Should -Throw
            }
        }

        Context 'When called using SqlServer' {
            It 'Should clear the mdtDatabase variable if it exists' {
                Mock -CommandName Get-ItemProperty -MockWith {
                    return [PSCustomObject]@{
                        'Database.SQLServer' = 'localhost'
                        'Database.Instance' = 'SQLEXPRESS'
                        'Database.Name' = 'MDT'
                    }
                }
    
                Mock -CommandName New-Object `
                    -MockWith { New-Object -TypeName mockGoodSqlConnectionObject } `
                    -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlConnection' }

                $global:mdtDatabase = 'Pester Test'

                {  Connect-MDTDatabase -DrivePath 'DS001:' } | Should -Not -Throw
            }

            It 'Should not throw any errors if the SQL connection succeeds with all arguments defined' {
                Mock -CommandName New-Object `
                    -MockWith { New-Object -TypeName mockGoodSqlConnectionObject } `
                    -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlConnection' }

                {  Connect-MDTDatabase -SqlServer 'localhost' -Instance 'SQLEXPRESS' -Database 'MDT' } | Should -Not -Throw
            }

            It 'Should not throw any errors if the SQL connection succeeds without Instance defined' {
                Mock -CommandName New-Object `
                    -MockWith { New-Object -TypeName mockGoodSqlConnectionObject } `
                    -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlConnection' }

                {  Connect-MDTDatabase -SqlServer 'localhost' -Database 'MDT' } | Should -Not -Throw
            }

            It 'Should create global variable mdtConection on successful connection' {
                Mock -CommandName New-Object `
                    -MockWith { New-Object -TypeName mockGoodSqlConnectionObject } `
                    -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlConnection' }

                Connect-MDTDatabase -SqlServer 'localhost' -Database 'MDT'
                $global:mdtSQLConnection | Should -Not -BeNullOrEmpty
            }

            It 'Should output something to the console' {
                Mock -CommandName Write-Output

                Mock -CommandName New-Object `
                    -MockWith { New-Object -TypeName mockGoodSqlConnectionObject } `
                    -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlConnection' }

                Connect-MDTDatabase -SqlServer 'localhost' -Database 'MDT'
                Assert-MockCalled -CommandName Write-Output -Exactly -Times 1 -Scope It
            }

            It 'Should throw an error if the SQL connection fails' {
                Mock -CommandName New-Object `
                    -MockWith { New-Object -TypeName mockBadSqlConnectionObject } `
                    -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlConnection' }

                {  Connect-MDTDatabase -SqlServer 'localhost' -Database 'MDT' } | Should -Throw
            }
        }
    }
}
