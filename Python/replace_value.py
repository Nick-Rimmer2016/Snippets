def replace_value(key, new_value, data_dict):
    if key in data_dict:
        data_dict[key] = new_value
        print(f"Replaced value for key {key}")
    else:
        data_dict[key] = new_value
        print(f"Inserted new value for key {key}")

data_dict = {}

with open('input.txt', 'r') as file:
    for line in file:
        parts = line.strip().split()
        if len(parts) == 2:
            try:
                key = int(parts[0])
                value = parts[1]
                data_dict[key] = value
            except ValueError:
                print(f"Ignored invalid line: {line}")

replace_value(108, "c:\\updated_test", data_dict)
replace_value(112, "e:\\new_drive", data_dict)

with open('output.txt', 'w') as file:
    for key, value in data_dict.items():
        file.write(f"{key}\t{value}\n")

print("Updated values written to 'output.txt'")
