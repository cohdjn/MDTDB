<#
    .SYNOPSIS
        Modify the list of roles for an existing computer entry.

    .DESCRIPTION
        Modify the list of roles for an existing computer entry.

    .EXAMPLE
        PS C:\> Get-MDTComputer -AssetTag '123ABC' | Set-MDTComputerRole -Roles @('R','S','T')

    .PARAMETER Id
        Specifies the ID to modify.

    .PARAMETER Roles
        Specifies the roles to add to the computer.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function Set-MDTComputerRole
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
            Set-MDTArray -Id $Id -Type 'C' -Table 'Settings_Roles' -Column 'Role' -Array $Roles -Confirm:$false
            Write-Output "Updated roles for computer with ID [$Id]."
        }
    }
}
