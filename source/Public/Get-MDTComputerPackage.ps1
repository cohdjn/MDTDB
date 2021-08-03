<#
    .SYNOPSIS
        Get the list of packages for an existing computer entry.

    .DESCRIPTION
        Get the list of packages for an existing computer entry.

    .EXAMPLE
        PS C:\> Get-MDTComputer -AssetTag '789XYZ' | Get-MDTComputerPackage

    .PARAMETER Id
        Specifies the ID of the computer to retrieve.
#>
function Get-MDTComputerPackage
{
    [CmdletBinding()]
    [OutputType([System.Data.DataRowCollection])]

    param
    (
        [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
        [System.String]
        $Id
    )

    process
    {
        return Get-MDTArray -Id $Id -Type 'C' -Table 'Settings_Packages' -Column 'Packages'
    }
}
