const BSON = require('bson')
const fs = require('fs')

console.log("Starting the build process")
console.log("Reading in the mod file")
const data = JSON.parse(fs.readFileSync('./dist/MarvelChampionsLCG.json'))
console.log("Converting to BSON")
BSON.setInternalBufferSize(200000000)
const serialized = BSON.serialize(data, {})
console.log("Writing the file out")
fs.writeFileSync("./dist/MarvelChampionsLCG.bson" , serialized)
console.log("Finished!")