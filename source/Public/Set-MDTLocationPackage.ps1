<#
    .SYNOPSIS
        Modify the list of packages for an existing location.

    .DESCRIPTION
        Modify the list of packages for an existing location.

    .EXAMPLE
        PS C:\> Get-MDTLocation -Name 'Portland' | Set-MDTLocationPackage -Packages @('P','Q','R')

    .PARAMETER Id
        Specifies the ID to modify.

    .PARAMETER Packages
        Specifies the packages to add to the computer.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function Set-MDTLocationPackage
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
            Set-MDTArray -Id $Id -Type 'L' -Table 'Settings_Packages' -Column 'Packages' -Array $Packages -Confirm:$false
            Write-Output "Updated packages for location with ID [$Id]."
        }
    }
}
