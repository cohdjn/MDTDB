<#
    .SYNOPSIS
        Remove all administrators from an existing location.

    .DESCRIPTION
        Remove all administrators from an existing location.

    .EXAMPLE
        PS C:\> Get-MDTLocation -Name 'Portland' | Clear-MDTLocationAdministrator

    .PARAMETER Id
        Specifies the ID of the location to delete administrators from.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function Clear-MDTLocationAdministrator
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
        if ($Force -or $PSCmdlet.ShouldProcess('All Administrators'))
        {
            Clear-MDTArray -Id $Id -Type 'L' -Table 'Settings_Administrators' -Force
            Write-Output "Removed all administrators from location ID [$Id]."
        }
    }
}
