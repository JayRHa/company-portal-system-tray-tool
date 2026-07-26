function Select-PrimaryIPv4Address {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        [object[]]$Adapter
    )

    $addresses = @($Adapter) |
        Where-Object { $_.IPEnabled } |
        Sort-Object InterfaceIndex, Index |
        ForEach-Object { $_.IPAddress } |
        Where-Object {
            $_ -match '^\d{1,3}(\.\d{1,3}){3}$' -and
            $_ -notmatch '^127\.' -and
            $_ -notmatch '^169\.254\.'
        }

    $primaryAddress = $addresses | Select-Object -First 1
    if ($primaryAddress) { return $primaryAddress }
    return 'N/A'
}

function Get-PrimaryIPv4Address {
    [CmdletBinding()]
    param()

    try {
        $adapters = Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter 'IPEnabled = TRUE' -ErrorAction Stop
        return Select-PrimaryIPv4Address -Adapter $adapters
    } catch {
        return 'N/A'
    }
}

function Format-LastUpdateInstallation {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        [object[]]$HotFix
    )

    $installedOn = @($HotFix) |
        Where-Object { $null -ne $_.InstalledOn } |
        Sort-Object InstalledOn -Descending |
        Select-Object -First 1 -ExpandProperty InstalledOn

    if ($null -eq $installedOn) { return 'N/A' }

    try {
        return ([datetime]$installedOn).ToString('yyyy.MM.dd HH:mm')
    } catch {
        return 'N/A'
    }
}

function Get-LastUpdateInstallation {
    [CmdletBinding()]
    param()

    try {
        return Format-LastUpdateInstallation -HotFix (Get-HotFix -ErrorAction Stop)
    } catch {
        return 'N/A'
    }
}

Export-ModuleMember -Function Select-PrimaryIPv4Address, Get-PrimaryIPv4Address, Format-LastUpdateInstallation, Get-LastUpdateInstallation
