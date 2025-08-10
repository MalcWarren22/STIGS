<#
.SYNOPSIS
    This PowerShell script ensures that auditing for successful use of the Security System Extension subcategory is enabled.
.NOTES
    Author          : Malcolm Warren
    LinkedIn        : linkedin.com/in/malcolm-warren-nsu/
    GitHub          : github.com/MalcWarren22
    Date Created    : 2025-08-10
    Last Modified   : 2025-08-10
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-AU-000150

.TESTED ON
    Date(s) Tested  : 2025-08-10
    Tested By       : Malcolm Warren
    Systems Tested  : Windows 10 Pro, Build 22H2
    PowerShell Ver. : 5.1.17763.6189

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-AU-000150/.ps1 
#>

$subcategory = "Security System Extension"

# Get current audit policy setting
$currentSetting = auditpol /get /subcategory:"$subcategory" 2>&1

if ($currentSetting -match "Success") {
    Write-Host "STIG WN10-AU-000150 already compliant. 'Success' auditing is enabled for '$subcategory'."
} else {
    try {
        # Set the audit policy to enable Success auditing
        auditpol /set /subcategory:"$subcategory" /success:enable | Out-Null

        # Verify the new setting
        $newSetting = auditpol /get /subcategory:"$subcategory" 2>&1
        if ($newSetting -match "Success") {
            Write-Host "STIG WN10-AU-000150 remediated successfully."
            Write-Host "    Audit policy '$subcategory' set to: Success"
        } else {
            Write-Host "Failed to enable 'Success' auditing for '$subcategory'."
            exit 1
        }
    } catch {
        Write-Host "Error while setting audit policy for '$subcategory'."
        Write-Host "    $_"
        exit 1
    }
}
