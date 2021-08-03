<#
    .SYNOPSIS
        Get the list of administrators for an existing location entry.

    .DESCRIPTION
        Get the list of administrators for an existing location entry.

    .EXAMPLE
        PS C:\> Get-MDTLocation -Name 'Portland' | Get-MDTLocationAdministrator

    .PARAMETER Id
        Specifies the ID of the location to retrieve.
#>
function Get-MDTLocationAdministrator
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
        return Get-MDTArray -Id $Id -Type 'L' -Table 'Settings_Administrators' -Column 'Administrators'
    }
}
