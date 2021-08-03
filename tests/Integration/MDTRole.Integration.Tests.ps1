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

    Describe 'MDTRole Integration Tests' {
        Mock -CommandName New-Object `
            -MockWith { New-Object -TypeName mockSqlCommandObject } `
            -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlCommand' }

        Mock -CommandName New-Object `
            -MockWith { New-Object -TypeName mockSqlDataAdapter } `
            -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlDataAdapter' }

        $roleTable = New-Object -TypeName System.Data.DataTable
        $roleTable.Columns.Add('Id')
        $roleTable.Columns.Add('Name')
        $roleTable.Rows.Add('1', 'Laptops')
        $roleDataSet = New-Object -TypeName System.Data.DataSet
        $roleDataSet.Tables.Add($roleTable)
    
        Mock -CommandName Get-MDTData -MockWith { return $roleDataSet }

        It 'Should delete role named Laptops via the pipeline' {
            { Get-MDTRole -Name 'Laptops' | Remove-MDTRole -Force } | Should -Not -Throw
        }

        It 'Should add a configuration setting to a role via the pipeline' {
            { Get-MDTRole -Name 'Laptops' | Set-MDTRole -Settings @{ComputerName="BLAH"} -Force } | Should -Not -Throw
        }

        It 'Should delete all applications on an existing role via the pipeline' {
            { Get-MDTRole -Name 'Laptops' | Clear-MDTRoleApplication -Force } | Should -Not -Throw
        }

        It 'Should set new applications on an existing role via the pipeline' {
            { Get-MDTRole -Name 'Laptops' |
                Set-MDTRoleApplication -Applications @('A','B','C') -Force } | Should -Not -Throw
        }

        It 'Should list the applications associated with an existing role via the pipeline' {
            { Get-MDTRole -Name 'Laptops' | Get-MDTRoleApplication } | Should -Not -Throw
        }

        It 'Should delete all packages on an existing role via the pipeline' {
            { Get-MDTRole -Name 'Laptops' | Clear-MDTRolePackage -Force } | Should -Not -Throw
        }

        It 'Should set new packages on an existing role via the pipeline' {
            { Get-MDTRole -Name 'Laptops' | Set-MDTRolePackage -Packages @('P','Q','R') -Force } | Should -Not -Throw
        }

        It 'Should list the packages associated with an existing role via the pipeline' {
            { Get-MDTRole -Name 'Laptops' | Get-MDTRolePackage } | Should -Not -Throw
        }

        It 'Should delete all roles on an existing role via the pipeline' {
            { Get-MDTRole -Name 'Laptops' | Clear-MDTRoleRole -Force } | Should -Not -Throw
        }

        It 'Should set new roles on an existing role via the pipeline' {
            { Get-MDTRole -Name 'Laptops' | Set-MDTRoleRole -Roles @('R','S','T') -Force } | Should -Not -Throw
        }

        It 'Should list the roles asociated with an existing role via the pipeline' {
            { Get-MDTRole -Name 'Laptops' | Get-MDTRoleRole } | Should -Not -Throw
        }

        It 'Should delete all administrators on an existing role via the pipeline' {
            { Get-MDTRole -Name 'Laptops' | Clear-MDTRoleAdministrator -Force } | Should -Not -Throw
        }

        It 'Should set new administrators on an existing role via the pipeline' {
            { Get-MDTRole -Name 'Laptops' | Set-MDTRoleAdministrator -Administrators @('A','B') -Force } | Should -Not -Throw
        }

        It 'Should list the administrators associated with an existing role via the pipeline' {
            { Get-MDTRole -Name 'Laptops' | Get-MDTRoleAdministrator } | Should -Not -Throw
        }
    }
}
