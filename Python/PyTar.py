import os
import tarfile

def get_size(file_path):
    return os.path.getsize(file_path)

def tar_files(src_folder, dest_folder, archive_name, max_size=1073741824):
    tar_count = 1
    tar_path = os.path.join(dest_folder, f"{archive_name}_{tar_count}.tar")
    tar = tarfile.open(tar_path, "w")

    for foldername, subfolders, filenames in os.walk(src_folder):
        for subfolder in subfolders:
            path = os.path.join(foldername, subfolder)
            tar.add(path, arcname=path[len(src_folder)+1:])

            if get_size(tar_path) >= max_size:
                tar.close()
                tar_count += 1
                tar_path = os.path.join(dest_folder, f"{archive_name}_{tar_count}.tar")
                tar = tarfile.open(tar_path, "w")

        for filename in filenames:
            path = os.path.join(foldername, filename)
            tar.add(path, arcname=path[len(src_folder)+1:])

            if get_size(tar_path) >= max_size:
                tar.close()
                tar_count += 1
                tar_path = os.path.join(dest_folder, f"{archive_name}_{tar_count}.tar")
                tar = tarfile.open(tar_path, "w")

    tar.close()

src_folder = "d:\\source_folder"  # Replace with your source folder
dest_folder = "d:\\tar"  # Replace with your destination folder
archive_name = "my_archive"  # Replace with your desired archive name

# Make sure destination directory exists
if not os.path.exists(dest_folder):
    os.makedirs(dest_folder)

tar_files(src_folder, dest_folder, archive_name)
