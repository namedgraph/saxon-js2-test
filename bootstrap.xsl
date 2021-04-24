<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:template match="/note">
        <html>
            <script type="text/javascript" src="SaxonJS2.rt.js"></script>
            <script type="text/javascript">
                <![CDATA[
                    window.onload = function() {
                        console.log(SaxonJS.getProcessorInfo().productName + " " +
                        SaxonJS.getProcessorInfo().productVersion + " " + SaxonJS.getProcessorInfo().releaseDate);
                        SaxonJS.transform({
                           stylesheetLocation: "test-pi.xsl.sef.json",
                           sourceLocation: "test-pi.xml",
                           logLevel: 2
                        },
                        "async");
                    }
                ]]>
            </script>
            <body>
                <p>
                    <button type="button">Click me!</button>
                </p>
                <p>
                    <a href="test-pi.xsl">Client-side stylesheet</a>
                </p>
                <dl>
                    <xsl:apply-templates/>
                </dl>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="*">
        <dt>
            <xsl:value-of select="local-name()"/>
        </dt>
        <dd>
            <xsl:value-of select="."/>
        </dd>
    </xsl:template>

</xsl:stylesheet>