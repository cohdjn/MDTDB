<#
    .SYNOPSIS
        Modify the list of applications for an existing location.

    .DESCRIPTION
        Modify the list of applications for an existing location.

    .EXAMPLE
        PS C:\> Get-MDTLocation -Name 'Portland' | Set-MDTLocationApplication -Applications @('A','B','C')

    .PARAMETER Id
        Specifies the ID to modify.

    .PARAMETER Applications
        Specifies the applications to add to the computer.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function Set-MDTLocationApplication
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
            Set-MDTArray -Id $Id -Type 'L' -Table 'Settings_Applications' -Column 'Applications' -Array $Applications -Confirm:$false
            Write-Output "Updated applications for location with ID [$Id]."
        }
    }
}
