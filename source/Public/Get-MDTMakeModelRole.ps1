<#
    .SYNOPSIS
        Get the roles for an existing make/model.

    .DESCRIPTION
        Get the roles for an existing make/model.

    .EXAMPLE
        PS C:\> Get-MDTMakeModel -Make 'Microsoft' -Model 'Virtual Machine' | Get-MDTMakeModelRole

    .PARAMETER Id
        Specifies the ID of the make/model to retrieve.
#>
function Get-MDTMakeModelRole
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
        return Get-MDTArray -Id $Id -Type 'M' -Table 'Settings_Roles' -Column 'Role'
    }
}
