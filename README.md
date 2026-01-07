## AUXTRAINSERVICE
### Information
The useful .luau scripts are placed inside of the scripts folder.
### Quick Setup
NOTE: Quick setup may be outdated and will likely only be updated when there is a critical bug fix or a major update
You can also use the Quick Setup.
- Copy "quicksetup.luau" to your clipboard.
- Paste it into the [command bar](https://create.roblox.com/docs/studio/ui-overview#command-bar) in Studio
- Press enter, and check ServerScriptService for "Main"
### Installation
- Insert a ServerScript inside of ServerScriptService
- Name the script "Main" or any other name, and **then paste main.luau's contents inside of it**.
- Insert a ModuleScript as the child of the ServerScript and **then paste trainopservice.luau's contents inside of it**.
- Name the module script "TrainOperationService" (necessary or won't work)
- Insert your trains as a descendant of Workspace and give them the tag of "Train" and create 2 attributes, "Speed" and "ReverseSpeed", adjust them accordingly. (The 2 attributes must be number type, as you are changing the AngularVelocity property, which is a number.)
### Requirements
- Train MUST BE a Model
- Train MUST HAVE tag "Train"
- Train MUST HAVE the "Speed" attribute
- Train MUST HAVE the "ReverseSpeed" attribute
- Train MUST BE anywhere inside of Workspace
- The module MUST BE named "TrainOperationServices" and must be a child of Main
- The train's VehicleSeat MUST BE set as first child
- Train's wheels MUST BE named "WheelR" or "WheelL" based on the side of the train they are positioned on. If the controls are in reverse, then reverse the names.
- The wheels MUST USE HingeConstraints, not SurfaceHinges.
### Optional
none yet
### If you find any errors,
Announce Petrulici as soon as possible so I can deal with them.
