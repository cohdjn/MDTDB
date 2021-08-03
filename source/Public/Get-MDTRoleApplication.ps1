<#
    .SYNOPSIS
        Get the list of applications for an existing role entry.

    .DESCRIPTION
        Get the list of applications for an existing role entry.

    .EXAMPLE
        PS C:\> Get-MDTRole -Name 'Laptops' | Get-MDTRoleApplication

    .PARAMETER Id
        Specifies the ID of the role to retrieve.
#>
function Get-MDTRoleApplication
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
        return Get-MDTArray -Id $Id -Type 'R' -Table 'Settings_Applications' -Column 'Applications'
    }
}
