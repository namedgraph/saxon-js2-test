<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT"
xmlns:ac="https://w3id.org/atomgraph/client#"
xmlns:xs="http://www.w3.org/2001/XMLSchema"
xmlns:js="http://saxonica.com/ns/globalJS"
exclude-result-prefixes="#all"
extension-element-prefixes="ixsl"
version="3.0"
>

    <xsl:template match="*">
        <xsl:value-of select="c:elem"/>
    </xsl:template>

</xsl:stylesheet>