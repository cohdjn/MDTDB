<#
    .SYNOPSIS
        Modify the list of packages for an existing make and model.

    .DESCRIPTION
        Modify the list of packages for an existing make and model.

    .EXAMPLE
        PS C:\> Get-MDTMakeModel -Make 'Microsoft' -Model 'Virtual Machine' | Set-MDTMakeModelPackage -Packages @('P','Q','R')

    .PARAMETER Id
        Specifies the ID to modify.

    .PARAMETER Packages
        Specifies the packages to add to the make and model.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function Set-MDTMakeModelPackage
{
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]

    param
    (
        [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
        [System.STring]
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
            Set-MDTArray -Id $Id -Type 'M' -Table 'Settings_Packages' -Column 'Packages' -Array $Packages -Confirm:$false
            Write-Output "Updated packages for make/model with ID [$Id]."
        }
    }
}
