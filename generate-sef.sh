#!/bin/bash

npx xslt3 -t -xsl:./client.xsl -export:./client.xsl.sef.json -nogo -ns:##html5

npx xslt3 -t -xsl:./test-pi.xsl -export:./test-pi.xsl.sef.json -nogo -ns:##html5