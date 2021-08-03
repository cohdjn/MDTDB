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
        AssetTag     = 'ABC123'
        MacAddress   = '00:01:02:03:04:05'
        SerialNumber = 'XYZ890'
        Uuid         = '8225b81b-6dff-4203-b36a-33e28dc44b91'
        Description  = 'This is a test'
        Settings     = @{ OSInstall='YES'; OSDComputerName='MYPC' }
    }

    $badMocks = @{
        MacAddress1 = '01:23:45:67:89:ab:cd'
        MacAddress2 = '01:23:45:67:89:Az'
        MacAddress3 = '01:23:45:56:'
        MacAddress4 = '01-23-45-67-89-ab-cd'
        Uuid1       = '8225b81b-6dff-4203-b36a-33e28dc44b911'
        Uuid2       = '8225b81b-6dff-4203-b36a-33e28dc44b9'
        Uuid3       = '8225b81b-6dff-4203-b36n-33e28dc44b91'
        Uuid4       = '8225b81b6dff4203b36a33e28dc44b91'
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

    Describe New-MDTComputer {
        Context 'When called with bad or insufficient arguments defined' {
            It 'Should throw an error if no arguments are provided' {
                { New-MDTComputer } | Should -Throw
            }

            It 'Should throw if the MacAddress is too large' {
                { New-MDTComputer -MacAddress $badMocks.MacAddress1 } | Should -Throw
            }

            It 'Should throw if the MacAddress is too short' {
                { New-MDTComputer -MacAddress $badMocks.MacAddress3 } | Should -Throw
            }

            It 'Should throw if the MacAddress has a non-hexadecimal digit' {
                { New-MDTComputer -MacAddress $badMocks.MacAddress2 } | Should -Throw
            }

            It 'Should throw if the MacAddress is misformatted' {
                { New-MDTComputer -MacAddress $badMocks.MacAddress4 } | Should -Throw
            }

            It 'Should throw if the Uuid is too large' {
                { New-MDTComputer -Uuid $badMocks.Uuid1 } | Should -Throw
            }

            It 'Should throw if the Uuid is too short' {
                { New-MDTComputer -Uuid $badMocks.Uuid2 } | Should -Throw
            }

            It 'Should throw if the Uuid has a non-hexadecimal digit' {
                { New-MDTComputer -Uuid $badMocks.Uuid3 } | Should -Throw
            }
            It 'Should throw if the Uuid is misformatted' {
                { New-MDTComputer -Uuid $badMocks.Uuid4 } | Should -Throw
            }
        }

        Context 'When called with appropriate arguments defined' {
            Mock -CommandName Get-MDTComputer

            Mock -CommandName New-Object `
                -MockWith { New-Object -TypeName mockSqlCommandObject } `
                -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlCommand' }

            It 'Should not throw any errors when providing AssetTag parameter' {
                { New-MDTComputer -AssetTag $goodMocks.AssetTag -Force } | Should -Not -Throw
            }

            It 'Should not throw any errors when providing MacAddress parameter' {
                { New-MDTComputer -MacAddress $goodMocks.MacAddress -Force } | Should -Not -Throw
            }

            It 'Should not throw any errors when providing SerialNumber parameter' {
                { New-MDTComputer -SerialNumber $goodMocks.SerialNumber -Force } | Should -Not -Throw
            }

            It 'Should not throw any errors when providing Uuid parameter' {
                { New-MDTComputer -Uuid $goodMocks.Uuid -Force } | Should -Not -Throw
            }

            It 'Should not throw any errors when providing all parameters' {
                { New-MDTComputer -AssetTag $goodMocks.AssetTag -MacAddress $goodMocks.MacAddress `
                    -SerialNumber $goodMocks.SerialNumber -Uuid $goodMocks.Uuid -Settings $goodMocks.Settings -Force } | Should -Not -Throw
            }

            It 'Should return valid data' {
                Mock -CommandName Write-Output
                Mock -CommandName Get-MDTComputer -MockWith { return $dataSet.Tables[0].Rows }

                $newComputer = New-MDTComputer -AssetTag $goodMocks.AssetTag -Force
                ($newComputer | Measure-Object).Count | Should -Be 1
            }
            
            It 'Should output something to the console' {
                Mock -CommandName Write-Output

                New-MDTComputer -AssetTag $goodMocks.AssetTag -Force
                Assert-MockCalled -CommandName Write-Output -Exactly -Times 1 -Scope It
            }
        }
    }
}
