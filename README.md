# BusinessCentral Management

Script to manage BusinessCentral service tiers through Powershell with GUI

Because Admin GUI was removed from BCv21, this is "replacement" for everyone, who wants to use GUI to manage the service tiers. You are welcome to extend the script with new functionality.

## How-to

### Run the tool

Copy the script(s) and run "start-bcm.ps1".

### Extend the tool

- Add new .ps1 file into the folder
- Define your functions inside it
- Call this function inside the script:

  ```Powershell
  RegisterFunction -Function 'Config' -Name 'Instance Configuration' -
  ```

  Where Function is name of the function which should be called when the menu item is selected, and Name is display name for the menu.

## Example Screenshot

![image](https://user-images.githubusercontent.com/110221/212021788-e1159463-88be-4bfa-a68a-366e4c1604df.png)

