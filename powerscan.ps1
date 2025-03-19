# Prompt for IP address and ports
$ipAddress = Read-Host "Enter the IP address to scan"
$portsInput = Read-Host "Enter the ports to scan (comma-separated, e.g., 22,80,443)"

# Convert comma-separated ports to an array of integers
$ports = $portsInput.Split(',') | ForEach-Object { [int]$_.Trim() }

# Iterate through the ports
foreach ($port in $ports) {
    # Test the port
    try {
        $tcpClient = New-Object System.Net.Sockets.TcpClient
        $tcpClient.Connect($ipAddress, $port)
        if ($tcpClient.Connected) {
            Write-Host "Port $port is open on $ipAddress"
            $tcpClient.Close()
        }
    }
    catch {
        # Port is closed or host is unreachable
        #Write-Host "Port $port is closed or host unreachable on $ipAddress"
    }
    finally{
        if($tcpClient -and $tcpClient.Connected){
            $tcpClient.Close()
        }
    }
}

Write-Host "Scan completed."
