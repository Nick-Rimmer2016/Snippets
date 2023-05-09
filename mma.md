# PowerShell Script for Applying Rules to a CSV File

This PowerShell script reads a CSV file, applies a set of rules specified in a YAML file, and generates a new CSV file with the results.

## Installation

1. Install PowerShell on your system if it is not already installed. You can download PowerShell from the [official website](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell).

2. Create a new folder on your system and copy the PowerShell script, the YAML file, and the CSV file to the folder.

## Usage

1. Open a PowerShell console or terminal and navigate to the folder where you copied the files.

2. Run the following command to execute the PowerShell script:

3. The script will prompt you to enter the file names for the YAML file and the CSV file. Enter the file names and press Enter.

4. The script will process the CSV file, apply the rules specified in the YAML file, and generate a new CSV file with the results.

5. The new CSV file will be saved in the same folder as the original CSV file with the name "results.csv".

## Configuration

You can modify the YAML file to specify the rules and actions to apply to the CSV file. The YAML file should have the following structure:

```yaml
decision engine:
  rules:
    rule1: "BM"
    rule2: "CM"
  actions:
    action1: "BM has appeared"
    action2: "CM has appeared"
 ```
    
 The rules section should contain one or more rules, where the key is the name of the rule and the value is the value to search for in the CSV file.

The actions section should contain one or more actions, where the key is the name of the action and the value is the message to display or perform when the corresponding rule is matched.

You can also modify the PowerShell script to customize the behavior of the script, such as how the rules are applied to the CSV file and how the results are saved to the new CSV file.
