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

    Describe 'MDTMakeModel Integration Tests' {
        Mock -CommandName New-Object `
            -MockWith { New-Object -TypeName mockSqlCommandObject } `
            -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlCommand' }

        Mock -CommandName New-Object `
            -MockWith { New-Object -TypeName mockSqlDataAdapter } `
            -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlDataAdapter' }

        $makeModelTable = New-Object -TypeName System.Data.DataTable
        $makeModelTable.Columns.Add('Id')
        $makeModelTable.Columns.Add('Location')
        $makeModelTable.Rows.Add('1', 'Seattle')
        $makeModelDataSet = New-Object -TypeName System.Data.DataSet
        $makeModelDataSet.Tables.Add($makeModelTable)
    
        Mock -CommandName Get-MDTData -MockWith { return $makeModelDataSet }

        It 'Should delete make VMware and model Virtual Machine via the pipeline' {
            { Get-MDTMakeModel -Make 'VMware' -Model 'Virtual Machine' |
                Remove-MDTMakeModel -Force } | Should -Not -Throw
        }

        It 'Should add a configuration setting to a make and model via the pipeline' {
            { Get-MDTMakeModel -Make 'Microsoft' -Model 'Virtual Machine' |
                Set-MDTMakeModel -Settings @{ComputerName="BLAH"} -Force } | Should -Not -Throw
        }

        It 'Should delete all applications on an existing make and model via the pipeline' {
            { Get-MDTMakeModel -Make 'Microsoft' -Model 'Virtual Machine' |
                Clear-MDTMakeModelApplication -Force } | Should -Not -Throw
        }

        It 'Should set new applications on an existing make and model via the pipeline' {
            { Get-MDTMakeModel -Make 'Microsoft' -Model 'Virtual Machine' |
               Set-MDTMakeModelApplication -Applications @('A','B','C') -Force } | Should -Not -Throw
        }

        It 'Should list the applications associated with an existing make and model via the pipeline' {
            { Get-MDTMakeModel -Make 'Microsoft' -Model 'Virtual Machine' |
                Get-MDTMakeModelApplication } | Should -Not -Throw
        }

        It 'Should delete all packages on an existing make and model via the pipeline' {
            { Get-MDTMakeModel -Make 'Microsoft' -Model 'Virtual Machine' |
                Clear-MDTMakeModelPackage -Force } | Should -Not -Throw
        }

        It 'Should set new packages on an existing make and model via the pipeline' {
            { Get-MDTMakeModel -Make 'Microsoft' -Model 'Virtual Machine' |
                Set-MDTMakeModelPackage -Packages @('P','Q','R') -Force } | Should -Not -Throw
        }

        It 'Should list the packages associated with an existing make and model via the pipeline' {
            { Get-MDTMakeModel -Make 'Microsoft' -Model 'Virtual Machine' |
                Get-MDTMakeModelPackage } | Should -Not -Throw
        }

        It 'Should delete all roles on an existing make and model via the pipeline' {
            { Get-MDTMakeModel -Make 'Microsoft' -Model 'Virtual Machine' |
                Clear-MDTMakeModelRole -Force } | Should -Not -Throw
        }

        It 'Should set new roles on an existing make and model via the pipeline' {
            { Get-MDTMakeModel -Make 'Microsoft' -Model 'Virtual Machine' |
                Set-MDTMakeModelRole -Roles @('R','S','T') -Force } | Should -Not -Throw
        }

        It 'Should list the roles asociated with an existing make and model via the pipeline' {
            { Get-MDTMakeModel -Make 'Microsoft' -Model 'Virtual Machine' |
                Get-MDTMakeModelRole } | Should -Not -Throw
        }

        It 'Should delete all administrators on an existing make and model via the pipeline' {
            { Get-MDTMakeModel -Make 'Microsoft' -Model 'Virtual Machine' |
                Clear-MDTMakeModelAdministrator -Force } | Should -Not -Throw
        }

        It 'Should set new administrators on an existing make and model via the pipeline' {
            { Get-MDTMakeModel -Make 'Microsoft' -Model 'Virtual Machine' |
                Set-MDTMakeModelAdministrator -Administrators @('A','B') -Force } | Should -Not -Throw
        }

        It 'Should list the administrators associated with an existing make and model via the pipeline' {
            { Get-MDTMakeModel -Make 'Microsoft' -Model 'Virtual Machine' |
                Get-MDTMakeModelAdministrator } | Should -Not -Throw
        }
    }
}
