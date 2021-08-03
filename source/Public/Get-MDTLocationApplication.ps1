<#
    .SYNOPSIS
        Get the list of applications for an existing location entry.

    .DESCRIPTION
        Get the list of applications for an existing location entry.

    .EXAMPLE
        PS C:\> Get-MDTLocation -Name 'Portland' | Get-MDTLocationApplication

    .PARAMETER Id
        Specifies the ID of the location to retrieve.
#>
function Get-MDTLocationApplication
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
        return Get-MDTArray -Id $Id -Type 'L' -Table 'Settings_Applications' -Column 'Applications'
    }
}
