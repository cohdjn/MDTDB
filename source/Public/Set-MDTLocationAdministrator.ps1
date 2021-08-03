<#
    .SYNOPSIS
        Modify the list of administrators for an existing location.

    .DESCRIPTION
        Modify the list of administrators for an existing location.

    .EXAMPLE
        PS C:\> Get-MDTLocation -Name 'Portland' | Set-MDTLocationAdministrator -Administrators @('A','B')

    .PARAMETER Id
        Specifies the ID to modify.

    .PARAMETER Administrators
        Specifies the administrators to add to the computer.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function Set-MDTLocationAdministrator
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
            Set-MDTArray -Id $Id -Type 'L' -Table 'Settings_Administrators' -Column 'Administrators' -Array $Administrators -Confirm:$false
            Write-Output "Updated administrators for location with ID [$Id]."
        }
    }
}
