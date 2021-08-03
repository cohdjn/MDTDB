<#
    .SYNOPSIS
        Modify the list of roles for an existing location.

    .DESCRIPTION
        Modify the list of roles for an existing location.

    .EXAMPLE
        PS C:\> Get-MDTLocation -Name 'Portland' | Set-MDTLocationRole -Roles @('R','S','T')

    .PARAMETER Id
        Specifies the ID to modify.

    .PARAMETER Roles
        Specifies the roles to add to the computer.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function Set-MDTLocationRole
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
            Set-MDTArray -Id $Id -Type 'L' -Table 'Settings_Roles' -Column 'Role' -Array $Roles -Confirm:$false
            Write-Output "Updated roles for location with ID [$Id]."
        }
    }
}
