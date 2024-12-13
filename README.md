# Wifi Adapter Monitor

This PowerShell script allows you to monitor and manage your WiFi adapter. It provides the following functionalities:
- Display WiFi details
- Restart the WiFi connection
- Monitor the WiFi band and restart if on 2.4 GHz for better performance
- Log a message every 5 seconds while waiting for user input

## Usage

1. Open PowerShell with administrative privileges.
2. Navigate to the directory containing the `Wifi_Adapter_Monitor.ps1` script.
3. Run the script using the following command:
   ```powershell
   .\Wifi_Adapter_Monitor.ps1
   ```

### Commands

Once the script is running, you can use the following commands:

- `info`: Displays the current WiFi details including SSID, signal strength, channel, band, and receive rate.
- `bounce`: Disconnects and reconnects to the current WiFi network.
- `watch-band`: Monitors the WiFi band and restarts the WiFi if it detects a 2.4 GHz band for better performance.
- `exit`: Stops the script.