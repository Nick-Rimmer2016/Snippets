import csv

# Read the text data from the input file
with open("input.txt", "r") as file:
    data = file.readlines()

# Write the parsed data to the output file
with open("output.csv", "w") as file:
    writer = csv.writer(file, delimiter="|")

    headers = ["DocType", "DocDate", "CI", "ORG", "DiskgroupNum", "Disk", "FileName"]
    writer.writerow(headers)

    for line in data:
        if line.startswith("BEGIN:"):
            doc_type = ""
            doc_date = ""
            ci = ""
            org = ""
            diskgroup_num = ""
            disk = ""
            file_name = ""
        elif line.startswith(">>DocType:"):
            doc_type = line.strip().split(": ")[1]
        elif line.startswith(">>DocDate:"):
            doc_date = line.strip().split(": ")[1]
        elif line.startswith("CI:"):
            ci = line.strip().split(": ")[1]
        elif line.startswith("ORG:"):
            org = line.strip().split(": ")[1]
        elif line.startswith(">>DiskgroupNum:"):
            diskgroup_num = line.strip().split(": ")[1]
        elif line.startswith(">>Disk:"):
            disk = line.strip().split(": ")[1]
        elif line.startswith(">>FileName:"):
            file_name = line.strip().split(": ")[1]
            row = [doc_type, doc_date, ci, org, diskgroup_num, disk, file_name]
            writer.writerow(row)