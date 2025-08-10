<#
.SYNOPSIS
    This PowerShell script ensures that the maximum size of the Windows Application event log is at least 32768 KB (32 MB).

.NOTES
    Author          : Malcolm Warren
    LinkedIn        : linkedin.com/in/malcolm-warren-nsu/
    GitHub          : github.com/MalcWarren22
    Date Created    : 2025-08-10
    Last Modified   : 2025-08-10
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-AU-000500

.TESTED ON
    Date(s) Tested  : 2025-08-10
    Tested By       : Malcolm Warren
    Systems Tested  : Windows 10 Pro, Build 22H2
    PowerShell Ver. : 5.1.17763.6189

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-AU-000500.ps1 
#>

# Define Registry Path and Value
$logSettings = @(
    @{ Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application"; Name = "MaxSize"; Value = 32768 },
    @{ Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Security";    Name = "MaxSize"; Value = 32768 },
    @{ Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\System";      Name = "MaxSize"; Value = 32768 }
)

foreach ($log in $logSettings) {
    # Create the registry path if it doesn't exist
    if (-not (Test-Path $log.Path)) {
        New-Item -Path $log.Path -Force | Out-Null
    }
    # Set the MaxSize value
    Set-ItemProperty -Path $log.Path -Name $log.Name -Value $log.Value -Type DWord
    Write-Host "Set $($log.Name) to $($log.Value) KB for $($log.Path)"
}

Write-Host "Event log sizes configured for Application, Security, and System logs."

