# TTTDamagelog-Autoban
A small Autoban addon for TTT Damagelogs

# Add-on Information #
- Name: TTTDamagelogs Autoban
- Description: Automatically bans players after leaving the server with slays.

# Dependencies #
- [TTT Damagelogs](https://github.com/Tommy228/tttdamagelogs)

- [ULib](https://github.com/TeamUlysses/ulib) v2.63 or higher (*will likely work with older versions, but was written for 2.63*)

# Configuration #
All configuration can be done in `/addons/TTTDamagelog-Autoban-master/lua/ulib/modules/server/aban.lua`.

# Installation #  
Shut down your server. [Download the latest version](https://github.com/iViscosity/TTTDamagelog-Autoban/releases/download/v1.0/tttdamagelog-autoban.zip). Extract the ZIP into somewhere (on your Desktop or someplace easily accessible). Take the root folder `tttdamagelog-autoban` and upload it into your server's `addons` folder. You should have a file structure like:
```
├───tttdamagelog-autoban
│   └───lua
│       └───ulib
│           └───modules
│               ├───client
│               └───server
├───tttdamagelogs-3.1.0
│   ├───lua
│   │   ├───autorun
│   │   └───damagelogs
│   │       ├───client
│   │       │   └───tabs
│   │       ├───config
│   │       ├───server
│   │       └───shared
│   │           ├───events
│   │           └───lang
│   └───sound
│       └───damagelogs
├───ulib
│   └───lua
│       ├───autorun
│       └───ulib
│           ├───client
│           ├───modules
│           ├───server
│           └───shared
```
