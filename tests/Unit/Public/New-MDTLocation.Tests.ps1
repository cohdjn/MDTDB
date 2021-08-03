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
        Gateways = @('1.1.1.1')
        Settings = @{ OSInstall = 'YES'; OSDComputerName = 'MYPC' }
    }

    $badMocks = @{
        Gateways1 = @('987.654.321.0')
        Gateways2 = '987.654.321.0'
        Settings  = 'OSDComputerName=MYPC'
    }

    class mockSqlCommandObject
    {
        [System.String]
        $SqlCommand

        [System.String]
        $SqlConnection

        [System.String]
        ExecuteScalar() { return '1' }
    }

    Describe New-MDTLocation {
        Context 'When called with bad arguments defined' {
            It 'Should throw an error if Gateways does not contain an IP address' {
                { New-MDTLocation -Name $goodMocks.Name -Gateways $badMocks.Gateways1 } | Should -Throw
            }

            It 'Should throw an error if Gateways is not an array' {
                { New-MDTLocation -Name $goodMocks.Name -Gateways $badMocks.Gateways2 } | Should -Throw
            }

            It 'Should throw an error if Settings is not a hashtable' {
                { New-MDTLocation -Name $goodMocks.Name -Settings $badMocks.Settings } | Should -Throw
            }
        }

        Context 'When called with appropriate arguments defined' {
            Mock -CommandName Set-MDTLocation
            Mock -CommandName Get-MDTLocation -MockWith { return $dataSet.Tables[0].Rows }

            Mock -CommandName New-Object `
                -MockWith { New-Object -TypeName mockSqlCommandObject } `
                -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlCommand' }

            It 'Should not throw any errors when providing Name parameter' {
                { New-MDTLocation -Name $goodMocks.Name -Force } | Should -Not -Throw
            }

            It 'Should not throw any errors when providing Gateways parameter' {
                { New-MDTLocation -Name $goodMocks.Name -Gateways $goodMocks.Gateways -Force } | Should -Not -Throw
            }

            It 'Should not throw any errors when providing Settings parameter' {
                { New-MDTLocation -Name $goodMocks.Name -Settings $goodMocks.Settings -Force } | Should -Not -Throw
            }

            It 'Should not throw any errors when providing all parameters' {
                { New-MDTLocation -Name $goodMocks.Name `
                    -Gateways $goodMocks.Gateways -Settings $goodMocks.Settings -Force } | Should -Not -Throw
            }

            It 'Should return valid data' {
                Mock -CommandName Write-Output

                $newLocation = New-MDTLocation -Name $goodMocks.Name -Force
                ($newLocation | Measure-Object).Count | Should -Be 1
            }
            
            It 'Should output something to the console' {
                Mock -CommandName Write-Output

                New-MDTLocation -Name $goodMocks.Name -Force
                Assert-MockCalled -CommandName Write-Output -Exactly -Times 1 -Scope It
            }
        }
    }
}
