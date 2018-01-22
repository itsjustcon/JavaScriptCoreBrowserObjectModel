#!/bin/sh

#  js-libs-updater.sh
#  JS Notepad
#
#  Created by Connor Grady on 1/17/18.
#  Copyright © 2018 Connor Grady. All rights reserved.

CHECKMARK='✓'

# babel-polyfill
mkdir -p ./js-libs/babel-polyfill/
#curl -Ls 'https://unpkg.com/babel-polyfill' > ./js-libs/babel-polyfill/polyfill.js
curl -Ls 'https://unpkg.com/babel-polyfill/dist/polyfill.js' > ./js-libs/babel-polyfill/polyfill.js
echo "$CHECKMARK babel-polyfill"

# whatwg-fetch
mkdir -p ./js-libs/whatwg-fetch/
curl -Ls 'https://unpkg.com/whatwg-fetch' > ./js-libs/whatwg-fetch/fetch.js
#curl -Ls 'https://unpkg.com/whatwg-fetch/fetch.js' > ./js-libs/whatwg-fetch/fetch.js
echo "$CHECKMARK whatwg-fetch"
