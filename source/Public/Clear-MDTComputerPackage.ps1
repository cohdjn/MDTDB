<#
    .SYNOPSIS
        Remove all packages from an existing computer entry.

    .DESCRIPTION
        Remove all packages from an existing computer entry.

    .EXAMPLE
        PS C:\> Get-MDTComputer -AssetTag '789XYZ' | Clear-MDTComputerPackage

    .PARAMETER Id
        Specifies the ID of the computer to delete the packages from.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function Clear-MDTComputerPackage
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
            Clear-MDTArray -Id $Id -Type 'C' -Table 'Settings_Packages' -Force
            Write-Output "Removed all packages from computer ID [$Id]."
        }
    }
}
