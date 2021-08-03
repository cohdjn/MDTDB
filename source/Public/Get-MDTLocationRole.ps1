<#
    .SYNOPSIS
        Get the list of roles for an existing location entry.

    .DESCRIPTION
        Get the list of roles for an existing location entry.

    .EXAMPLE
        PS C:\> Get-MDTLocation -Name 'Portland' | Get-MDTLocationRole

    .PARAMETER Id
        Specifies the ID of the location to retrieve.
#>
function Get-MDTLocationRole
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
        return Get-MDTArray -Id $Id -Type 'L' -Table 'Settings_Roles' -Column 'Role'
    }
}
