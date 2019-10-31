# Empire Earth DB Editor
## Introduction

You may know the great tools called EE Unit Editor 1 and EE Unit Editor 2.
These tools allow you to open and edit some dat fles of the game, but up to a limited extends.
There were many unknown values in dat fles at the times they were created and there are still many unknown values.
In all these years the community made much progress and discovered new values in these files, but nobody is updating those
tools, which are now obsolete.
So I decided to create this new tool, which will be maintained by the whole community, as it's completely open source!

The source code is on GitHub ([original version](https://github.com/Forlini91/Empire-Earth---DB-Editor)).
You can download the latest version from [here](https://github.com/EE-modders/Empire-Earth---DB-Editor/releases).

A discussion thread is on [Empire Earth Heaven](http://ee.heavengames.com/cgi-bin/forums/display.cgi?action=ct&f=3,38362,,365), but you can contact us on our Discord server as well.

## Description

EE DB Editor is a tool writen in Java which can open and edit a wide range of dat files.
The program uses a simple interface where it shows the entries of the dat files and all the (un)known values.
All of them can be changed at will, but be careful with `unknown` values, they can potentally break the game or make it crash!
You can make tests and try to guess what those unknown values do, then report your finds to us.
Any change needs to be manually saved to prevent unwanted changes: change the values of entry, click `Save Entry`, repeat with other entries and finally click on `save to file`.
The program also creates a backup of the previous/original db file, should anything bad happen.

## Basic usage
1. **Main menu**
The usage is very simple.
The program will initially ask you to choose the version of the game (Vanilla or AOC). This choice can't be changed, unless you close and reopen the program.
Now click on `Load dat files`, select the directory where the files are located and the program will go there and search all the supported dat files.
Then it asks you which files to load. Be careful: some files (especially `dbobjects.dat` and `dbtechtree.dat`) have links to other files, so you need to load these "requirements" too.
When it finishes loading, it will return to the main menu and will show, on the right side, the list of all loaded files.
Select a file to open the editor window for that dat file.

2. **Editor window**
On the left side there a list which contains the entries defined in the file: you can click on an entry to see and edit its values.
In `dbTechTree.dat` there's also a second list which contains all epochs: select an epoch to see its entries.
On the right side there's a big area with many fields: these represents the values contained in the file for the selected entry, in integer/float/string readable format. You can change these values at will and confirm the changes by clicking on the button `Save entry` below. If you click another entry without saving the changes will be lost.
When you're done with changes, click on `Save to file` on the top bar (don't forget it, else your changes will be lost!)
There are two context menu: one when you right-click on an entry in the list, one when you click a field.
Every menu will offer different options for every entry/field
Below the list of entries there's a search box you can use to search an entry by name or ID.

There are "link" fields, which contains link which point to other entries either in the same file or in another one.
These fields appear as a Combo box which contains the list of all currently known values.
When you type in these fields the program will automatically try to help you in the search. Be careful: these lists don't refresh automatically when you change the IDs or add/remove entries.
You need to either close/reopen the window or right click on fields and select "Refresh list".

3. **Details and features**
- **Files:**
    - You can open multiple files at the same time.
    - You can open the same file in multiple windows: SHIFT + click on the file's button to open a new window
    - You can safety save a file even when there are multiple windows
    - When you save, the editor automatically creates a backup of the previous version with extension “.bak”, so you can recover it in case something bad happens (either a bad change or a bug in the editor).
    - The editor also saves (only once) a backup with extension “.orig”. This file will never be overwritten, so it can be used as a checkpoint which allow you to revert to a previous "stable" state. When you reach another "stable" state, you can delete it and let the editor create a new one on the next save.
- **List of entries:**
    - The program automatically hides all undefined entries from the lists (which are entries with an invalid ID or Sequence Number), but you can force it to show them with a check box (which is always placed near the relative list), in order to edit them and make them valid entries.
    - You can reorder the entries in the list: select an entry, hold CTRL and use Up/Down arrow keys to move the selected entry up or down. If you also hold SHIFT, the entry will move 10 steps at time.
    - Right-click on an entry to show its context menu: if the file supports it, you can add/remove/duplicate entries, you can copy/past values between entries (except for ID and Sequence Number), search all links to this entry or quickly jump to an associated entry (even in other files).
    - Adding a new entry will assign it the default values used by "undefined" entries, so you need to manually configure them (except for ID and Sequence Number, which will have the first unused number).

- **Fields and values:**
    - dbtechree.dat and dbevents.dat are special, as their entries may contains a dynamic number of fields, placed at the end of the entry (so the size of each entry vary, depending on its "extra" entries). In those files you'll find 2 buttons at the bottom: "Add field” which add a new extra field, "Remove field” which remove the last extra field (if any).
    - If a field contains a Link, you can CTRL+Click on the field to open the link, possibly re-using an already opened window for that file, if any, but you can SHIFT+CTRL+Click to force open the link in a new window.
    - Right-click on a field to show its context menu. It will offer options to search similar values or all values used in the field, mark all unused/interesting fields (fields which contains very few different values), refresh the list of entries (only in link fields), or few unique options on specific fields.
- **Search and menus:**
    - You can search both in the search box below the entries and in link fields:
        - In the entries search box, just type the ID or name and the list will show the search results.
        - In link fields, you can use keys Enter/Tab to select the result, Ctrl+Enter and Shift+Enter to search the next/previous match.
    - There's a menu bar above, which allow you to save all changes to file, adjust the number of columns, show a complete list of entries in plain text you can copy/paste, or make an advanced search
    - The number of columns is not saved, but I tried to set them to an optimal value for each file.
    - With the advanced search you can specify any number of filters to search for entries which match them all.



### Known Issues:
Java can't read the file Language.dll. The languages you see in the editor are the vanilla/AOC default languages I hardcoded in the editor. This means you need an external tool like ResHack to change the languages, and the editor won't be able to see the changes you made nor the new language entries you created, but you can still manually manually type the Language ID in the language fields without problem.
Basic actions:

### Load the files:
No seriously, do you really need a guide for this? Click on `Load dat files`, select the folder which contains the db files, select the files you want to load and confirm. If you select a file, all requirements are automatically selected as well. In a similar way, if you deselect a file, all other files which require this file will be deselected as well.

### Change the values of the entries:
Easier than 2+2 (if your answer is not "4", you have a serious problem!): open any db file, select any entry in the list, change as many fields as you want, then click `Save entry`. Repeat with as many entries as you want, then click on Save to file.

#### Cancel changes:
If you didn't save the changes made to an entry with the button `Save entry`, you can cancel said changes by clicking on `Reset Entry` or by selecting another entry.
If you already saved the entry with the button `Save entry`, you can reload the file.
If you already saved the file, the editor has created a db*.bak file, which you can rename to db*.dat and recover the previous version of the file. If you saved twice and the db*.bak file has been overwritten, then… dude, you're a disaster!

### Add/Remove an extra field for an entry:
As already stated, in dbtechree.dat and dbevents.dat entries may define extra fields (and they usually do).
Open one of these files and add a new field with the button `Add field` (below the fields). Then remove it with `Remove field`.

### Add/Remove an entry in the list of entries:
Many db files allow you to add/remove entries (while some files define a fixed set of entries and you can't add/remove them).
If the file supports these operation, the `Add entry` and `Remove entry` options will appear in the entries context menu.
So, open a db file which support this operation, add a new entry, then right click on it and remove it.

### Move tech to another epoch:
This operation is only available to entries in dbTechTree.dat, and appear in the entries context menu.
Go to any epoch, right-click on the entry you want to move, select `Move to epoch` and choose the new epoch.
The tech will be moved there and it will automatically receive a new `ID` within the epoch's range of IDs (needed change, else the game crash).

Ok, now you have everything you need to start doing something greater!

## Credits:
Credits go to the EE Heaven community and all its members!
This program would not exist without all the work done by the community to find what those dat files contains!
Thank you all!!

_originally written by Forlins (@Forlini91)_

_updated by zocker_160 (@zocker-160) - 31.10.2019_