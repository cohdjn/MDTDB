$ProjectPath = "$PSScriptRoot\..\..\.." | Convert-Path
$ProjectName = ((Get-ChildItem -Path $ProjectPath\*\*.psd1).Where{
        ($_.Directory.Name -match 'source|src' -or $_.Directory.Name -eq $_.BaseName) -and
        $(try { Test-ModuleManifest $_.FullName -ErrorAction Stop } catch { $false } )
    }).BaseName


Import-Module $ProjectName

InModuleScope $ProjectName {
    class mockSqlCommandObject
    {
        [System.String]
        $SqlCommand

        [System.String]
        $SqlConnection

        [void]
        ExecuteScalar() { }
    }

    Describe Clear-MDTMakeModelApplication {
        Context 'When calling the function' {
            Mock -CommandName New-Object `
                -MockWith { New-Object -TypeName mockSqlCommandObject } `
                -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlCommand' }

            It 'Should not throw any errors' {
                { Clear-MDTMakeModelApplication -Id '1' -Force } | Should -Not -Throw
            }

            It 'Should output something to the console' {
                Mock -CommandName Write-Output

                Clear-MDTMakeModelApplication -Id '1' -Force
                Assert-MockCalled -CommandName Write-Output -Exactly -Times 1 -Scope It
            }
        }
    }
}
