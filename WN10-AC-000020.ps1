<#
.SYNOPSIS
    This PowerShell script enforces that the Windows system remembers at least the last 24 unique passwords used by a user, ensuring compliance with password history policy requirements.

.NOTES
    Author          : Malcolm Warren
    LinkedIn        : linkedin.com/in/malcolm-warren-nsu/
    GitHub          : github.com/MalcWarren22
    Date Created    : 2025-08-10
    Last Modified   : 2025-08-10
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-AC-000020

.TESTED ON
    Date(s) Tested  : 2025-08-10
    Tested By       : Malcolm Warren
    Systems Tested  : Windows 10 Pro, Build 22H2
    PowerShell Ver. : 5.1.17763.6189

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-AC-000020/.ps1 
#>

# STIG: WN10-AC-000020
# Policy: Enforce password history = 24 passwords remembered

$desiredHistoryCount = 24

try {
    # Set the password history using 'net accounts'
    net accounts /uniquepw:$desiredHistoryCount | Out-Null

    # Verify the current value
    $output = net accounts
    $passwordHistoryLine = ($output | Select-String "Length of password history maintained").ToString()
    $currentValue = ($passwordHistoryLine -split ":")[1].Trim() -replace "\D", ""

    if ([int]$currentValue -ge $desiredHistoryCount) {
        Write-Host "STIG WN10-AC-000020 remediated successfully."
        Write-Host "    Enforce password history set to $currentValue password(s) remembered."
    } else {
        Write-Host "Failed to enforce password history. Current value: $currentValue"
        exit 1
    }
} catch {
    Write-Host "Error occurred while setting password history."
    Write-Host "    Error: $_"
    exit 1
}
