<#
    .SYNOPSIS
        Modify the packages of an existing role.

    .DESCRIPTION
        Modify the packages of an existing role.

    .EXAMPLE
        PS C:\> Get-MDTRole -Name 'Laptops' | Set-MDTRolePackage -Packages @('P','Q','R')

    .PARAMETER Id
        Specifies the ID to modify.

    .PARAMETER Packages
        Specifies the packages to add to the role.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function Set-MDTRolePackage
{
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]

    param
    (
        [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
        [System.String]
        $Id,

        [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
        [System.Array]
        $Packages,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force
    )

    process
    {
        if ($Force -or $PSCmdlet.ShouldProcess($Id))
        {
            Set-MDTArray -Id $Id -Type 'R' -Table 'Settings_Packages' -Column 'Packages' -Array $Packages -Confirm:$false
            Write-Output "Updated packages for role with ID [$Id]."
        }
    }
}
