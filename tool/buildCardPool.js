const {Octokit} = require("octokit")
const axios = require("axios")
const fs = require('fs')
const path = require('path')

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
    // TODO: Set the back URL based on type_code
    const cardBack = "http://cloud-3.steamusercontent.com/ugc/1795242553066035592/AEE6A404260E9B5DEE79D2B19CB39F982DCA574D/"

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
                BackURL: cardBack,
                FrontURL: "https://cerebrodatastorage.blob.core.windows.net/cerebro-cards/official/" + card.code.toUpperCase() + ".jpg",
            }
        })
}

function sortCards(cards) {
    return [cards];
}

function WriteToMod(cards) {
    // TODO: write pack data into the relevant mod locations
    const header = "CARDPOOL_JSON = [[\n"
    const footer = "\n]]"

    const content = header + JSON.stringify(cards[0], null, 2) + footer

    const filepath = path.join(__dirname, '..', 'mod', 'src', 'MarvelChampionsLCG', 'CardpoolData.lua')

    fs.writeFile(filepath, content, err => {
        if (err) {
            console.error(err);
        }
        // file written successfully
    });
}

async function start () {
    const responses = await getDataFromGithub()
    const packData = FormatPackData(responses)
    const sortedCards = sortCards(packData)
    WriteToMod(sortedCards)
}

start()

// printf "CARDPOOL_JSON = [[\n" > $CARDPOOL_DATA_PATH
// cat  marvelsdb-json-data/pack/*.json |\
//  jq --slurp 'flatten(1) | del(.[] | select(.name == null)) | map(. | {code, name, subname, type_code, faction_code, BackURL: "http://cloud-3.steamusercontent.com/ugc/1795242553066035592/AEE6A404260E9B5DEE79D2B19CB39F982DCA574D/", FrontURL: ("https://cerebrodatastorage.blob.core.windows.net/cerebro-cards/official/" + (.code  | ascii_upcase )+ ".jpg")})' \
//  >> $CARDPOOL_DATA_PATH
// printf "]]" >> $CARDPOOL_DATA_PATH

// # TODO: Create a "fallback image" for cards that don't have a front yet
// # TODO: Upload images to somewhere well cached.
// # TODO: Formalize this process and make it a github action
//
// clean up any files