
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

    if ($currentSSID -eq "") {
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

function Watch-Band() {
    Write-Host "Monitoring WiFi band... (close powershell window to stop)"

    while ($true) {
        $wifiDetails = netsh wlan show interfaces
        $band = ($wifiDetails | Select-String 'Band' | Select-Object -First 1).ToString().Split(':')[1].Trim()
        $time = Get-Date -Format "HH:mm:ss"
        if ($band -eq "2.4 GHz") {
            Write-Host "[$time] 2.4 GHz band detected, restarting WiFi for better performance"
            Restart-Wifi
        }
        elseif ($band -eq "5 GHz") {
            Write-Host "[$time] 5 GHz band detected, no action needed"
        }
        else {
            Write-Host "[$time] Unknown band detected"
        }

        Start-Sleep -Seconds 10
    }
}

while ($true) {
    $userInput = Read-Host "Command (info, bounce, watch-band, exit)"
    if ($userInput -eq 'info') {
        Get-WifiDetails
    }
    elseif ($userInput -eq 'bounce') {
        Restart-Wifi
    }
    elseif ($userInput -eq 'watch-band') {
        Watch-Band
    }
    elseif ($userInput -eq 'exit') {
        break
    } 
}
