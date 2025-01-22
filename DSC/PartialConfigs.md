# Using Partial Configurations in DSC: Naming Requirements

When using **partial configurations** in DSC, you must name them specifically in both the **partial configuration definition** and the **Local Configuration Manager (LCM) setup**. This ensures the LCM knows which configurations to look for and how to process them.

---

## **Key Requirements for Naming Partial Configurations**

1. **Unique Names**:
   Each partial configuration must have a unique name to avoid conflicts. These names link the LCM setup to the `.mof` files generated for the configurations.

2. **Consistency**:
   The name specified in the `PartialConfiguration` block of the LCM setup must exactly match the name used when generating the `.mof` files.

3. **File Naming Convention**:
   The `.mof` files for partial configurations must be named as:
   ```
   <NodeName>.<PartialConfigurationName>.mof
   ```
   For example, if your node is `TargetNode` and your partial configuration name is `Partial1`, the `.mof` file should be:
   ```
   TargetNode.Partial1.mof
   ```

---

## **Example Setup**

### **Partial Configuration Scripts**

#### **Partial 1 Script**
```powershell
Configuration Partial1 {
    Node 'TargetNode' {
        File ExampleFile {
            DestinationPath = 'C:\Example.txt'
            Contents = 'Hello from Partial 1'
        }
    }
}
Partial1 -OutputPath "C:\DSCConfigs"
```

#### **Partial 2 Script**
```powershell
Configuration Partial2 {
    Node 'TargetNode' {
        WindowsFeature WebServer {
            Name = 'Web-Server'
            Ensure = 'Present'
        }
    }
}
Partial2 -OutputPath "C:\DSCConfigs"
```

---

### **Setting Up the LCM**

Create a configuration for the LCM, specifying the partial configuration names:

```powershell
[DSCLocalConfigurationManager()]
Configuration LCMConfig {
    Node 'TargetNode' {
        Settings {
            ConfigurationMode = 'ApplyAndAutoCorrect'
            RefreshMode = 'Push'
        }

        PartialConfiguration Partial1 {
            Description = "Handles file creation"
        }

        PartialConfiguration Partial2 {
            Description = "Installs IIS Web Server"
        }
    }
}
LCMConfig -OutputPath "C:\DSCConfigs"
Set-DscLocalConfigurationManager -Path "C:\DSCConfigs"
```

---

### **Apply the Configurations**

1. Ensure the `.mof` files are named correctly:
   - `TargetNode.Partial1.mof`
   - `TargetNode.Partial2.mof`

2. Push the partial configurations:
   ```powershell
   Start-DscConfiguration -Path "C:\DSCConfigs" -Wait -Verbose
   ```

---

## **Common Pitfalls to Avoid**

- **Mismatched names**: The names in the LCM configuration and the partial configuration `.mof` files must match exactly.
- **File naming errors**: Incorrect `.mof` file names will prevent the LCM from locating and applying the configurations.
- **Duplicate resource definitions**: Ensure that no two partial configurations define the same resource unless they explicitly intend to modify it cooperatively.

