# Tutorial for adding a name for new unit

By Agrael

## Creating a new unit:

**1)** Open DB Editor then open every **db** file.

**2)** Create a new unit (**dbobj**, **tech**, **etc**).

**3)** Leave it's name as an original one (for example you create a new rifle unit, and leave *"marine"* name).

**4)** Go to **dbeffects**.

**4.1)** Go to slot **"8 (4) Effect Code"**.

**4.2)** Choose **"2: Alter attribute"**.

**4.3)** Go to **"14 (4) Attribute"** and choose the last one, **Name**.

**4.4)** Choose the new object (**"object 1"** above effect code).

**4.5)** Now this is a bit complicated: You need to go in __language.dll__ first, select an unused slot, give it a name, remember the line number left to the name, save and exit.

**4.6)** Go back to **dbeffects**, Go to **"2 (4) Set base attribute"**, which is usually at **"0.0"** . You need to change that number to the number of the line of new name (example it was *"1234: rifleman"*, so you add *1234.0* to that)

**4.7)** Save, and the new effect will appear on left: The new name will not appear there, but don't worry, it will in game.

**5)** Now go to **dbevents**

**5.1)** Now you have to choose one event, i would say choose the *"Epoch Paleo"*, so it works from start (I think, if not then choose the epoch where the unit appears, should work too).

**5.2)** Choose **"add field"** on bottom

**5.3)** Open the new effect bar that appeared, and choose the effect you made before

**5.4)** Save and play.

**P.S.:** Remember: in the editor the unit will always have old name (example, you will have 2 *"marine"* in list). When the game starts it will have new name. I hope