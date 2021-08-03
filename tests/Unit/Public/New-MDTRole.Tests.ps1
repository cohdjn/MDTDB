$ProjectPath = "$PSScriptRoot\..\..\.." | Convert-Path
$ProjectName = ((Get-ChildItem -Path $ProjectPath\*\*.psd1).Where{
        ($_.Directory.Name -match 'source|src' -or $_.Directory.Name -eq $_.BaseName) -and
        $(try { Test-ModuleManifest $_.FullName -ErrorAction Stop } catch { $false } )
    }).BaseName


Import-Module $ProjectName

InModuleScope $ProjectName {
    $testTable = New-Object -TypeName System.Data.DataTable
    $testTable.Columns.Add('Test')
    $testTable.Rows.Add('TEST123')

    $dataSet = New-Object -TypeName System.Data.DataSet
    $dataSet.Tables.Add($testTable)

    $goodMocks = @{
        Name     = 'Pester Test'
        Settings = @{ OSInstall='YES'; OSDComputerName='MYPC' }
    }

    $badMocks = @{
        Settings = @('YES','MYPC')
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

    Describe New-MDTRole {
        Context 'When called with bad or insufficient arguments defined' {
            It 'Should throw if Settings is misformatted' {
                { New-MDTRole -Name $goodMocks.Name -Settings $badmocks.Settings } | Should -Throw
            }
        }

        Context 'When called with appropriate arguments defined' {
            Mock -CommandName Get-MDTRole

            Mock -CommandName New-Object `
                -MockWith { New-Object -TypeName mockSqlCommandObject } `
                -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlCommand' }

            It 'Should not throw any errors when providing all parameters' {
                { New-MDTRole -Name $goodMocks.Name -Settings $goodMocks.Settings -Force } | Should -Not -Throw
            }

            It 'Should return valid data' {
                Mock -CommandName Write-Output
                Mock -CommandName Get-MDTRole -MockWith { return $dataSet.Tables[0].Rows }

                $newRole = New-MDTRole -Name $goodMocks.Name -Settings $goodMocks.Settings -Force
                ($newRole | Measure-Object).Count | Should -Be 1
            }
            
            It 'Should output something to the console' {
                Mock -CommandName Write-Output

                New-MDTRole -Name $goodMocks.Name -Settings $goodMocks.Settings -Force
                Assert-MockCalled -CommandName Write-Output -Exactly -Times 1 -Scope It
            }
        }
    }
}
