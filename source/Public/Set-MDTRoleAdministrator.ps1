<#
    .SYNOPSIS
        Modify the administrators of an existing role.

    .DESCRIPTION
        Modify the administrators of an existing role.

    .EXAMPLE
        PS C:\> Get-MDTRole -Name 'Laptops' | Set-MDTRoleAdministrator -Administrators @('A','B')

    .PARAMETER Id
        Specifies the ID to modify.

    .PARAMETER Administrators
        Specifies the administrators to add to the role.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function Set-MDTRoleAdministrator
{
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]

    param
    (
        [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
        [System.String]
        $Id,

        [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
        [System.Array]
        $Administrators,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force
    )

    process
    {
        if ($Force -or $PSCmdlet.ShouldProcess($Id))
        {
            Set-MDTArray -Id $Id -Type 'R' -Table 'Settings_Administrators' -Column 'Administrators' -Array $Administrators -Confirm:$false
            Write-Output "Updated administrators for role with ID [$Id]."
        }
    }
}
