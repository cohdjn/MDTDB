<#
    .SYNOPSIS
        Remove all administrators from an existing role.

    .DESCRIPTION
        Remove all administrators from an existing role.

    .EXAMPLE
        PS C:\> Get-MDTRole -Name 'Laptops' | Clear-MDTRoleAdministrator

    .PARAMETER Id
        Specifies the ID of the role to delete administrators from.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function Clear-MDTRoleAdministrator
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
            Clear-MDTArray -Id $Id -Type 'R' -Table 'Settings_Administrators' -Force
            Write-Output "Removed all administrators from role ID [$Id]."
        }
    }
}
