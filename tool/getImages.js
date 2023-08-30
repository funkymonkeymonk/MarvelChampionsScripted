const { Octokit } = require("octokit")
const axios = require("axios")
const fs = require('fs')
const path = require('path')
const _ = require('underscore');
const IMG_ROOT = 'https://dcqvlrey92bew.cloudfront.net/'

async function getDataFromGithub() {
    const octokit = new Octokit({
        auth: process.env.GITHUB_TOKEN,
    });

    const { data } = await octokit.rest.repos.getContent({
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
    function GetCardBack(card) {
        const cardBack = {
            "player": "http://cloud-3.steamusercontent.com/ugc/1795242553066035592/AEE6A404260E9B5DEE79D2B19CB39F982DCA574D/",
            "encounter": "http://cloud-3.steamusercontent.com/ugc/1795242553066038474/9D6A5F30D060027FFBCF84FF100993FA5AA476DA/",
            "villain": "http://cloud-3.steamusercontent.com/ugc/1833524088514022249/7A90E704A791A39D643453A11CAA1BA6BCF50016/",
        }

        // TODO: Check for exceptions and special cards
        // This is a janky way to do double sided cards but it should work
        if (card.code.slice(-1) === 'a') {
            return IMG_ROOT + card.code.slice(0, -1).toUpperCase() + "B.jpg"
        }
        if (card.code.slice(-1) === 'b') {
            return IMG_ROOT + card.code.slice(0, -1).toUpperCase() + "A.jpg"
        }
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
                ...card.subname && { subname: card.subname },
                type_code: card.type_code,
                faction_code: card.faction_code,
                ...!card.duplicate_of && { BackURL: GetCardBack(card) },
                ...!card.duplicate_of && { FrontURL: IMG_ROOT + card.code.toUpperCase() + ".jpg" },
                duplicate_of: card.duplicate_of,
            }
        })
}


const S3Client = require("@aws-sdk/client-s3").S3Client;
const ListObjectsV2Command = require("@aws-sdk/client-s3").ListObjectsV2Command;

// Get a list of all the files in the s3 bucket
const getImageListFromS3 = async () => {
    const client = new S3Client({});
    var params = {
        Bucket: 'mcscripted',
    };

    const command = new ListObjectsV2Command(params);

    try {
        let isTruncated = true;

        let contents = [];

        while (isTruncated) {
            const { Contents, IsTruncated, NextContinuationToken } = await client.send(command);
            const contentsList = Contents.map((c) => c.Key)
            contents = contents.concat(contentsList)
            isTruncated = IsTruncated;
            command.input.ContinuationToken = NextContinuationToken;
        }
        return contents

    } catch (err) {
        console.error(err);
    }

}

// Get a list of all the cards in the cardpool
const getCardListFromCardpool = async () => {
    const responses = await getDataFromGithub()
    const packData = FormatPackData(responses)
    const uniqCards = packData.filter(card => !card.duplicate_of)
    return uniqCards.map(card => card.code.toUpperCase() + ".jpg")
}

async function downloadImage(filename) {
    BASE_URL = 'https://cerebrodatastorage.blob.core.windows.net/cerebro-cards/official/'
    const image_url = BASE_URL + filename
    try {
        const file = await axios
            .get(image_url, {
                responseType: "stream",
            })
            .then((res) => res.data)
            .catch((err) => console.log(err));
        return {
            "filename": filename,
            "image": file,
        }
    } catch (err) {
        console.log(err);
    }
}

async function getNewCards() {
    const cardpool = await getCardListFromCardpool();
    console.log('Cardpool size: ' + cardpool.length);
    const imagelist = await getImageListFromS3();
    console.log('Image List size: ' + imagelist.length);
    let difference = cardpool.filter(x => !imagelist.includes(x));
    console.log('Difference: ' + difference.length);
    const diff = cardpool.length - imagelist.length
    console.log('Sanity check: ' + diff)
    return difference
}

async function writeFileToTmp(image) {
    const fileName = image.filename
    const data = image.image
    const TEMP_DIR = '../tmp'
    const localFilePath = path.resolve(__dirname, TEMP_DIR, fileName);
    const file = await data.pipe(fs.createWriteStream(localFilePath));
    return {
        "filename": fileName,
        "localFilePath": localFilePath,
    };
}

formatImage = async (file) => {
    const Jimp = require('jimp');
    const filepath = file.localFilePath

    async function retryResize(options, retries = 0) {
        let { imagePath, maxRetries = 5 } = options;
    
        let image = null;
        try {
            image = await Jimp.read(imagePath);
            if (image.bitmap.width > image.bitmap.height) {
                console.log(imagePath)
                image.rotate(90)
                image.write(imagePath)
            }
            
        } catch (e) {
            if (retries >= maxRetries) {
                throw e;
            }
    
            image = await retryResize(options, retries++);
        }
    
        return image;
    }

    const image = await retryResize({"imagePath": filepath})

    return file
}

async function publishToS3 (file) {
    const localFilePath = file.localFilePath
    const fileName = file.filename

    const params = {
        Bucket: "mcscripted",
        Body: fs.createReadStream(localFilePath),
        Key: fileName,
        ContentType: "application/octet-stream",
        ACL: "public-read",
      };
  
      const { Location } = await s3.upload(params).promise()
      console.log(Location)
}

const main = async () => {
    const newCards = await getNewCards();    
    
    const selectedCards = newCards.filter(code => code.startsWith("40"))

    // Download new card images
    const images = await Promise.all(selectedCards.map(downloadImage))

    // Write file to disk
    const files = await Promise.all(images.map(writeFileToTmp))

    const formatted = await Promise.all(files.map(formatImage))

    // # Create a PR with original links? Should humans be in the loop here?

    // # Publish to s3 bucket.
    // Upload params

    await publishToS3(formatted[0])
}

main();

