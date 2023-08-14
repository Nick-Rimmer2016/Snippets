def replace_value(key, new_value, data_dict):
    if key in data_dict:
        data_dict[key] = new_value
        print(f"Replaced value for key {key}")
    else:
        data_dict[key] = new_value
        print(f"Inserted new value for key {key}")

# Read the input text file and parse the lines into a dictionary
data_dict = {}
with open('input.txt', 'r') as file:
    for line in file:
        parts = line.strip().split()
        if len(parts) == 2:
            key = int(parts[0])
            value = parts[1]
            data_dict[key] = value

# Perform lookups and replacements
replace_value(10, "c:\\updated_test", data_dict)
replace_value(11, "e:\\new_drive", data_dict)

# Write the updated values back to the file
with open('output.txt', 'w') as file:
    for key, value in data_dict.items():
        file.write(f"{key}\t{value}\n")

print("Updated values written to 'output.txt'")
