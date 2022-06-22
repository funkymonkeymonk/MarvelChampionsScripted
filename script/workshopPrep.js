const BSON = require('bson')
const fs = require('fs')

const data = JSON.parse(fs.readFileSync('./mod/2817359776.json'))
BSON.setInternalBufferSize(200000000)
const serialized = BSON.serialize(data, {})
fs.writeFileSync("./mod/MarvelChampions.bson" , serialized)