$ErrorActionPreference = 'Stop'
Import-Module "$PSScriptRoot/../sources/IntuneSystemTrayV2/IntuneSystemTrayV2/SystemInfo.psm1" -Force

$adapters = @(
    [pscustomobject]@{ IPEnabled = $true; InterfaceIndex = 20; Index = 20; IPAddress = @('fe80::1', '10.0.0.20') },
    [pscustomobject]@{ IPEnabled = $true; InterfaceIndex = 10; Index = 10; IPAddress = @('169.254.2.4', '192.168.1.8') }
)

$ip = Select-PrimaryIPv4Address -Adapter $adapters
if ($ip -ne '192.168.1.8') {
    throw "Expected the first usable IPv4 address, got '$ip'."
}

$missingIp = Select-PrimaryIPv4Address -Adapter @()
if ($missingIp -ne 'N/A') {
    throw "Expected N/A when no adapter exists, got '$missingIp'."
}

$hotFixes = @(
    [pscustomobject]@{ InstalledOn = [datetime]'2025-01-01T10:00:00' },
    [pscustomobject]@{ InstalledOn = [datetime]'2025-02-03T14:30:00' }
)
$lastUpdate = Format-LastUpdateInstallation -HotFix $hotFixes
if ($lastUpdate -ne '2025.02.03 14:30') {
    throw "Expected latest update timestamp, got '$lastUpdate'."
}

if ((Format-LastUpdateInstallation -HotFix @()) -ne 'N/A') {
    throw 'Expected N/A when no hotfix exists.'
}

Write-Host 'System information helpers passed.'
