# SST Editing

by Skies
___
## Instruction
1. Open EE Studio and convet a **.sst** texture to **.tga**.

![skies1.png](skies1.png)

2. If there are some missing parts in the **.tga** texture, change the **.tga** resolution via a Hex Editor (I use HxD).

![skies2.png](skies2.png)

00 01 is 256; 00 02 is 512

![skies3.png](skies3.png)

3. Modify the **.tga** texture in a photo editing software and save the texture to **.tga**.

4. Open EE Studio and convert the new **.tga** texture to **.sst**.

![skies4.png](skies4.png)

5. Open the saved **.sst** texture in a Hex Editor and find the closest **“TRUEVISION-XFILE”** text string.

![skies5.png](skies5.png)

6. Delete all useless data after the text string.

![skies6.png](skies6.png)

![skies7.png](skies7.png)

![skies8.png](skies8.png)

7. Compare the new **.sst** header with the original one.

![skies9.png](skies9.png)

![skies10.png](skies10.png)

8. Make the new .sst header the same as the old one.

9. If your new texture was upscaled to a bigger resolution, change these blocks.

![skies11.png](skies11.png)

10. Save the **.sst** to: gamedirectory/Data/Textures

11. Done.













