import glob
import os
import time

folder_path = '/path/to/folder/'  # Replace with the path to your folder
current_time = time.time()
five_days_ago = current_time - (5 * 86400)  # 86400 seconds in a day

# Loop through all PNG files in the folder and delete the ones older than 5 days
for file_path in glob.glob(folder_path + '*.png'):
    if os.path.isfile(file_path) and os.stat(file_path).st_mtime < five_days_ago:
        os.remove(file_path)
