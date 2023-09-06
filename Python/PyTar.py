import os
import tarfile

def get_size(file_path):
    return os.path.getsize(file_path)

def tar_files(src_folder, dest_folder, max_size=1073741824):  # max_size in bytes (1GB)
    tar_count = 1
    tar = tarfile.open(f"{dest_folder}/archive_{tar_count}.tar", "w")

    for foldername, subfolders, filenames in os.walk(src_folder):
        for subfolder in subfolders:
            path = os.path.join(foldername, subfolder)
            tar.add(path, arcname=path[len(src_folder):])

            if get_size(f"{dest_folder}/archive_{tar_count}.tar") > max_size:
                tar.close()
                tar_count += 1
                tar = tarfile.open(f"{dest_folder}/archive_{tar_count}.tar", "w")

        for filename in filenames:
            path = os.path.join(foldername, filename)
            tar.add(path, arcname=path[len(src_folder):])

            if get_size(f"{dest_folder}/archive_{tar_count}.tar") > max_size:
                tar.close()
                tar_count += 1
                tar = tarfile.open(f"{dest_folder}/archive_{tar_count}.tar", "w")

    tar.close()

src_folder = "path/to/source/folder"
dest_folder = "path/to/destination/folder"
tar_files(src_folder, dest_folder)
