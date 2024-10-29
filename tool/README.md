# A few important how-to's

## How to add a new modular encounter set
1. Create a deck for the modular encounter set named "[name] Modular Set"
2. Add them to the Modular Set bag face down

## How to add a new hero
### Prepare the playmat image  
1. Get the playmat image from https://drive.google.com/drive/folders/1IvTnpIxl8RbSZ2iuOhSdbw8KQQ0g_rA0
2. Resize the image to 72dpi, and 1500 pixels wide. 
3. Use https://compresspng.com/ to minimize the file size. 
4. Upload the compressed image to Steam cloud. 
5. Preview the image and make a note of the url.
6. (If a playmat image isn't available yet, you can use this url for a plain gray background until the playmat is designed: https://steamusercontent-a.akamaihd.net/ugc/1867319584748543443/C10AF8349C00327F6CD68B4001654610E565A6E3/ )

### Prepare the decks 
1. Go to https://marvelcdb.com and log in with the mod account
2. Make a new deck for the hero and add the cards from their starting deck. 
3. Under the "Notes" tab, add the tag "Starter". 
4. Save this deck as [hero name] Starter Deck and note the deck Id in the url. 
5. Make another deck, but don't add any cards to it. 
6. Add the tag "Hero". 
7. Save this deck as [hero name] Hero Deck and note the deck Id in the url. 

### Create and populate the hero bag
1. Spawn a bag by clicking Objects -> Components -> Tools -> Bag 
2. Name the bag "[Hero Name] Hero Bag"
   * This is important, because this is used to set the name of the selector tile
   * I may add the hero name to the hero details at some point, which will make the bag name less important.

3. Bring the hero components into the mod 
   1. Click Games -> Workshop. 
   2. Find the "Marvel Champions High Resolution Scans" mod. 
   3. Click the Options menu, then Search. 
   4. Find the hero pack in the search screen and drag it onto the table. 
   5. Search the hero pack, drag all components onto the table, and delete the pack.

4. Get the counter image 
   1. Right-click the hero's HP counter and click Custom. 
   2. Copy the url in the Top Image field and close the Custom screen. 
   3. Save the url for later. 
   4. Delete the counter.

5. Prepare the other components 
   1. Save the guid of the identity card, name it "[Hero Name] Identity", and make sure that it is set to alter-ego side up.
      * (The nemesis and obligation cards may be combined into a single deck. If so, separate the obligation from the nemesis cards.)
   2. Save the guid of the nemesis deck and name it "[Hero Name] Nemesis". 
   3. Save the guid of the obligation card, and make sure it is face-down. 
   4. If there are other components, save their guids for now; we'll do more with them later. 

6. Move all components into the new hero bag and then save the mod. (If you don't save now, the guids can change later.)
   * Note: you don't have to worry about sizing the components; the hero placer will set their scales.

7. Add the bag scripting 
   1. Open the script editor for the hero bag. 
   2. Copy the template below into the script. 
      1. Fill in all guids, Ids, and urls. 
      2. Save the script. 
   3. If there are extra components (such as extra cards, like Doctor Strange's Invocation deck), add one entry to the "extras" table for each component. 
   4. The key (in the first line: extras[""] is arbitrary, and is not used for anything. 
   5. The guid is the guid of the component. 
   6. The offset is a vector containing the numbers that need to be added to the playmat's location to get the location of the component. The easiest way to figure this out is to place a hero, and then place the component where you want it to go on the playmat. Then, subtract the x, y, and z coordinates of the playmat from the x, y, and z coordinates of the component, and put the differences into a new vector. 
      1. Ex: The blue player's playmat is located at {-13.75, 1.04, -17.75} if I put Valkyrie's Death-Glow card at {-18.70, 1.17, -13.11}, the offset is {-4.95, 2, 4.64}. (Generally, the Y coordinate should be set to 2 or 3, to ensure that it spawns above the playmat, and drops into place, unless the item is locked, in which case, you should use the actual Y coordinate of the item at rest.)
   7. The locked field is a boolean indicating whether the object should be locked once it is placed. 
   8. Some heroes need a counter for their special ability (such as Groot's growth or War Machine's ammo). For these, add a general use counter to the bag as an extra component. 
   9. If a hero has no extra component, you can delete the lines relating to extras from the script. 
8. Add the new hero bag to the Heroes Bag. 
   1. Currently, the Heroes Bag is in the upper-right corner of the table, and is hidden from all players but black. Set your color to black to see it. (Ultimately, we'll use some other object that doesn't need to be hidden.)
9. Save the mod. 
10. Right-click on the Heroes Bag and click "Lay Out Heroes" to lay out all hero selectors; The new hero should appear.