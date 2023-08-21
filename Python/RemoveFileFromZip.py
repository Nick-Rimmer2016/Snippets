import pyzipper
import os

def delete_from_zip(zip_filename, files_to_delete, password=None):
    # Create a temporary ZIP file name
    temp_zip = zip_filename + '.temp'
    
    with pyzipper.AESZipFile(zip_filename, 'r') as zip_read:
        # Check if the ZIP is password protected
        if password:
            zip_read.pwd = password.encode('utf-8')
        
        # Open the temporary ZIP file in write mode
        with pyzipper.AESZipFile(temp_zip, 'w', compression=pyzipper.ZIP_DEFLATED) as zip_write:
            # Go through each file in the original ZIP
            for item in zip_read.infolist():
                if item.filename not in files_to_delete:
                    with zip_read.open(item.filename) as file:
                        data = file.read()
                        zip_write.writestr(item, data)  # Pass the ZipInfo object directly
                    if password:
                        zip_write.pwd = password.encode('utf-8')
    
    # Delete the original ZIP file
    os.remove(zip_filename)
    # Rename the temporary ZIP file to the original name
    os.rename(temp_zip, zip_filename)

# Example usage
zip_file = 'path_to_zip_file.zip'
files_to_remove = ['file1.txt', 'file2.txt']
password = 'your_password'
delete_from_zip(zip_file, files_to_remove, password)
