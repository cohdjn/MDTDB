<#
    .SYNOPSIS
        Remove all administrators from an existing computer entry.

    .DESCRIPTION
        Remove all administrators from an existing computer entry.

    .EXAMPLE
        PS C:\> Get-MDTComputer -AssetTag '123ABC' | Clear-MDTComputerAdministrator

    .PARAMETER Id
        Specifies the ID of the computer to delete administrators from.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function Clear-MDTComputerAdministrator
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
            Clear-MDTArray -Id $Id -Type 'C' -Table 'Settings_Administrators' -Force
            Write-Output "Removed all administrators from computer ID [$Id]."
        }
    }
}
