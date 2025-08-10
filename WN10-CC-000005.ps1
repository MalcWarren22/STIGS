<#
.SYNOPSIS
    This PowerShell script disables camera access from the lock screen.

.NOTES
    Author          : Malcolm Warren
    LinkedIn        : linkedin.com/in/malcolm-warren-nsu/
    GitHub          : github.com/MalcWarren22
    Date Created    : 2025-08-10
    Last Modified   : 2025-08-10
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000005

.TESTED ON
    Date(s) Tested  : 2025-08-10
    Tested By       : Malcolm Warren
    Systems Tested  : Windows 10 Pro, Build 22H2
    PowerShell Ver. : 5.1.17763.6189

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-CC-000005/.ps1 
#>

$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"
$registryName = "NoLockScreenCamera"
$expectedValue = 1

# Check if the registry path exists
if (Test-Path $registryPath) {
    $currentSetting = Get-ItemProperty -Path $registryPath -Name $registryName -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $registryName -ErrorAction SilentlyContinue
} else {
    $currentSetting = $null
}

if ($currentSetting -eq $expectedValue) {
    Write-Host "STIG WN10-CC-000005 already compliant. Camera access from lock screen is disabled."
} else {
    try {
        # Ensure the registry path exists
        if (-not (Test-Path $registryPath)) {
            New-Item -Path $registryPath -Force | Out-Null
        }

        # Set the registry value to disable camera on lock screen
        New-ItemProperty -Path $registryPath -Name $registryName -PropertyType DWord -Value $expectedValue -Force | Out-Null

        # Verify the setting
        $newSetting = Get-ItemProperty -Path $registryPath -Name $registryName | Select-Object -ExpandProperty $registryName
        if ($newSetting -eq $expectedValue) {
            Write-Host "STIG WN10-CC-000005 remediated successfully."
            Write-Host "    '$registryName' set to $expectedValue at $registryPath"
        } else {
            Write-Host "Failed to remediate STIG WN10-CC-000005. Registry value not set correctly."
            exit 1
        }
    } catch {
        Write-Host "Error while setting registry value for STIG WN10-CC-000005."
        Write-Host "    $_"
        exit 1
    }
}
