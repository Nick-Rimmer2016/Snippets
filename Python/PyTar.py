import os
import tarfile

def create_tar_archive(output_filename, files_to_add, size_limit_bytes):
    with tarfile.open(output_filename, 'w') as tar:
        total_size = 0
        for file_path in files_to_add:
            file_size = os.path.getsize(file_path)
            if total_size + file_size > size_limit_bytes:
                print(f"File '{file_path}' exceeds the size limit. Skipping.")
                continue
            tar.add(file_path)
            total_size += file_size

if __name__ == "__main__":
    archive_name = "my_archive.tar"
    files_to_include = ["file1.txt", "file2.txt", "folder/file3.txt"]
    size_limit_gb = 1
    size_limit_bytes = size_limit_gb * 1024 * 1024 * 1024
    
    create_tar_archive(archive_name, files_to_include, size_limit_bytes)
    print(f"Archive '{archive_name}' created successfully.")
