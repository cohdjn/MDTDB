<#
    .SYNOPSIS
        Get the list of roles for an existing computer entry.

    .DESCRIPTION
        Get the list of roles for an existing computer entry.

    .EXAMPLE
        PS C:\> Get-MDTComputer -AssetTag '123ABC' | Get-MDTComputerRole

    .PARAMETER Id
        Specifies the ID of the computer to retrieve.
#>
function Get-MDTComputerRole
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
        return Get-MDTArray -Id $Id -Type 'C' -Table 'Settings_Roles' -Column 'Role'
    }
}
