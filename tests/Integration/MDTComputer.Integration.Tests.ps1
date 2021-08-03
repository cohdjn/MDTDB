$here = Split-Path -Parent $MyInvocation.MyCommand.Path

# Convert-path required for PS7 or Join-Path fails
$ProjectPath = "$here\..\.." | Convert-Path
$ProjectName = ((Get-ChildItem -Path $ProjectPath\*\*.psd1).Where{
        ($_.Directory.Name -match 'source|src' -or $_.Directory.Name -eq $_.BaseName) -and
        $(try { Test-ModuleManifest $_.FullName -ErrorAction Stop } catch { $false } )
    }).BaseName


Import-Module $ProjectName

InModuleScope $ProjectName {
    class mockSqlDataAdapter
    {
        [System.String]
        $SqlCommand

        [System.String]
        $SqlConnection
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

    Describe 'MDTComputer Integration Tests' {
        Mock -CommandName New-Object `
            -MockWith { New-Object -TypeName mockSqlCommandObject } `
            -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlCommand' }

        Mock -CommandName New-Object `
            -MockWith { New-Object -TypeName mockSqlDataAdapter } `
            -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlDataAdapter' }

        $computerTable = New-Object -TypeName System.Data.DataTable
        $computerTable.Columns.Add('Id')
        $computerTable.Columns.Add('AssetTag')
        $computerTable.Rows.Add('1', '123ABC')
        $computerDataSet = New-Object -TypeName System.Data.DataSet
        $computerDataSet.Tables.Add($computerTable)

        Mock -CommandName Get-MDTData -MockWith { return $computerDataSet }

        It 'Should delete computer with asset tag 123ABC via the pipeline' {
            { Get-MDTComputer -AssetTag '123ABC' | Remove-MDTComputer -Force } | Should -Not -Throw
        }

        It 'Should add a configuration setting to an existing computer via the pipeline' {
            { Get-MDTComputer -AssetTag '123ABC' |
                Set-MDTComputer -Settings @{ComputerName="BLAH"} -Force } | Should -Not -Throw
        }

        It 'Should delete all applications on an existing computer via the pipeline' {
            { Get-MDTComputer -AssetTag '123ABC' | Clear-MDTComputerApplication -Force } | Should -Not -Throw
        }

        It 'Should set new applications on an existing computer via the pipeline' {
            { Get-MDTComputer -AssetTag '123ABC' |
                Set-MDTComputerApplication -Applications @('A','B','C') -Force } | Should -Not -Throw
        }

        It 'Should list the applications associated with an existing computer via the pipeline' {
            { Get-MDTComputer -AssetTag '123ABC' | Get-MDTComputerApplication } | Should -Not -Throw
        }

        It 'Should delete all packages on an existing computer via the pipeline' {
            { Get-MDTComputer -AssetTag '123ABC' | Clear-MDTComputerPackage -Force } | Should -Not -Throw
        }

        It 'Should set new packages on an existing computer via the pipeline' {
            { Get-MDTComputer -AssetTag '123ABC' | Set-MDTComputerPackage -Packages @('P','Q','R') -Force } | Should -Not -Throw
        }

        It 'Should list the packages associated with an existing computer via the pipeline' {
            { Get-MDTComputer -AssetTag '123ABC' | Get-MDTComputerPackage } | Should -Not -Throw
        }

        It 'Should delete all roles on an existing computer via the pipeline' {
            { Get-MDTComputer -AssetTag '123ABC' | Clear-MDTComputerRole -Force } | Should -Not -Throw
        }

        It 'Should set new roles on an existing computer via the pipeline' {
            { Get-MDTComputer -AssetTag '123ABC' | Set-MDTComputerRole -Roles @('R','S','T') -Force } | Should -Not -Throw
        }

        It 'Should list the roles asociated with an existing computer via the pipeline' {
            { Get-MDTComputer -AssetTag '123ABC' | Get-MDTComputerRole } | Should -Not -Throw
        }

        It 'Should delete all administrators on an existing computer via the pipeline' {
            { Get-MDTComputer -AssetTag '123ABC' | Clear-MDTComputerAdministrator -Force } | Should -Not -Throw
        }

        It 'Should set new administrators on an existing computer via the pipeline' {
            { Get-MDTComputer -AssetTag '123ABC' | Set-MDTComputerAdministrator -Administrators @('A','B') -Force } | Should -Not -Throw
        }

        It 'Should list the administrators associated with an existing computer via the pipeline' {
            { Get-MDTComputer -AssetTag '123ABC' | Get-MDTComputerAdministrator } | Should -Not -Throw
        }
    }
}
