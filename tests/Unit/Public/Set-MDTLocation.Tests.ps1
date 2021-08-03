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
        Id       = '1'
        Gateways = @('1.1.1.1')
        Settings = @{ OSInstall = 'YES'; OSDComputerName = 'MYPC' }
    }

    $badMocks = @{
        Id       = '1'
        Settings = 'OSDComputerName=MYPC'
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

    Describe Set-MDTLocation {
        Context 'When called with bad arguments defined' {
            It 'Should throw an error if Settings is misformatted' {
                { Set-MDTLocation -Id $goodMocks.Id -Settings $badMocks.Settings  } | Should -Throw
            }
        }

        Context 'When called with appropriate arguments defined' {
            Mock -CommandName Get-MDTLocation

            Mock -CommandName New-Object `
                -MockWith { New-Object -TypeName mockSqlCommandObject } `
                -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlCommand' }

            It 'Should not throw when Gateways is defined alone' {
                { Set-MDTLocation -Id $goodMocks.Id -Gateways $goodMocks.Gateways -Force } | Should -Not -Throw
            }

            It 'Should not throw when Settings is defined alone' {
                { Set-MDTLocation -Id $goodMocks.Id -Settings $goodMocks.Settings -Force } | Should -Not -Throw
            }

            It 'Should not throw when all arguments are defined' {
                { Set-MDTLocation -Id $goodMocks.Id `
                    -Gateways $goodMocks.Gateways -Settings $goodMocks.Settings -Force } | Should -Not -Throw
            }

            It 'Should return valid data' {
                Mock -CommandName Write-Output
                Mock -CommandName Get-MDTLocation -MockWith { return $dataSet.Tables[0].Rows }

                $updateLocation = Set-MDTLocation -Id $goodMocks.Id `
                    -Gateways $goodMocks.Gateways -Settings $goodMocks.Settings -Force
                ($updateLocation | Measure-Object).Count | Should -Be 1
            }
            
            It 'Should output something to the console when changes are made' {
                Mock -CommandName Write-Output

                Set-MDTLocation -Id $goodMocks.Id -Gateways $goodMocks.Gateways -Settings $goodMocks.Settings -Force
                Assert-MockCalled -CommandName Write-Output -Exactly -Times 1 -Scope It
            }

            It 'Should output something to the console when no changes are made' {
                Mock -CommandName Write-Output

                Set-MDTLocation -Id $goodMocks.Id
                Assert-MockCalled -CommandName Write-Output -Exactly -Times 1 -Scope It
            }
        }
    }
}
