<#
    .SYNOPSIS
        Get the packages for an existing make/model.

    .DESCRIPTION
        Get the packages for an existing make/model.

    .EXAMPLE
        PS C:\> Get-MDTMakeModel -Make 'Microsoft' -Model 'Virtual Machine' | Get-MDTMakeModelPackage

    .PARAMETER Id
        Specifies the ID of the make/model to retrieve.
#>
function Get-MDTMakeModelPackage
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
        return Get-MDTArray -Id $Id -Type 'M' -Table 'Settings_Packages' -Column 'Packages'
    }
}
