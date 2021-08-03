$ProjectPath = "$PSScriptRoot\..\..\.." | Convert-Path
$ProjectName = ((Get-ChildItem -Path $ProjectPath\*\*.psd1).Where{
        ($_.Directory.Name -match 'source|src' -or $_.Directory.Name -eq $_.BaseName) -and
        $(try { Test-ModuleManifest $_.FullName -ErrorAction Stop } catch { $false } )
    }).BaseName


Import-Module $ProjectName

InModuleScope $ProjectName {
    $mocks = @{
        Id           = '1'
        Applications = @('App1', 'App2')
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

    Describe Set-MDTComputerApplication {
        Mock -CommandName New-Object `
            -MockWith { New-Object -TypeName mockSqlCommandObject } `
            -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlCommand' }

        It 'Should not throw under any circumstances' {
            { Set-MDTComputerApplication -Id $mocks.Id -Applications $mocks.Applications -Force } | Should -Not -Throw
        }

        It 'Should output something to the console' {
            Mock -CommandName Write-Output

            Set-MDTComputerApplication -Id $mocks.Id -Applications $mocks.Applications -Force
            Assert-MockCalled -CommandName Write-Output -Exactly -Times 1 -Scope It
        }
    }
}
