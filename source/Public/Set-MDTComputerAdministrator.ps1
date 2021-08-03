<#
    .SYNOPSIS
        Modify the list of administrators for an existing computer entry.

    .DESCRIPTION
        Modify the list of administrators for an existing computer entry.

    .EXAMPLE
        PS C:\> Get-MDTComputer -AssetTag '123ABC' | Set-MDTComputerAdministrator -Administrators @('A','B')

    .PARAMETER Id
        Specifies the ID to modify.

    .PARAMETER Administrators
        Specifies the administrators to add to the computer.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function Set-MDTComputerAdministrator
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
            Set-MDTArray -Id $Id -Type 'C' -Table 'Settings_Administrators' -Column 'Administrators' -Array $Administrators -Confirm:$false
            Write-Output "Updated administrators for computer with ID [$Id]."
        }
    }
}
