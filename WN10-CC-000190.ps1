<#
.SYNOPSIS
    This PowerShell script configures the Windows Registry to disable AutoPlay on all drives.
    
.NOTES
    Author          : Malcolm Warren
    LinkedIn        : linkedin.com/in/malcolm-warren-nsu/
    GitHub          : github.com/MalcWarren22
    Date Created    : 2025-08-10
    Last Modified   : 2025-08-10
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000190

.TESTED ON
    Date(s) Tested  : 2025-08-10
    Tested By       : Malcolm Warren
    Systems Tested  : Windows 10 Pro, Build 22H2
    PowerShell Ver. : 5.1.17763.6189

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-CC-000190/.ps1 
#>

# Define AutoPlay STIG registry setting
$autoPlaySetting = @{
    Path  = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
    Name  = "NoDriveTypeAutoRun"
    Value = 255  # Decimal value for 'All Drives'
}

# Create the registry path if it doesn't exist
if (-not (Test-Path $autoPlaySetting.Path)) {
    New-Item -Path $autoPlaySetting.Path -Force | Out-Null
}

# Set the registry value
Set-ItemProperty -Path $autoPlaySetting.Path -Name $autoPlaySetting.Name -Value $autoPlaySetting.Value -Type DWord

Write-Host "Set $($autoPlaySetting.Name) to $($autoPlaySetting.Value) at $($autoPlaySetting.Path) for 'Turn off AutoPlay' STIG compliance."
