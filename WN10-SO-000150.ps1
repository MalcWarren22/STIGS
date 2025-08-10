<#
.SYNOPSIS
    This PowerShell script ensures that anonymous users are not allowed to enumerate SAM accounts

.NOTES
    Author          : Malcolm Warren
    LinkedIn        : linkedin.com/in/malcolm-warren-nsu/
    GitHub          : github.com/MalcWarren22
    Date Created    : 2025-08-10
    Last Modified   : 2025-08-10
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-SO-000150

.TESTED ON
    Date(s) Tested  : 2025-08-10
    Tested By       : Malcolm Warren
    Systems Tested  : Windows 10 Pro, Build 22H2
    PowerShell Ver. : 5.1.17763.6189

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-SO-000150/.ps1 
#>

# STIG: WN10-SO-000150
# Policy: Do not allow anonymous enumeration of SAM accounts and shares = Enabled

$stigSetting = @{
    Path  = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
    Name  = "RestrictAnonymousSAM"
    Value = 1  # 1 = Enabled
}

# Create the registry path if it doesn't exist
if (-not (Test-Path $stigSetting.Path)) {
    try {
        New-Item -Path $stigSetting.Path -Force | Out-Null
        Write-Host "Created missing registry path: $($stigSetting.Path)"
    } catch {
        Write-Host "Failed to create registry path: $($stigSetting.Path)"
        exit 1
    }
}

# Try to set the registry value
try {
    Set-ItemProperty -Path $stigSetting.Path -Name $stigSetting.Name -Value $stigSetting.Value -Type DWord

    # Verify the value was set correctly
    $actualValue = (Get-ItemProperty -Path $stigSetting.Path -Name $stigSetting.Name).$($stigSetting.Name)

    if ($actualValue -eq $stigSetting.Value) {
        Write-Host "STIG WN10-SO-000150 remediated successfully."
        Write-Host "    Set $($stigSetting.Name) = $($stigSetting.Value) at $($stigSetting.Path)"
    } else {
        Write-Host "Value mismatch after setting. Expected: $($stigSetting.Value), Found: $actualValue"
        exit 1
    }
} catch {
    Write-Host "Failed to set registry value $($stigSetting.Name) at $($stigSetting.Path)"
    Write-Host "    Error: $_"
    exit 1
}
