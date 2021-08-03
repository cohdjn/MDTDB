@{
    # Script module or binary module file associated with this manifest.
    rootModule        = 'MDTDB.psm1'

    # Version number of this module.
    moduleVersion     = '0.0.1'

    # ID used to uniquely identify this module
    GUID              = '3efe443b-2829-482e-93a6-cce1fbd8aacb'

    # Author of this module
    Author            = 'David Nelson'

    # Company or vendor of this module
    CompanyName       = 'City of Henderson'

    # Copyright statement for this module
    Copyright         = '(c) 2021 City of Henderson. All rights reserved and all your base are belong to us.'

    # Description of the functionality provided by this module
    Description       = 'Provides cmdlets manipulate the Microsoft Deployment Toolkit database.'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '4.0'

    # Minimum version of the common language runtime (CLR) required by this module
    CLRVersion        = '4.0'

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = @(
        'Clear-MDTComputerAdministrator',
        'Clear-MDTComputerApplication',
        'Clear-MDTComputerPackage',
        'Clear-MDTComputerRole',
        'Clear-MDTLocationAdministrator',
        'Clear-MDTLocationApplication',
        'Clear-MDTLocationPackage',
        'Clear-MDTLocationRole',
        'Clear-MDTMakeModelAdministrator',
        'Clear-MDTMakeModelApplication',
        'Clear-MDTMakeModelPackage',
        'Clear-MDTMakeModelRole',
        'Clear-MDTRoleAdministrator',
        'Clear-MDTRoleApplication',
        'Clear-MDTRolePackage',
        'Clear-MDTRoleRole',
        'Connect-MDTDatabase',
        'Get-MDTComputer',
        'Get-MDTComputerAdministrator',
        'Get-MDTComputerApplication',
        'Get-MDTComputerPackage',
        'Get-MDTComputerRole',
        'Get-MDTLocationAdministrator',
        'Get-MDTLocationApplication',
        'Get-MDTLocationPackage',
        'Get-MDTLocationRole',
        'Get-MDTMakeModel',
        'Get-MDTMakeModelAdministrator',
        'Get-MDTMakeModelApplication',
        'Get-MDTMakeModelPackage',
        'Get-MDTMakeModelRole',
        'Get-MDTPackageMapping',
        'Get-MDTRole',
        'Get-MDTRoleAdministrator',
        'Get-MDTRoleApplication',
        'Get-MDTRolePackage',
        'Get-MDTRoleRole',
        'New-MDTComputer',
        'New-MDTLocation',
        'New-MDTMakeModel',
        'New-MDTPackageMapping',
        'New-MDTRole',
        'Remove-MDTComputer',
        'Remove-MDTLocation',
        'Remove-MDTMakeModel',
        'Remove-MDTPackageMapping',
        'Remove-MDTRole',
        'Set-MDTComputer',
        'Set-MDTComputerAdministrator',
        'Set-MDTComputerApplication',
        'Set-MDTComputerIdentity',
        'Set-MDTComputerPackage',
        'Set-MDTComputerRole',
        'Set-MDTLocation',
        'Set-MDTLocationAdministrator',
        'Set-MDTLocationApplication',
        'Set-MDTLocationPackage',
        'Set-MDTLocationRole',
        'Set-MDTMakeModel',
        'Set-MDTMakeModelAdministrator',
        'Set-MDTMakeModelApplication',
        'Set-MDTMakeModelPackage',
        'Set-MDTMakeModelRole',
        'Set-MDTPackageMapping',
        'Set-MDTRole',
        'Set-MDTRoleAdministrator',
        'Set-MDTRoleApplication',
        'Set-MDTRolePackage',
        'Set-MDTRoleRole'
    )

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport   = @()

    # Variables to export from this module
    VariablesToExport = @()

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport   = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData = @{

        PSData = @{
            # Set to a prerelease string value if the release should be a prerelease.
            Prerelease   = ''

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags         = @('Deployment', 'MDT')

            # ReleaseNotes of this module
            ReleaseNotes = ''

        } # End of PSData hashtable
    } # End of PrivateData hashtable
}
