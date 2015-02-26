# ParrotZik-OSX
This is OSX application for [Parrot ZiK headphones](http://www.parrot.com/zik/)

# Why?
Main reason is - to show battery state of headphones it system tray.

Other reasons:
  - because we can
  - because we want it to be like we want it to be
  - to try swift
  - etc.

# How to build
 * clone repo
 * open project (ParrotZik.xcodeproj) in Xcode
 * switch target to "ParrotZik" (there is CliTest target - for debugging and testing)
 * build it or run it or export it to standalone application

# How to use
At start almost nothing happens (if your headphones are not connected).

Once headphones are connected to your mac - headphones icon should appear in system tray with information about current battery state (AC/Charging/...%).

Also there is a popup menu to do some things with your headphones such as switch ANC/Phone ANC/Lou Reed mode.

# Plans
Refactoring - because there many strage things in code (heh ;) ).

Implement many other things from ZiK's api, in this direction our target is to implement all the things api can provide.
 
# Thanks
Many our thanks goes to [m0sia](https://github.com/m0sia) with [pyParrotZik](https://github.com/m0sia/pyParrotZik) project for ideas, some code and headphones icon =)
