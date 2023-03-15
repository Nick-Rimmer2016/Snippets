import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.mime.application import MIMEApplication

# Email details
smtp_server = 'smtp.gmail.com'  # Replace with your SMTP server
smtp_port = 587  # Replace with your SMTP server's port number
smtp_username = 'your_email@gmail.com'  # Replace with your email address
smtp_password = 'your_password'  # Replace with your email password
from_email = 'your_email@gmail.com'  # Replace with your email address
to_email = 'recipient@example.com'  # Replace with the recipient's email address

# Log file details
log_file_path = 'c:/test/test.log'  # Replace with the path to your log file

# Read the contents of the log file
with open(log_file_path, 'r') as f:
    log_contents = f.read()

# Create the email message
message = MIMEMultipart()
message['From'] = from_email
message['To'] = to_email
message['Subject'] = 'Log file'

# Add the log file as an attachment to the email message
attachment = MIMEApplication(log_contents, _subtype='txt')
attachment.add_header('Content-Disposition', 'attachment', filename='test.log')
message.attach(attachment)

# Send the email
with smtplib.SMTP(smtp_server, smtp_port) as server:
    server.starttls()
    server.login(smtp_username, smtp_password)
    server.sendmail(from_email, to_email, message.as_string())
