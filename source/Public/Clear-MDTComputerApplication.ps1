<#
    .SYNOPSIS
        Remove all applications from an existing computer entry.

    .DESCRIPTION
        Remove all applications from an existing computer entry.

    .EXAMPLE
        PS C:\> Get-MDTComputer -AssetTag '789XYZ' | Clear-MDTComputerApplication

    .PARAMETER Id
        Specifies the ID of the computer to delete applications from.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function Clear-MDTComputerApplication
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
        if ($Force -or $PSCmdlet.ShouldProcess('All Applications'))
        {
            Clear-MDTArray -Id $Id -Type 'C' -Table 'Settings_Applications' -Force
            Write-Output "Removed all applications from computer ID [$Id]."
        }
    }
}
