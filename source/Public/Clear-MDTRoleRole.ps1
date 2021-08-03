<#
    .SYNOPSIS
        Remove all roles from an existing role.

    .DESCRIPTION
        Remove all roles from an existing role.

    .EXAMPLE
        PS C:\> Get-MDTRole -Name 'Laptops' | Clear-MDTRoleRole

    .PARAMETER Id
        Specifies the ID of the role to delete the roles from.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function Clear-MDTRoleRole
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
            Clear-MDTArray -Id $Id -Type 'R' -Table 'Settings_Roles' -Force
            Write-Output "Removed all roles from role ID [$Id]."
        }
    }
}
