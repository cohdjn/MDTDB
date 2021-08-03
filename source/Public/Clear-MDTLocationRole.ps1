<#
    .SYNOPSIS
        Remove all roles from an existing location.

    .DESCRIPTION
        Remove all roles from an existing location.

    .EXAMPLE
        PS C:\> Get-MDTLocation -Name 'Portland' | Clear-MDTLocationRole

    .PARAMETER Id
        Specifies the ID of the location to delete the roles from.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function Clear-MDTLocationRole
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
            Clear-MDTArray -Id $Id -Type 'L' -Table 'Settings_Roles' -Force
            Write-Output "Removed all roles from location ID [$Id]."
        }
    }
}
