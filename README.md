# BusinessCentral Management

Script to manage BusinessCentral service tiers through Powershell with GUI

Because Admin GUI was removed from BCv21, this is "replacement" for everyone, who wants to use GUI to manage the service tiers. You are welcome to extend the script with new functionality.

## How-to

### Run the tool

Call this in powershell:

```powershell
Install-module BCM -Force
Start-BCM
```

### Extend the tool

- Add new .ps1 file into the Functions folder
- Define your functions inside it
- Call this function inside the script:

  ```Powershell
  RegisterFunction -Function 'Config' -Name 'Instance Configuration' -NewShell $True
  ```

  Where Function is name of the function which should be called when the menu item is selected, and Name is display name for the menu. NewShell means that the function will be started in separate powershell
  window to keep it multi-version safe. Set $False if you want to run the function in the main console.

## Example Screenshot

![image](https://user-images.githubusercontent.com/110221/212021788-e1159463-88be-4bfa-a68a-366e4c1604df.png)

