# Create a listener on port 1522
$listener1 = New-Object System.Net.Sockets.TcpListener([IPAddress]::Any, 1522)
$listener1.Start()

# Create a listener on port 1523
$listener2 = New-Object System.Net.Sockets.TcpListener([IPAddress]::Any, 1523)
$listener2.Start()

# Create a listener on port 22
$listener3 = New-Object System.Net.Sockets.TcpListener([IPAddress]::Any, 22)
$listener3.Start()

# Keep the script running to continue listening
while ($true) {
    # Check if there is a client waiting to connect to listener1
    if ($listener1.Pending()) {
        # Accept the client connection and handle it
        $client1 = $listener1.AcceptTcpClient()
        # Handle the client connection here
    }

    # Check if there is a client waiting to connect to listener2
    if ($listener2.Pending()) {
        # Accept the client connection and handle it
        $client2 = $listener2.AcceptTcpClient()
        # Handle the client connection here
    }

    # Check if there is a client waiting to connect to listener3
    if ($listener3.Pending()) {
        # Accept the client connection and handle it
        $client3 = $listener3.AcceptTcpClient()
        # Handle the client connection here
    }

    # Add a delay to avoid using too much CPU
    Start-Sleep -Milliseconds 100
}
