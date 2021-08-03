<#
    .SYNOPSIS
        Modify the roles of an existing role.

    .DESCRIPTION
        Modify the roles of an existing role in the database.

    .EXAMPLE
        PS C:\> Get-MDTRole -Name 'Laptops' | Set-MDTRoleRole -Roles @('R','S','T')

    .PARAMETER Id
        Specifies the ID to modify.

    .PARAMETER Roles
        Specifies the roles to add to the role.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function Set-MDTRoleRole
{
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]

    param
    (
        [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
        [System.String]
        $Id,

        [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
        [System.Array]
        $Roles,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force
    )

    process
    {
        if ($Force -or $PSCmdlet.ShouldProcess($Id))
        {
            Set-MDTArray -Id $Id -Type 'R' -Table 'Settings_Roles' -Column 'Role' -Array $Roles -Confirm:$false
            Write-Output "Updated roles for role with ID [$Id]."
        }
    }
}
