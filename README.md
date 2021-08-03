# MDTDB

Provides cmdlets manipulate the Microsoft Deployment Toolkit database. This module was originally written by Michael Neuhaus back in 2009 and has been updated to conform to the CI/CD pipeline concept. In most cases, the original contents have been kept with the notable exception of adding parameter validation and variable casting. The original content can be found [here](https://techcommunity.microsoft.com/t5/windows-blog-archive/manipulating-the-microsoft-deployment-toolkit-database-using/ba-p/706876).

## Change Log

A full list of changes in each version can be found in the [change log](CHANGELOG.md).

## Functions

The **MDTDB** module contains the following functions:

- **Connect-MDTDatabase**: Establishes a connection to an MDT database.
- **Computers**
    - **Get-MDTComputer**: Get an existing computer entry, or a list of all computer entries.
    - **New-MDTComputer**: Create a new computer entry.
    - **Remove-MDTComputer**: Remove an existing computer entry.
    - **Set-MDTComputer**: Modify the settings of an existing computer entry.
    - **Clear-MDTComputerApplication**: Remove all applications from an existing computer entry.
    - **Get-MDTComputerApplication**: Get the applications for an existing computer entry.
    - **Set-MDTComputerApplication**: Modify the list of applications for an existing computer entry.
    - **Clear-MDTComputerPackage**: Remove all packages from an existing computer entry.
    - **Get-MDTComputerPackage**: Get the ConfigMgr packages for an existing computer entry.
    - **Set-MDTComputerPackage**: Modify the list of packages for an existing computer entry.
    - **Clear-MDTComputerRole**: Remove all roles from an existing computer entry.
    - **Get-MDTComputerRole.**: Get the list of roles for an existing computer entry.
    - **Set-MDTComputerRole.**: Modify the list of roles for an existing computer entry.
    - **Clear-MDTComputerAdministrator**: Remove all administrators from an existing computer entry.
    - **Get-MDTComputerAdministrator**: Get the list of administrators for an existing computer entry.
    - **Set-MDTComputerAdministrator**: Modify the list of administrators for an existing computer entry.
- **Roles**
    - **Get-MDTRole**: Get an existing role, or a list of all roles.
    - **New-MDTRole**: Create a new role.
    - **Remove-MDTRole**: Remove an existing role.
    - **Set-MDTRole**: Modify the settings of an existing role.
    - **Clear-MDTRoleApplication**: Remove all applications from an existing role.
    - **Get-MDTRoleApplication**: Get the applications for an existing role.
    - **Set-MDTRoleApplication**: Modify the list of application for an existing role.
    - **Clear-MDTRolePackage**: Remove all packages from an existing role.
    - **Get-MDTRolePackage**: Get the ConfigMgr packages for an existing role.
    - **Set-MDTRolePackage**: Modify the list of packages for an existing role.
    - **Clear-MDTRoleRole**: Remove all roles from an existing role.
    - **Get-MDTRoleRole**: Get the list of roles for an existing role.
    - **Set-MDTRoleRole**: Modify the list of roles for an existing role.
    - **Clear-MDTRoleAdministrator**: Remove all administrators from an existing role.
    - **Get-MDTRoleAdministrator**: Get the list of administrators for an existing role.
    - **Set-MDTRoleAdministrator**: Modify the list of administrators for an existing role.
- **Locations**
    - **Get-MDTLocation**: Get an existing location, or a list of locations.
    - **New-MDTLocation**: Create a new location.
    - **Remove-MDTLocation**: Remove an existing location.
    - **Set-MDTLocation**: Modify the settings of an existing location.
    - **Clear-MDTLocationApplication**: Remove all applications from an existing location.
    - **Get-MDTLocationApplication**: Get the applications for an existing location.
    - **Set-MDTLocationApplication**: Modify the list of applications for an existing location.
    - **Clear-MDTLocationPackage**: Remove all packages from an existing location.
    - **Get-MDTLocationPackage**: Get the ConfigMgr packages for an existing location.
    - **Set-MDTLocationPackage**: Modify the list of packages for an existing location.
    - **Clear-MDTLocationRole**: Remove all roles from an existing location.
    - **Get-MDTLocationRole**: Get the roles for an existing location.
    - **Set-MDTLocationRole**: Modify the list of roles for an existing location.
    - **Clear-MDTLocationAdministrator**: Remove all administrators from an existing location.
    - **Get-MDTLocationAdministrator**: Get the administrators for an existing location.
    - **Set-MDTLocationAdministrator**: Modify the list of administrators for an existing location.
- **Makes/Models**
    - **Get-MDTMakeModel**: Get an existing make and model, or a list of all makes and models.
    - **New-MDTMakeModel**: Create a new make and model.
    - **Remove-MDTMakeModel**: Remove an existing make and model.
    - **Set-MDTMakeModel**: Modify the settings of an existing make and model.
    - **Clear-MDTMakeModelApplication**: Remove all applications from an existing make and model.
    - **Get-MDTMakeModelApplication**: Get the applications for an existing make and model.
    - **Set-MDTMakeModelApplication**: Modify the list of applications for an existing make and model.
    - **Clear-MDTMakeModelPackage**: Remove all packages from an existing make and model.
    - **Get-MDTMakeModelPackage**: Get the ConfigMgr packages for an existing make and model.
    - **Set-MDTMakeModelPackage**: Modify the list of packages for an existing make and model.
    - **Clear-MDTMakeModelRole**: Remove all roles from an existing make and model.
    - **Get-MDTMakeModelRole**: Get all roles from an existing make and model.
    - **Set-MDTMakeModelRole**: Modify the list of roles for an existing make and model.
    - **Clear-MDTMakeModelAdministrator**: Remove all administrators from an existing make and model.
    - **Get-MDTMakeModelAdministrator**: Get the administrators for an existing make and model.
    - **Set-MDTMakeModelAdministrator**: Modify the list of administrators for an existing make and model.
- **Packages**
    - **Get-MDTPackageMapping**: Get an existing package mapping, or a list of all package mappings.
    - **New-MDTPackageMapping**: Create a new package mapping.
    - **Remove-MDTPackageMapping**: Remove an existing package mapping.
    - **Set-MDTPackageMapping**: Modify the settings of an existing package mapping.

## Documentation and Examples
For examples on using these functions, check out [about_MDTDB](en-US\about_MDTDB.help.txt).
