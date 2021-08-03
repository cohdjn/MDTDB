<#
    .SYNOPSIS
        Modify the list of applications for an existing make and model.

    .DESCRIPTION
        Modify the list of applications for an existing make and model.

    .EXAMPLE
        PS C:\> Get-MDTMakeModel -Make 'Microsoft' -Model 'Virtual Machine' | Set-MDTMakeModelApplication -Applications @('A','B','C')

    .PARAMETER Id
        Specifies the ID to modify.

    .PARAMETER Applications
        Specifies the applications to add to the make and model.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function Set-MDTMakeModelApplication
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
            Set-MDTArray -Id $Id -Type 'M' -Table 'Settings_Applications' -Column 'Applications' -Array $Applications -Confirm:$false
            Write-Output "Updated applications for make/model with ID [$Id]."
        }
    }
}
