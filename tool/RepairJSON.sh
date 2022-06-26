#!/usr/bin/env bash
set -ex

echo 'Run from root of project'

grep error temp.log | \
  sed 's/error:  //g' | \
  sed 's/.json.*/.json/g' > files-to-fix

wc -l files-to-fix

# Deletes the last line over and over again
cat files-to-fix | xargs -I% sed -i.bak '$d' %
cat files-to-fix | xargs -n 1 -P 10 -I%  npx ajv -d % -s ./mod//schema/GenericObject.json --strict --errors=line --changes=line 2>temp.log >/dev/null