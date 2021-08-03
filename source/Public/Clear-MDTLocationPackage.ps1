<#
    .SYNOPSIS
        Remove all packages from an existing location.

    .DESCRIPTION
        Remove all packages from an existing location.

    .EXAMPLE
        PS C:\> Get-MDTLocation -Name 'Portland' | Clear-MDTLocationPackage

    .PARAMETER Id
        Specifies the ID of the location to delete the packages from.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function Clear-MDTLocationPackage
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
            Clear-MDTArray -Id $Id -Type 'L' -Table 'Settings_Packages' -Force
            Write-Output "Removed all packages from location ID [$Id]."
        }
    }
}
