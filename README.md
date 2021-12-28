## qb-policegarage
police garages with qb-target and qb-menu (Fork Dox-Garage)
[Dox-Garage](https://github.com/Doxthehuman/QBCore-Nopixel-Inspired-Police-Garage)

## Requirements
qb-core - https://github.com/qbcore-framework/qb-core

qb-target - https://github.com/BerkieBb/qb-target

qb-menu - https://github.com/qbcore-framework/qb-menu

## add to qb-target TargetBones
```
    ["policegarage"] = {
        models = {
            'ig_trafficwarden',
        },
        options = {
            {
                type = "client",
                event = "garage:menu",
                icon = "fas fa-car",
                label = "Police Garage",
                job = "police",
            },
        },
    distance = 3.5,
    },
```
