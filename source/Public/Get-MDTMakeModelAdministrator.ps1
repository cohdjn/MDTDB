<#
    .SYNOPSIS
        Get the administrators for an existing make/model.

    .DESCRIPTION
        Get the administrators for an existing make/model.

    .EXAMPLE
        PS C:\> Get-MDTMakeModel -Make 'Microsoft' -Model 'Virtual Machine' | Get-MDTMakeModelAdministrator

    .PARAMETER Id
        Specifies the ID of the make/model to retrieve.
#>
function Get-MDTMakeModelAdministrator
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
        return Get-MDTArray -Id $Id -Type 'M' -Table 'Settings_Administrators' -Column 'Administrators'
    }
}
