
function Get-WifiDetails() {
    # Get the name of the current WiFi network
    $wifiDetails = netsh wlan show interfaces
    $currentSSID = ($wifiDetails | Select-String 'SSID' | Select-Object -First 1).ToString().Split(':')[1].Trim()
    $signal = ($wifiDetails | Select-String 'Signal' | Select-Object -First 1).ToString().Split(':')[1].Trim()
    $channel = ($wifiDetails | Select-String 'Channel' | Select-Object -First 1).ToString().Split(':')[1].Trim()
    $band = ($wifiDetails | Select-String 'Band' | Select-Object -First 1).ToString().Split(':')[1].Trim()
    $receiveRate = ($wifiDetails | Select-String 'Receive rate' | Select-Object -First 1).ToString().Split(':')[1].Trim()

    Write-Host "SSID    Signal   Channel     Band    Receive Rate"
    Write-Host "$currentSSID    $signal     $channel        $band       $receiveRate"
}

function Restart-Wifi() {
    $currentSSID = (netsh wlan show interfaces | Select-String 'SSID' | Select-Object -First 1).ToString().Split(':')[1].Trim()

    if($currentSSID -eq "") {
        Write-Host "No WiFi network connected so not bouncing"
        return
    }
    # Disconnect from the current WiFi network
    netsh wlan disconnect
    Write-Host "Disconnected from WiFi network: $currentSSID"
    # Wait for a few seconds to ensure disconnection
    Start-Sleep -Seconds 5

    # Reconnect to the WiFi network
    netsh wlan connect name=$currentSSID
    Write-Host "Reconnecting to WiFi network: $currentSSID"
}

while ($true) {
    $input = Read-Host "Command (info, bounce, exit)"
    if ($input -eq 'info') {
        Get-WifiDetails
    } elseif ($input -eq 'bounce') {
        Restart-Wifi
    } elseif ($input -eq 'exit') {
        break
    } Start-Sleep -Seconds 1
}
