# Prompt for IP address range and ports
$startIP = Read-Host "Enter the starting IP address"
$endIP = Read-Host "Enter the ending IP address"
$portsInput = Read-Host "Enter the ports to scan (comma-separated, e.g., 22,80,443)"
$timeoutMilliseconds = 1000 # Set timeout to 1 second (adjust as needed)

# Convert comma-separated ports to an array of integers
$ports = $portsInput.Split(',') | ForEach-Object { [int]$_.Trim() }

# Convert IP addresses to IPAddress objects
$startIPObj = [ipaddress]$startIP
$endIPObj = [ipaddress]$endIP

# Convert IP addresses to integers for easier iteration
$startIPInt = [BitConverter]::ToInt32([System.Net.IPAddress]::Parse($startIP).GetAddressBytes(), 0)
$endIPInt = [BitConverter]::ToInt32([System.Net.IPAddress]::Parse($endIP).GetAddressBytes(), 0)

# Iterate through the IP range
for ($ipInt = $startIPInt; $ipInt -le $endIPInt; $ipInt++) {
    # Convert integer back to IP address
    $ipBytes = [BitConverter]::GetBytes($ipInt)
    [Array]::Reverse($ipBytes) # Reverse the byte order
    $ip = [System.Net.IPAddress]::Parse(($ipBytes | ForEach-Object { $_.ToString() }) -join ".")

    # Iterate through the ports
    foreach ($port in $ports) {
        # Test the port with timeout using ConnectAsync and Task
        try {
            $tcpClient = New-Object System.Net.Sockets.TcpClient
            $connectTask = $tcpClient.ConnectAsync($ip, $port)
            $taskCompleted = $connectTask.Wait($timeoutMilliseconds)

            if ($taskCompleted -and $tcpClient.Connected) {
                Write-Host "Port $port is open on $ip"
                $tcpClient.Close()
            } else {
                #Write-Host "Port $port is closed or timed out on $ip"
            }
        }
        catch {
            #Write-Host "Error connecting to port $port on $ip: $($_.Exception.Message)"
        }
        finally {
            if ($tcpClient -and $tcpClient.Connected) {
                $tcpClient.Close()
            }
        }
    }
}

Write-Host "Scan completed."
