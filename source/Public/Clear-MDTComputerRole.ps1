<#
    .SYNOPSIS
        Remove all roles from an existing computer entry.

    .DESCRIPTION
        Remove all roles from an existing computer entry.

    .EXAMPLE
        PS C:\> Get-MDTComputer -AssetTag '123ABC' | Clear-MDTComputerRole

    .PARAMETER Id
        Specifies the ID of the computer to delete the roles from.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function Clear-MDTComputerRole
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
        if ($Force -or $PSCmdlet.ShouldProcess('All Roles'))
        {
            Clear-MDTArray -Id $Id -Type 'C' -Table 'Settings_Roles' -Force
            Write-Output "Removed all roles from computer ID [$Id]."
        }
    }
}
