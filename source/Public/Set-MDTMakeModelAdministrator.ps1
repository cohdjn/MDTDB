<#
    .SYNOPSIS
        Modify the list of administrators for an existing make and model.

    .DESCRIPTION
        Modify the list of administrators for an existing make and model.

    .EXAMPLE
        PS C:\> Get-MDTMakeModel -Make 'Microsoft' -Model 'Virtual Machine' | Set-MDTMakeModelAdministrator -Administrators @('A','B')

    .PARAMETER Id
        Specifies the ID to modify.

    .PARAMETER Administrators
        Specifies the administrators to add to the make and model.

    .PARAMETER Force
        Forces execution without prompting for confirmation.
#>
function Set-MDTMakeModelAdministrator
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
            Set-MDTArray -Id $Id -Type 'M' -Table 'Settings_Administrators' -Column 'Administrators' -Array $Administrators -Confirm:$false
            Write-Output "Updated administrators for make/model with ID [$Id]."
        }
    }
}
