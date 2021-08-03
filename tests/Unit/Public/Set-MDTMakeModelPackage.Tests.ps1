$ProjectPath = "$PSScriptRoot\..\..\.." | Convert-Path
$ProjectName = ((Get-ChildItem -Path $ProjectPath\*\*.psd1).Where{
        ($_.Directory.Name -match 'source|src' -or $_.Directory.Name -eq $_.BaseName) -and
        $(try { Test-ModuleManifest $_.FullName -ErrorAction Stop } catch { $false } )
    }).BaseName


Import-Module $ProjectName

InModuleScope $ProjectName {
    $mocks = @{
        Id       = '1'
        Packages = @('Package1', 'Package2')
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

    Describe Set-MDTMakeModelPackage {
        Mock -CommandName New-Object `
            -MockWith { New-Object -TypeName mockSqlCommandObject } `
            -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlCommand' }

        It 'Should not throw under any circumstances' {
            { Set-MDTMakeModelPackage -Id $mocks.Id -Packages $mocks.Packages -Force } | Should -Not -Throw
        }

        It 'Should output something to the console' {
            Mock -CommandName Write-Output

            Set-MDTMakeModelPackage -Id $mocks.Id -Packages $mocks.Packages -Force
            Assert-MockCalled -CommandName Write-Output -Exactly -Times 1 -Scope It
        }
    }
}
