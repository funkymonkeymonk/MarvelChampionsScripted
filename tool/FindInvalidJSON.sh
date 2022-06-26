#!/usr/bin/env bash
set -ex

echo 'Run from root of project'
find ./mod/src/ -name '*.json' | xargs -n 1 -P 100 -I%  npx ajv -d % -s ./mod//schema/GenericObject.json --strict --errors=line --changes=line 2>temp.log >/dev/null