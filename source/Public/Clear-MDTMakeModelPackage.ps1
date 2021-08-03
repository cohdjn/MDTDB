<#
    .SYNOPSIS
        Remove all packages from an existing make and model.

    .DESCRIPTION
        Remove all packages from an existing make and model.

    .EXAMPLE
        PS C:\> Get-MDTMakeModel -Make 'Microsoft' -Model 'Virtual Machine' | Clear-MDTMakeModelPackage

    .PARAMETER Id
        Specifies the ID of the make/model to delete the packages from.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function Clear-MDTMakeModelPackage
{
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]

    param
    (
        [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
        [System.String]
        $Id,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force
    )

    process
    {
        if ($Force -or $PSCmdlet.ShouldProcess('All Packages'))
        {
            Clear-MDTArray -Id $Id -Type 'M' -Table 'Settings_Packages' -Force
            Write-Output "Removed all packages from make/model ID [$Id]."
        }
    }
}
