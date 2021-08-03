<#
    .SYNOPSIS
        Remove all packages from an existing role.

    .DESCRIPTION
        Remove all packages from an existing role.

    .EXAMPLE
        PS C:\> Get-MDTRole -Name 'Laptops' | Clear-MDTRolePackage

    .PARAMETER Id
        Specifies the ID of the role to delete the packages from.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function Clear-MDTRolePackage
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
            Clear-MDTArray -Id $Id -Type 'R' -Table 'Settings_Packages' -Force
            Write-Output "Removed all packages from role ID [$Id]."
        }
    }
}
