<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="html"/>

    <xsl:template match="/note">
        <html>
            <script type="text/javascript" src="SaxonJS2.rt.js"></script>
<!--             <script type="text/javascript">
                <![CDATA[
                    window.onload = function() {
                        console.log(SaxonJS.getProcessorInfo().productName + " " +
                        SaxonJS.getProcessorInfo().productVersion + " " + SaxonJS.getProcessorInfo().releaseDate);
                        SaxonJS.transform({
                           stylesheetLocation: "test-pi.xsl.sef.json",
                           initialTemplate: "main",
                           logLevel: 2
                        },
                        "async");
                    }
                ]]>
            </script> -->
            <script type="text/javascript">
                <![CDATA[
                    window.onload = function() {
                        console.log(SaxonJS.getProcessorInfo().productName + " " +
                        SaxonJS.getProcessorInfo().productVersion + " " + SaxonJS.getProcessorInfo().releaseDate);
                        SaxonJS.XPath.evaluate('transform(map{ "stylesheet-location": "test-pi.xsl", "initial-template": "main" })');
                    }
                ]]>
            </script>
            <body>
                <p>
                    <button type="button">Click me!</button>
                </p>
                <p>
                    <a href="test-pi.xsl">Client-side stylesheet</a>. Implemented for the <a href="https://www.saxonica.com/saxon-js/">Saxon-JS 2</a> processor.
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