const {Octokit} = require("octokit")
const axios = require("axios")
const fs = require('fs')
const path = require('path')
const _ = require('underscore');
const IMG_ROOT = 'https://dcqvlrey92bew.cloudfront.net/'

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
  function GetCardFront(card) {
    // This is nasty. I need to spend some time with the upstream datasource and send some PRs to fix it.
    // If I can't fix it there then come back and rethink this cludge.

    if (card.double_sided) {
      if (card.code.toUpperCase().includes("B")) return IMG_ROOT + card.code.slice(0, -1).toUpperCase() + "B.jpg"
      if (card.code.toUpperCase().includes("A")) return IMG_ROOT + card.code.slice(0, -1).toUpperCase() + "A.jpg"
      if (card.code == "39027") return IMG_ROOT + card.code + ".jpg"
      return IMG_ROOT + card.code.toUpperCase() + "A.jpg"
    }

    if (card.type_code === "main_scheme") {
      console.log(card.code)
      if (card.code.toUpperCase().includes("A") || card.code.toUpperCase().includes("B")) return IMG_ROOT  + card.code.toUpperCase() + ".jpg"
      return IMG_ROOT  + card.code.toUpperCase() + "A.jpg"
    }

    return IMG_ROOT + card.code.toUpperCase() + ".jpg"
  }

  function ScrubDoubleBrackets(text) {
    return text.replace(/\[\[/g, '[').replace(/\]\]/g, ']')
  }

  function GetCardBack(card) {
    const cardBack = {
      "player": "http://cloud-3.steamusercontent.com/ugc/1795242553066035592/AEE6A404260E9B5DEE79D2B19CB39F982DCA574D/",
      "encounter": "http://cloud-3.steamusercontent.com/ugc/1795242553066038474/9D6A5F30D060027FFBCF84FF100993FA5AA476DA/",
      "villain": "http://cloud-3.steamusercontent.com/ugc/1833524088514022249/7A90E704A791A39D643453A11CAA1BA6BCF50016/",
    }

    if (card.double_sided) {
      if (card.code.toUpperCase().includes("B")) return IMG_ROOT + card.code.slice(0, -1).toUpperCase() + "A.jpg"
      if (card.code.toUpperCase().includes("A")) return IMG_ROOT + card.code.slice(0, -1).toUpperCase() + "B.jpg"
      // Major Domo fix
      if (card.code == "39027") return cardBack["encounter"]
      return IMG_ROOT + card.code.toUpperCase() + "B.jpg"
    }

    // TODO: Check for exceptions and special cards
    // This is a janky way to do double sided cards but it should work
    if (card.code.slice(-1) === 'a') {
      return IMG_ROOT + card.code.slice(0, -1).toUpperCase() + "B.jpg"
    }
    if (card.code.slice(-1) === 'b') {
      return IMG_ROOT + card.code.slice(0, -1).toUpperCase() + "A.jpg"
    }
    if (card.type_code === "main_scheme") return IMG_ROOT + card.code.toUpperCase() + "B.jpg"
    if (card.type_code === "villain") return cardBack["villain"]
    if (card.faction_code === "encounter") return cardBack["encounter"]
    return cardBack["player"]
  }

  responses.forEach(response => console.log(response.data[0].pack_code))
  return responses
      .map(res => res.data)
      .flat()
      .filter(card => card.name != null || card.duplicate_of != null)
      .map(card => {
        return {
          name: card.name,
          code: card.code,
          ...card.subname && {subname: card.subname},
          type: card.type_code,
          aspect: card.faction_code,
          ...!card.duplicate_of && { BackURL: GetCardBack(card)},
          ...!card.duplicate_of && { FrontURL: GetCardFront(card)},
          duplicate_of: card.duplicate_of,
          ...card.text && {text: ScrubDoubleBrackets(card.text)},
          ...card.flavor && {flavor: card.flavor},
          ...card.health && {health: card.health},
          ...card.health_per_hero && {healthPerHero: card.health_per_hero},
          ...card.is_unique && {isUnique: card.is_unique},
          ...card.traits && {traits: card.traits},
          ...card.thwart && {thwart: card.thwart},
          ...card.attack && {attack: card.attack},
          ...card.defense && {defense: card.defense},
          ...card.recover && {recover: card.recover},
          ...card.hand_size && {handSize: card.hand_size},
          ...card.cost && {cost: card.cost},
          ...card.deck_limit && {deckLimit: card.deck_limit},
          ...card.resource_energy && {resourceEnergy: card.resource_energy},
          ...card.resource_mental && {resourceMental: card.resource_mental},
          ...card.resource_physical && {resourcePhysical: card.resource_physical},
          ...card.resource_wild && {resourceWild: card.resource_wild},
          ...card.thwart_cost && {thwartCost: card.thwart_cost},
          ...card.attack_cost && {attackCost: card.attack_cost},
          ...card.base_threat && {baseThreat: card.base_threat},
          ...card.base_threat_fixed && {baseThreatIsFixed: card.base_threat_fixed},
          ...card.scheme && {scheme: card.scheme},
          ...card.attack_star && {attackStar: card.attack_star},
          ...card.scheme_star && {schemeStar: card.scheme_star},
          ...card.boost && {boost: card.boost},
          ...card.boost_star && {boostStar: card.boost_star},
          ...card.scheme_acceleration && {acceleration: card.scheme_acceleration},
          ...card.scheme_crisis && {crisis: card.scheme_crisis},
          ...card.scheme_hazard && {hazard: card.scheme_hazard},
          ...card.scheme_amplify && {amplify: card.scheme_amplify},
          ...card.back_text && {backText: ScrubDoubleBrackets(card.back_text)},
          ...card.escalation_threat && {escalationThreat: card.escalation_threat},
          ...card.escalation_threat_star && {escalationStar: card.escalation_threat_star},
          ...card.stage && {stage: card.stage},
          ...card.threat && {threat: card.threat}
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

  const filepath = path.join(__dirname, '..', 'mod', 'src', 'MarvelChampionsLCG', 'Cardpool_Data.843931.lua')
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
