<#
    .SYNOPSIS
        Get the list of packages for an existing role entry.

    .DESCRIPTION
        Get the list of packages for an existing role entry.

    .EXAMPLE
        PS C:\> Get-MDTRole -Name 'Laptops' | Get-MDTRolePackage

    .PARAMETER Id
        Specifies the ID of the role to retrieve.
#>
function Get-MDTRolePackage
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
        return Get-MDTArray -Id $Id -Type 'R' -Table 'Settings_Packages' -Column 'Packages'
    }
}
