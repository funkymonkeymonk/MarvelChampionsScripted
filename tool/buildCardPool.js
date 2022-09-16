const {Octokit} = require("octokit")
const axios = require("axios")
const fs = require('fs')
const path = require('path')
const _ = require('underscore');

async function getDataFromGithub() {
  const octokit = new Octokit({
    auth: process.env.GITHUB_TOKEN,
  });

  const {data} = await octokit.rest.repos.getContent({
    owner: "zzorba",
    repo: "marvelsdb-json-data",
    path: "pack",
  })

  return await Promise.all(
      data.map(async (file) => {
        return axios({
          url: file.download_url,
          method: 'GET',
          responseType: 'JSON',
        })
      })
  )
}

function FormatPackData(responses) {
  // Example with Ant-Man: https://marvelcdb.com/api/public/card/12001a
  // My best guess at logic to determine card back:
  // if linked card then other card
  // if type_code = villain
  // if faction_code = encounter, encounter
  // else player
  // This falls apart for some cards but I think that may be OK.
  // We can contain the mess in an "exceptions check"

  function GetCardBack(card) {
    const cardBack = {
      "player": "http://cloud-3.steamusercontent.com/ugc/1795242553066035592/AEE6A404260E9B5DEE79D2B19CB39F982DCA574D/",
      "encounter": "http://cloud-3.steamusercontent.com/ugc/1795242553066038474/9D6A5F30D060027FFBCF84FF100993FA5AA476DA/",
      "villain": "http://cloud-3.steamusercontent.com/ugc/1833524088514022249/7A90E704A791A39D643453A11CAA1BA6BCF50016/",
    }

    // TODO: Check for exceptions and special cards
    // This is a janky way to do double sided cards but it should work
    if (card.code.slice(-1) === 'a') {
      return "https://cerebrodatastorage.blob.core.windows.net/cerebro-cards/official/" + card.code.slice(0, -1).toUpperCase() + "B.jpg"
    }
    if (card.code.slice(-1) === 'b') {
      return "https://cerebrodatastorage.blob.core.windows.net/cerebro-cards/official/" + card.code.slice(0, -1).toUpperCase() + "A.jpg"
    }
    if (card.type_code === "villain") return cardBack["villain"]
    if (card.faction_code === "encounter") return cardBack["encounter"]
    return cardBack["player"]
  }

  return responses
      .map(res => res.data)
      .flat()
      .filter(card => card.name != null)
      .map(card => {
        return {
          name: card.name,
          code: card.code,
          ...card.subname && {subname: card.subname},
          type_code: card.type_code,
          faction_code: card.faction_code,
          BackURL: GetCardBack(card),
          FrontURL: "https://cerebrodatastorage.blob.core.windows.net/cerebro-cards/official/" + card.code.toUpperCase() + ".jpg",
        }
      })
}

function sortCards(cards) {
  // Right now this is broken out by pack number for fast searching.
  // I'm not sure if this is enough or if I also need to create and index by name, type, ect
  return _.groupBy(cards, card => card.code.replace(/[a-zA-Z]/, '').slice(0, -3))
}

function WriteToMod(pack) {
  const prefix = "PACK_"
  const start = " = [[\n"
  const end = "\n]]"

  const content = Object.keys(pack)
      .map(key => prefix + key + start + JSON.stringify(pack[key], null, 2) + end)
      .join('\n')

  const filepath = path.join(__dirname, '..', 'mod', 'src', 'MarvelChampionsLCG', 'CardpoolData.lua')
  fs.writeFile(filepath, content, err => {
    if (err) {
      console.error(err);
    }
  });
}

async function start() {
  const responses = await getDataFromGithub()
  const packData = FormatPackData(responses)
  const sortedCards = sortCards(packData)
  WriteToMod(sortedCards)
}

start()

// # TODO: Create a "fallback image" for cards that don't have a front yet
// # TODO: Upload images to somewhere well cached.
// # TODO: Formalize this process and make it a github action
