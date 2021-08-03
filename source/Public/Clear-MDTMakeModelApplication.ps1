<#
    .SYNOPSIS
        Remove all applications from an existing make and model.

    .DESCRIPTION
        Remove all applications from an existing make and model.

    .EXAMPLE
        PS C:\> Get-MDTMakeModel -Make 'Microsoft' -Model 'Virtual Machine' | Clear-MDTMakeModelApplication

    .PARAMETER Id
        Specifies the ID of the make/model to delete applications from.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function Clear-MDTMakeModelApplication
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
        if ($Force -or $PSCmdlet.ShouldProcess('All Applilcations'))
        {
            Clear-MDTArray -Id $Id -Type 'M' -Table 'Settings_Applications' -Force
            Write-Output "Removed all applications from make/model ID [$Id]."
        }
    }
}
