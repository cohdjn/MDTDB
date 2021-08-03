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

    Describe 'MDTLocation Integration Tests' {
        Mock -CommandName New-Object `
            -MockWith { New-Object -TypeName mockSqlCommandObject } `
            -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlCommand' }

        Mock -CommandName New-Object `
            -MockWith { New-Object -TypeName mockSqlDataAdapter } `
            -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlDataAdapter' }

        $locationTable = New-Object -TypeName System.Data.DataTable
        $locationTable.Columns.Add('Id')
        $locationTable.Columns.Add('Location')
        $locationTable.Rows.Add('1', 'Seattle')
        $locationDataSet = New-Object -TypeName System.Data.DataSet
        $locationDataSet.Tables.Add($locationTable)
    
        Mock -CommandName Get-MDTData -MockWith { return $locationDataSet }
    
        It 'Should delete location named Seattle via the pipeline' {
            { Get-MDTLocation -Name 'Seattle' | Remove-MDTLocation -Force } | Should -Not -Throw
        }

        It 'Should add a configuration setting to an existing location via the pipeline' {
            { Get-MDTLocation -Name 'Seattle' |
                Set-MDTLocation -Settings @{ComputerName="BLAH"} -Force } | Should -Not -Throw
        }

        It 'Should set new gateways on an existing location via the pipeline' {
            { Get-MDTLocation -Name 'Seattle' |
                Set-MDTLocation -Gateways @('1.2.3.4','2.3.4.5','3.4.5.6') -Force } | Should -Not -Throw
        }

        It 'Should delete all applications on an existing location via the pipeline' {
            { Get-MDTLocation -Name 'Seattle' | Clear-MDTLocationApplication -Force } | Should -Not -Throw
        }

        It 'Should set new applications on an existing location via the pipeline' {
            { Get-MDTLocation -Name 'Seattle' |
                Set-MDTLocationApplication -Applications @('A','B','C') -Force } | Should -Not -Throw
        }

        It 'Should list the applications associated with an existing location via the pipeline' {
            { Get-MDTLocation -Name 'Seattle' | Get-MDTLocationApplication } | Should -Not -Throw
        }

        It 'Should delete all packages on an existing location via the pipeline' {
            { Get-MDTLocation -Name 'Seattle' | Clear-MDTLocationPackage -Force } | Should -Not -Throw
        }

        It 'Should set new packages on an existing location via the pipeline' {
            { Get-MDTLocation -Name 'Seattle' | Set-MDTLocationPackage -Packages @('P','Q','R') -Force } | Should -Not -Throw
        }

        It 'Should list the packages associated with an existing location via the pipeline' {
            { Get-MDTLocation -Name 'Seattle' | Get-MDTLocationPackage } | Should -Not -Throw
        }

        It 'Should delete all roles on an existing location via the pipeline' {
            { Get-MDTLocation -Name 'Seattle' | Clear-MDTLocationRole -Force } | Should -Not -Throw
        }

        It 'Should set new roles on an existing location via the pipeline' {
            { Get-MDTLocation -Name 'Seattle' | Set-MDTLocationRole -Roles @('R','S','T') -Force } | Should -Not -Throw
        }

        It 'Should list the roles asociated with an existing location via the pipeline' {
            { Get-MDTLocation -Name 'Seattle' | Get-MDTLocationRole } | Should -Not -Throw
        }

        It 'Should delete all administrators on an existing location via the pipeline' {
            { Get-MDTLocation -Name 'Seattle' | Clear-MDTLocationAdministrator -Force } | Should -Not -Throw
        }

        It 'Should set new administrators on an existing location via the pipeline' {
            { Get-MDTLocation -Name 'Seattle' | Set-MDTLocationAdministrator -Administrators @('A','B') -Force } | Should -Not -Throw
        }

        It 'Should list the administrators associated with an existing location via the pipeline' {
            { Get-MDTLocation -Name 'Seattle' | Get-MDTLocationAdministrator } | Should -Not -Throw
        }
    }
}
