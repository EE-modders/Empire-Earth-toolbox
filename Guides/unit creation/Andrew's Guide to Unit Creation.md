# Andrew's Guide to Unit Creation

By Andrew103

## Introduction

I don't really know how to give you guys a tutorial, I mean, I haven't done anything complicated - I just took my time editing specific objects a lot.

Making new entries in dbtechtree is NOT possible to my knowledge. This means that you CAN NOT actually add new objects, just replace old ones. This also means you can't change the starting epoch of anything.

What you CAN and SHOULD do is edit IDs.

Want to create something like a Cyber Trojan Horse buildalbe in the Space Age?

## Instructions

First things first, create the textures you plan on using for the model and for the button just to get them out of the way.
Do I have to explain how to use EEStudio? 

1. Open dbbuttons, copy whatever entry you want and paste it at the end. Change it's texture path to the new button textures you made, give it the proper ButtonID value (It's in order of the file, just check the one above and add 1).
Give it a button position suitable to you and finally remember to go to the very first value of the file and add 1 since it counts how many entries there are in the file and you just created one.

2. Open dbgraphics, copy the trojan horse entry, paste it at the end. Change the texture path to your new trojan horse textures but keep in mind to use the same file name lenght. Again change the GraphicsID value to in order of the file and add 1 to the starting value of the file.

3. Go to dbobjects, copy the entire trojan horse entry and paste it at the end of the file. Change it's ObjectID value to the correct one and add 1 to the starting value of the file. Change the ButtonID and GraphicsID values to your newly created ones.

4. All that is left is to connect it with a tech. I suggest you use the Time Machine tech since it starts in the Space Age and is unused. Change the TechID to the Time Machine TechID in dbtechtree.

5. Open dbtechtree, take the Time Machine tech in dbtechtree and point it's ObjectID to your new object and ButtonID to your new button you created. 
Now comes the decoration and imagination part:
use dbtechtree to set build time and resource costs.
use dbobjects to change the numerous stats and lastly, make it buildable in whatever building you want.

Everything here comes to taste so what am I supposed to tell you here?

If you want to make a unit fire different projectiles change it's ProjectileID value. If you want to change it's shooting effect change the EffectID value.

**USE THOSE ID VALUES.**

There is also a FamilyID, an AttackModeID, SoundIDs, a UnitTypeID, a LanguageID in dbobjects just to name a few.

The only thing that is static in this game are the techs in dbtechtree. If someone finds out how to make new ones this game becomes pretty much unlimited in regards to content. (A model extractor would also be nice)

However, if any one of you has a specific and well-planned unit they would like to create I would go into every single detail in it's creation. Don't limit yourselves to what you've seen ingame. Go crazy.
