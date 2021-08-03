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

    Describe 'MDTPackageMapping Integration Tests' {
        Mock -CommandName New-Object `
            -MockWith { New-Object -TypeName mockSqlCommandObject } `
            -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlCommand' }

        Mock -CommandName New-Object `
            -MockWith { New-Object -TypeName mockSqlDataAdapter } `
            -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlDataAdapter' }

        $makeMappingTable = New-Object -TypeName System.Data.DataTable
        $makeMappingTable.Columns.Add('ARPName')
        $makeMappingTable.Columns.Add('Package')
        $makeMappingTable.Rows.Add('My Application', 'My Package')
        $makeMappingDataSet = New-Object -TypeName System.Data.DataSet
        $makeMappingDataSet.Tables.Add($makeMappingTable)
    
        Mock -CommandName Get-MDTData -MockWith { return $makeMappingDataSet }

        It 'Should delete an existing package mapping via the pipeline' {
            { Get-MDTPackageMapping -ARPName 'My Application' | Remove-MDTPackageMapping -Force } | Should -Not -Throw
        }

        It 'Should change the package of an existing mapping via the pipeline' {
            { Get-MDTPackageMapping -ARPName 'My Application' |
                Set-MDTPackageMapping -Package 'XXX00002:Test' -Force } | Should -Not -Throw
        }
    }
}
