<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT"
xmlns:ac="https://w3id.org/atomgraph/client#" 
exclude-result-prefixes="#all"
extension-element-prefixes="ixsl"
version="2.0"
>

    <xsl:template name="main">
    </xsl:template>

    <xsl:template match="button[@id = 'test']" mode="ixsl:onclick">
        <xsl:message>TEST</xsl:message>

        <ixsl:schedule-action http-request="map{ 'method': 'GET', 'href': 'test.xml', 'headers': map{ 'Accept': 'text/html' } }">
            <xsl:call-template name="request-completed">
                <xsl:with-param name="action" select="ac:test#1" as="function(*)"/>
            </xsl:call-template>
        </ixsl:schedule-action>
    </xsl:template>

    <xsl:template name="request-completed">
        <xsl:context-item as="map(*)" use="required"/>
        <xsl:param name="action" as="function(*)"/>

        <xsl:sequence select="$action(.)"/>
    </xsl:template>

    <xsl:function name="ac:test">
        <xsl:param name="response" as="map(*)"/>

        <xsl:message>RESPONSE STATUS: <xsl:value-of select="$response?status"/></xsl:message>
    </xsl:function>

</xsl:stylesheet>