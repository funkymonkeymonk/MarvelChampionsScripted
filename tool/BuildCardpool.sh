#!/usr/bin/env bash
set -ex

CARDPOOL_DATA_PATH=../../mod/src/MarvelChampionsLCG/CardpoolData.lua

rm -rf temp
mkdir temp && cd temp
gh repo clone zzorba/marvelsdb-json-data

printf "CARDPOOL_JSON = [[\n" > $CARDPOOL_DATA_PATH
cat  marvelsdb-json-data/pack/*.json |\
 jq --slurp 'flatten(1) | del(.[] | select(.name == null)) | map(. | {code, name, subname, type_code, faction_code, BackURL: "http://cloud-3.steamusercontent.com/ugc/1795242553066035592/AEE6A404260E9B5DEE79D2B19CB39F982DCA574D/", FrontURL: ("https://cerebrodatastorage.blob.core.windows.net/cerebro-cards/official/" + (.code  | ascii_upcase )+ ".jpg")})' \
 >> $CARDPOOL_DATA_PATH
printf "]]" >> $CARDPOOL_DATA_PATH

# TODO: Create a standard card back for each type and attach them to the object based on the type
# TODO: Create a "fallback image" for cards that don't have a front yet
# TODO: Upload images to somewhere well cached.

# TODO: Formalize this process and make it a github action