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

# STIG: WN10-SO-000120
# Policy: Microsoft network server: Digitally sign communications (always) = Enabled

$setting = @{
    Path  = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"
    Name  = "RequireSecuritySignature"
    Value = 1  # 1 = Enabled
}

# Create the registry path if it doesn't exist
if (-not (Test-Path $setting.Path)) {
    try {
        New-Item -Path $setting.Path -Force | Out-Null
        Write-Host "✅ Created missing registry path: $($setting.Path)"
    } catch {
        Write-Host "❌ Failed to create registry path: $($setting.Path)"
        exit 1
    }
}

# Try to set the registry value
try {
    Set-ItemProperty -Path $setting.Path -Name $setting.Name -Value $setting.Value -Type DWord
    # Confirm the change
    $actualValue = (Get-ItemProperty -Path $setting.Path -Name $setting.Name).$($setting.Name)

    if ($actualValue -eq $setting.Value) {
        Write-Host "✅ STIG WN10-SO-000120 remediated successfully."
        Write-Host "    Set $($setting.Name) = $($setting.Value) at $($setting.Path)"
    } else {
        Write-Host "❌ Value mismatch after setting. Expected: $($setting.Value), Found: $actualValue"
        exit 1
    }
} catch {
    Write-Host "❌ Failed to set registry value $($setting.Name) at $($setting.Path)"
    Write-Host "    Error: $_"
    exit 1
}

