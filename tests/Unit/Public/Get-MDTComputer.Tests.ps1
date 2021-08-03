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

    $mocks = @{
        Id           = '1'
        AssetTag     = 'ABC123'
        MacAddress   = '00:01:02:03:04:05'
        SerialNumber = 'XYZ890'
        Uuid         = '8225b81b-6dff-4203-b36a-33e28dc44b91'
        Description  = 'This is a test'
    }

    class mockSqlDataAdapter
    {
        [System.String]
        $SqlCommand

        [System.String]
        $SqlConnection
    }

    Describe Get-MDTComputer {
        Mock -CommandName New-Object `
            -MockWith { New-Object -TypeName mockSqlDataAdapter } `
            -ParameterFilter { $TypeName -eq 'System.Data.SqlClient.SqlDataAdapter' }

        Mock -CommandName Get-MDTData -MockWith { return $dataSet }

        It 'Should return valid data without any arguments' {
            $returnData = Get-MDTComputer
            ($returnData | Measure-Object).Count | Should -Be 1
        }

        It 'Should return valid data with the Id argument' {
            $returnData = Get-MDTComputer -Id $mocks.Id
            ($returnData | Measure-Object).Count | Should -Be 1
        }

        It 'Should return valid data with the AssetTag argument' {
            $returnData = Get-MDTComputer -AssetTag $mocks.AssetTag
            ($returnData | Measure-Object).Count | Should -Be 1
        }

        It 'Should return valid data with the MacAddress argument' {
            $returnData = Get-MDTComputer -MacAddress $mocks.MacAddress
            ($returnData | Measure-Object).Count | Should -Be 1
        }

        It 'Should return valid data with the SerialNumber argument' {
            $returnData = Get-MDTComputer -SerialNumber $mocks.AssetTag
            ($returnData | Measure-Object).Count | Should -Be 1
        }

        It 'Should return valid data with the Uuid argument' {
            $returnData = Get-MDTComputer -Uuid $mocks.Uuid
            ($returnData | Measure-Object).Count | Should -Be 1
        }

        It 'Should return valid data with the Description argument' {
            $returnData = Get-MDTComputer -Description $mocks.Description
            ($returnData | Measure-Object).Count | Should -Be 1
        }

        It 'Should return valid data with all arguments present' {
            $returnData = Get-MDTComputer `
                -AssetTag $mocks.AssetTag `
                -MacAddress $mocks.MacAddress `
                -SerialNumber $mocks.SerialNumber `
                -Uuid $mocks.Uuid `
                -Description $mocks.Description
            ($returnData | Measure-Object).Count | Should -Be 1
        }
    }
}
