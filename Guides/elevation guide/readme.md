# Elevation guide
By Agrael
## Instructions

Go to this [site](https://maps.ngdc.noaa.gov/viewers/wcs-client/) and download the wcs-client.

1. On the top left you can choose to create the map with **`rectangular selection`** or **`by coordinates`**; either way you will get a part of the map.
2. On bottom left, under **`choose a layer`**  select  **`ETOPO1 (bedrock)`**
3. Click download the data on bottom right.
4. Now you will need paint program; you should have it. Open it.
5. Load your downloaded file (should be a **`.tif`**) in it.
6. On bottom of paint, you will see a size (for example 1200x1800); copy them.
7. Open a **`.txt`** file.
8. Paste that size but without `x` and with space (for example will become 1200 1800).

## Using Global Mapper

Now you need the program **`Global Mapper`**; I have a pirated version with crack and I can send it.
1. Install and open it.
2. Go on top left and choose **`file`** then load your **`.tif`**.
3. If a message pops up, choose **`yes`**.
4. Now go again on **`file`**, then **`export`**, then find **`export elevation grid format`**.
5. Choose to export as **`bil/bip/bsq`** file.
6. Just press ok to the options pop up.
7. You will get 4 files, but you only need **`.bil`**; delete the others.
8. Rename **`.bil`** to **`.dat`**.
9. Now, *BOTH* **`.dat`** and **`.txt`** must have same name (for example **`Usa.txt`** and **`Usa.dat`**).
10. Put both files in data/scenarios/elevation maps; if doesn't exist, create it.
11. It's done. Go in game, scenarios, then create a map with eveation and choose your file.
12. Play a bit with the 4 values that appear, plus choose the width.

## Extras

- now the trick for bigger maps; when choosing a rectangular selection on the site, make it more tall and less wide;  
so it looks like --> ||   and not  -->  |____|
- this way, when you choose width to 400 in game, tall part will be bigger than that
