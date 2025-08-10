
<#
.SYNOPSIS
    This PowerShell script configures the system to lock user accounts for at least 15 minutes (or until manually unlocked) after a specified number of failed login attempts.

.NOTES
    Author          : Malcolm Warren
    LinkedIn        : linkedin.com/in/malcolm-warren-nsu/
    GitHub          : github.com/MalcWarren22
    Date Created    : 2025-08-10
    Last Modified   : 2025-08-10
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-AC-000005

.TESTED ON
    Date(s) Tested  : 2025-08-10
    Tested By       : Malcolm Warren
    Systems Tested  : Windows 10 Pro, Build 22H2
    PowerShell Ver. : 5.1.17763.6189

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-AC-000005/.ps1 
#>

# STIG: WN10-AC-000005
# Policy: Account lockout duration = 15 minutes or greater, or 0 (manual unlock)

$desiredDuration = 15  # You can change this to 0 if using manual unlock policy

try {
    # Set the lockout duration
    net accounts /lockoutduration:$desiredDuration | Out-Null

    # Get current value to verify
    $output = net accounts
    $lockoutDurationLine = ($output | Select-String "Lockout duration").ToString()
    $currentValue = ($lockoutDurationLine -split ":")[1].Trim() -replace "minutes", "" -replace "\s", ""

    if ($currentValue -eq "0" -or [int]$currentValue -ge $desiredDuration) {
        Write-Host "STIG WN10-AC-000005 remediated successfully."
        Write-Host "    Account lockout duration set to $currentValue minute(s)."
    } else {
        Write-Host "Failed to set Account lockout duration. Current value: $currentValue minute(s)"
        exit 1
    }
} catch {
    Write-Host "Error occurred while setting Account lockout duration."
    Write-Host "    Error: $_"
    exit 1
}
