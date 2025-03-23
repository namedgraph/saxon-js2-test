#!/bin/bash

npx xslt3-he -t -xsl:./client.xsl -export:./client.xsl.sef.json -nogo -ns:##html5 -relocate:on

npx xslt3-he -t -xsl:./test-pi.xsl -export:./test-pi.xsl.sef.json -nogo -ns:##html5 -relocate:on