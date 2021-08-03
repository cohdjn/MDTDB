<#
    .SYNOPSIS
        Remove all applications from an existing location.

    .DESCRIPTION
        Remove all applications from an existing location.

    .EXAMPLE
        PS C:\> Get-MDTLocation -Name 'Portland' | Clear-MDTLocationApplication

    .PARAMETER Id
        Specifies the ID of the location to delete applications from.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function Clear-MDTLocationApplication
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
            Clear-MDTArray -Id $Id -Type 'L' -Table 'Settings_Applications' -Force
            Write-Output "Removed all applications from location ID [$Id]."
        }
    }
}
