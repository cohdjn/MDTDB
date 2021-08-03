<#
    .SYNOPSIS
        Remove all roles from an existing make and model.

    .DESCRIPTION
        Remove all roles from an existing make and model.

    .EXAMPLE
        PS C:\> Get-MDTMakeModel -Make 'Microsoft' -Model 'Virtual Machine' | Clear-MDTMakeModelRole

    .PARAMETER Id
        Specifies the ID of the make/model to delete the roles from.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function Clear-MDTMakeModelRole
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
        if ($Force -or $PSCmdlet.ShouldProcess('All Roles'))
        {
            Clear-MDTArray -Id $Id -Type 'M' -Table 'Settings_Roles' -Force
            Write-Output "Removed all roles from make/model ID [$Id]."
        }
    }
}
