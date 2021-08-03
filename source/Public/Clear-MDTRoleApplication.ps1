<#
    .SYNOPSIS
        Remove all applications from an existing role.

    .DESCRIPTION
        Remove all applications from an existing role.

    .EXAMPLE
        PS C:\> Get-MDTRole -Name 'Laptops' | Clear-MDTRoleApplication

    .PARAMETER Id
        Specifies the ID of the role to delete applications from.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function Clear-MDTRoleApplication
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
        if ($Force -or $PSCmdlet.ShouldProcess('All Applications'))
        {
            Clear-MDTArray -Id $Id -Type 'R' -Table 'Settings_Applications' -Force
            Write-Output "Removed all applications from role ID [$Id]."
        }
    }
}
