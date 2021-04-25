<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT"
xmlns:ac="https://w3id.org/atomgraph/client#"
xmlns:xs="http://www.w3.org/2001/XMLSchema"
xmlns:js="http://saxonica.com/ns/globalJS"
xmlns:c="https://www.w3.org/ns/ldt/core/domain#"
exclude-result-prefixes="#all"
extension-element-prefixes="ixsl"
version="2.0"
>

    <xsl:template name="main">
        <xsl:message>"main" template invoked</xsl:message>
    </xsl:template>

    <xsl:template match="button" mode="ixsl:onclick">
        <xsl:value-of select="ixsl:call(ixsl:window(), 'alert', [ 'Hello from Saxon-JS' ])"/>
    </xsl:template>

</xsl:stylesheet>