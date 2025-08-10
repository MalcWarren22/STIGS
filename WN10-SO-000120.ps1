<#
.SYNOPSIS
    This PowerShell script configures the system to require a security signature for SMB server communications.

.NOTES
    Author          : Malcolm Warren
    LinkedIn        : linkedin.com/in/malcolm-warren-nsu/
    GitHub          : github.com/MalcWarren22
    Date Created    : 2025-08-10
    Last Modified   : 2025-08-10
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-SO-000120

.TESTED ON
    Date(s) Tested  : 2025-08-10
    Tested By       : Malcolm Warren
    Systems Tested  : Windows 10 Pro, Build 22H2
    PowerShell Ver. : 5.1.17763.6189

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-SO-000120/.ps1 
#>

# Define registry setting for STIG WN10-SO-000120
$serverSignatureSetting = @{
    Path  = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
    Name  = "RequireSecuritySignature"
    Value = 1  # 1 = Enabled
}

# Create the registry path if it doesn't exist
if (-not (Test-Path $serverSignatureSetting.Path)) {
    New-Item -Path $serverSignatureSetting.Path -Force | Out-Null
}

# Set the registry value
Set-ItemProperty -Path $serverSignatureSetting.Path -Name $serverSignatureSetting.Name -Value $serverSignatureSetting.Value -Type DWord

Write-Host "Set $($serverSignatureSetting.Name) to $($serverSignatureSetting.Value) at $($serverSignatureSetting.Path) for STIG WN10-SO-000120 compliance."

