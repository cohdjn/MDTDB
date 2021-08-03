<#
    .SYNOPSIS
        Remove all applications from an existing make and model.

    .DESCRIPTION
        Remove all applications from an existing make and model.

    .EXAMPLE
        PS C:\> Get-MDTMakeModel -Make 'Microsoft' -Model 'Virtual Machine' | Clear-MDTMakeModelAdministrator

    .PARAMETER Id
        Specifies the ID of the make/model to delete the administrators from.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function Clear-MDTMakeModelAdministrator
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
        if ($Force -or $PSCmdlet.ShouldProcess('All Administrators'))
        {
            Clear-MDTArray -Id $Id -Type 'M' -Table 'Settings_Administrators' -Force
            Write-Output "Removed all administrators from make/model ID [$Id]."
        }
    }
}
