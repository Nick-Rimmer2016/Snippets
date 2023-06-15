Create a new shell script with the startup commands for the application. For example, you can use the nano text editor to create a file named "myapp_startup.sh" in the /usr/local/bin/ directory:

sudo nano /usr/local/bin/myapp_startup.sh
Enter the startup commands for the application into the file. For example, if you want to start the "myapp" application, you can add the following lines to the file:

#!/bin/bash
/path/to/myapp
Make sure to replace /path/to/myapp with the actual path to the application executable.

Save the file and exit the text editor.

Make the script executable by running the following command:

sudo chmod +x /usr/local/bin/myapp_startup.sh
Create a new systemd service file for the startup script. For example, you can use the nano text editor to create a file named "myapp_startup.service" in the /etc/systemd/system/ directory:

sudo nano /etc/systemd/system/myapp_startup.service
Add the following lines to the file:

[Unit]
Description=MyApp Startup Script

[Service]
ExecStart=/usr/local/bin/myapp_startup.sh
Restart=always
User=root

[Install]
WantedBy=multi-user.target
Make sure to replace "MyApp Startup Script" with a description of your application, and /usr/local/bin/myapp_startup.sh with the actual path to your startup script.

Save the file and exit the text editor.

Enable the new service to start at boot time by running the following command:


sudo systemctl enable myapp_startup.service
Start the new service by running the following command:


sudo systemctl start myapp_startup.service
Your application should now start automatically at boot time. You can check the status of the service by running the following command:


sudo systemctl status myapp_startup.service
The output should indicate that the service is "active (running)" and that the application is running.
