<#
    .SYNOPSIS
        Modify the list of roles for an existing make and model.

    .DESCRIPTION
        Modify the list of roles for an existing make and model.

    .EXAMPLE
        PS C:\> Get-MDTMakeModel -Make 'Microsoft' -Model 'Virtual Machine' | Set-MDTMakeModelRole -Roles @('R','S','T')

    .PARAMETER Id
        Specifies the ID to modify.

    .PARAMETER Roles
        Specifies the roles to add to the make and model.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function Set-MDTMakeModelRole
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
            Set-MDTArray -Id $Id -Type 'M' -Table 'Settings_Roles' -Column 'Role' -Array $Roles -Confirm:$false
            Write-Output "Updated roles for make/model with ID [$Id]."
        }
    }
}
