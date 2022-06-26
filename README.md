# Ultimate Marvel Champions Scripted

### Releases
* [Latest Released Version](https://steamcommunity.com/sharedfiles/filedetails/?id=2824240402)
* [Development](https://steamcommunity.com/sharedfiles/filedetails/?id=2817359776)
  * [![dev-deploy](https://github.com/funkymonkeymonk/MarvelChampionsScripted/actions/workflows/dev-deploy.yml/badge.svg)](https://github.com/funkymonkeymonk/MarvelChampionsScripted/actions/workflows/dev-deploy.yml)
  * This is not guaranteed to work. This is the build that is currently latest in main.


### Getting started with development
* Install nodejs
* Install [luacheck](https://github.com/mpeterv/luacheck) for lua linting
* Install dependencies
  * ```npm install```
* Build the save file from source and create symlinks
  * ```npm start```

### Development commands
* ```npm compile```
  * Compiles files from /mod/src/ into a TTS save file in the dist folder
* ```npm extract```
  * Extracts the TTS save file in the dist folder into source files 
* ```npm start"```
  * npm compile and also creates symlinks to TTS save directory
* ```npm validate```
  * **WIP**: validates the JSON in the src directory
* ```npm convertToBSON```
  * Convert an existing TTS save file to BSON format for workshop upload

## Thanks
Our appreciation goes out to those who came before and made much of this mod possible.
* [Star Wars Legion TTS mod](https://github.com/swlegion/tts)