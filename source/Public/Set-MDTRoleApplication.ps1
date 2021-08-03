<#
    .SYNOPSIS
        Modify the applications of an existing role.

    .DESCRIPTION
        Modify the applications of an existing role.

    .EXAMPLE
        PS C:\> Get-MDTRole -Name 'Laptops' | Set-MDTRoleApplication -Applications @('A','B','C')

    .PARAMETER Id
        Specifies the ID to modify.

    .PARAMETER Applications
        Specifies the applications to add to the role.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function Set-MDTRoleApplication
{
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]

    param
    (
        [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
        [System.String]
        $Id,

        [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
        [System.Array]
        $Applications,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force
    )

    process
    {
        if ($Force -or $PSCmdlet.ShouldProcess($Id))
        {
            Set-MDTArray -Id $Id -Type 'R' -Table 'Settings_Applications' -Column 'Applications' -Array $Applications -Confirm:$false
            Write-Output "Updated applications for role with ID [$Id]."
        }
    }
}
