$ProjectPath = "$PSScriptRoot\..\..\.." | Convert-Path
$ProjectName = ((Get-ChildItem -Path $ProjectPath\*\*.psd1).Where{
        ($_.Directory.Name -match 'source|src' -or $_.Directory.Name -eq $_.BaseName) -and
        $(try { Test-ModuleManifest $_.FullName -ErrorAction Stop } catch { $false } )
    }).BaseName


Import-Module $ProjectName

InModuleScope $ProjectName {
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

    Describe Remove-MDTPackageMapping {
        Mock -CommandName New-Object `
        -MockWith { New-Object -TypeName mockSqlCommandObject } `
        -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlCommand' }

        Context 'When called without arguments defined' {
            It 'Should not throw any errors under any circumstances' {
                { Remove-MDTPackageMapping -Force } | Should -Not -Throw
            }

            It 'Should output something to the console' {
                Mock -CommandName Write-Output

                Remove-MDTPackageMapping -Force
                Assert-MockCalled -CommandName Write-Output -Exactly -Times 1 -Scope It
            }
        }

        Context 'When called with only ARPName defined' {
            It 'Should not throw any errors under any circumstances' {
                { Remove-MDTPackageMapping -ARPName $goodMocks.ARPName -Force } | Should -Not -Throw
            }

            It 'Should output something to the console' {
                Mock -CommandName Write-Output

                Remove-MDTPackageMapping -ARPName $goodMocks.ARPName -Force
                Assert-MockCalled -CommandName Write-Output -Exactly -Times 1 -Scope It
            }
        }

        Context 'When called with only Package defined' {
            It 'Should not throw any errors under any circumstances' {
                { Remove-MDTPackageMapping -Package $goodMocks.Package -Force } | Should -Not -Throw
            }

            It 'Should output something to the console' {
                Mock -CommandName Write-Output

                Remove-MDTPackageMapping -Package $goodMocks.Package -Force
                Assert-MockCalled -CommandName Write-Output -Exactly -Times 1 -Scope It
            }
        }

        Context 'When called with all arguments defined' {
            It 'Should not throw any errors under any circumstances' {
                { Remove-MDTPackageMapping -ARPName $goodMocks.ARPName -Package $goodMocks.Package -Force } | Should -Not -Throw
            }

            It 'Should output something to the console' {
                Mock -CommandName Write-Output

                Remove-MDTPackageMapping -ARPName $goodMocks.ARPName -Package $goodMocks.Package -Force
                Assert-MockCalled -CommandName Write-Output -Exactly -Times 1 -Scope It
            }
        }
    }
}
