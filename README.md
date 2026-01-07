## AUXTRAINSERVICE
### Installation
- Insert a ServerScript inside of ServerScriptService
- Name the script "Main" or any other name, and **then paste main.luau's contents inside of it**.
- Create a folder named "Services" and **place it as the Child of the ServerScript**.
- Insert a ModuleScript as the child of the ServerScript and **then paste trainopservice.luau's contents inside of it**.
- Create a folder in Workspace named "Trains", insert your trains there.
### Requirements
- Train MUST BE a Model
- Train MUST HAVE tag "Train"
- Train MUST HAVE the "MaxSpeed" attribute
- Train MUST BE anywhere inside of Workspace
- The train's VehicleSeat MUST BE set as first child
- Train's wheels MUST BE named "WheelR" or "WheelL" based on the side of the train they are positioned on. If the controls are in reverse, then reverse the names.
- The wheels must use HingeConstraints, not SurfaceHinges.
### Optional
- ReverseSpeed (Default set as MaxSpeed / 2)
### If you find any errors,
Announce me as soon as possible so I can deal with them.
