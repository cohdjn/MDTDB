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
        Make     = 'Wonder Computers'
        Model    = 'Sooper Dooper Model Z'
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

    Describe New-MDTMakeModel {
        Context 'When called with bad or insufficient arguments defined' {
            It 'Should throw if Settings is misformatted' {
                { New-MDTMakeModel -Make $goodMocks.Make -Model $goodMocks.Model -Settings $badmocks.Settings } | Should -Throw
            }
        }

        Context 'When called with appropriate arguments defined' {
            Mock -CommandName Get-MDTMakeModel

            Mock -CommandName New-Object `
                -MockWith { New-Object -TypeName mockSqlCommandObject } `
                -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlCommand' }

            It 'Should not throw any errors when providing Make and Model parameters' {
                { New-MDTMakeModel -Make $goodMocks.Make -Model $goodMocks.Model -Force } | Should -Not -Throw
            }

            It 'Should not throw any errors when providing all parameters' {
                { New-MDTMakeModel -Make $goodMocks.Make `
                    -Model $goodMocks.Model -Settings $goodMocks.Settings -Force } | Should -Not -Throw
            }

            It 'Should return valid data' {
                Mock -CommandName Write-Output
                Mock -CommandName Get-MDTMakeModel -MockWith { return $dataSet.Tables[0].Rows }

                $newMakeModel = New-MDTMakeModel -Make $goodMocks.Make -Model $goodMocks.Model -Force
                ($newMakeModel | Measure-Object).Count | Should -Be 1
            }
            
            It 'Should output something to the console' {
                Mock -CommandName Write-Output

                New-MDTMakeModel -Make $goodMocks.Make -Model $goodMocks.Model -Force
                Assert-MockCalled -CommandName Write-Output -Exactly -Times 1 -Scope It
            }
        }
    }
}
