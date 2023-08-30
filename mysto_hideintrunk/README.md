# Overview
Mysto_hideintrunk is a simple script that allows multiple players to hide in a vehicle's trunk, using qb-target and qb-notify as exports. Code is open-source, can be edited at any time. 

## Dependencies:
1. QBCore Framework
2. qb-target

## Installation:
1. Navigate to qb-target\data\bones.lua

Around line 122, add the following code under the `Bones.Options['boot'] = {`
making sure to add a comma for the second entry if you have one, or your first entry.

```
        ["Hide in Trunk"] = {
            icon = "fas fa-user-secret",
            label = "Hide in Trunk",
            action = function(entity)
                exports['mystotrunk']:getIntoTrunk(entity)
            end,
            distance = 0.9
        }
```
Do it just like the image below:

![Image](https://user-images.githubusercontent.com/120472333/264230524-f6efe776-afd2-4194-b510-8e784dec52ed.PNG)

2. Drag and drop the script into any folder (make sure to start it in the server.cfg by doing: ensure mysto_hideintrunk if you are not starting your resources by folder already).

3. Restart your server! Never restart qb-target on a live server. This will cause crashes, and many errors to show up in your server console.

## Performance
This resource has a `resmon` of 0.0 all times, including idle and in usage!

Project for Resolution Networks
