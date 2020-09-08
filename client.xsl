<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT"
xmlns:ac="https://w3id.org/atomgraph/client#"
xmlns:xs="http://www.w3.org/2001/XMLSchema"
exclude-result-prefixes="#all"
extension-element-prefixes="ixsl"
version="2.0"
>

    <xsl:template name="main">
    </xsl:template>

    <!-- test <xsl:call-template> invokation from ac:test() -->

    <xsl:template match="button[@id = 'test-function']" mode="ixsl:onclick">
        <xsl:message>TEST FUNCTION</xsl:message>

        <ixsl:schedule-action http-request="map{ 'method': 'GET', 'href': 'test.xml', 'headers': map{ 'Accept': 'text/xml' } }">
            <xsl:call-template name="function-request-completed">
                <xsl:with-param name="action" select="ac:test#1" as="function(*)"/>
            </xsl:call-template>
        </ixsl:schedule-action>
    </xsl:template>

    <xsl:template name="function-request-completed">
        <xsl:context-item as="map(*)" use="required"/>
        <xsl:param name="action" as="function(*)"/>

        <xsl:sequence select="$action(.)"/>
    </xsl:template>

    <xsl:function name="ac:test">
        <xsl:param name="response" as="map(*)"/>

        <xsl:message>RESPONSE STATUS: <xsl:value-of select="$response?status"/></xsl:message>

        <xsl:call-template name="another-template"/>
    </xsl:function>

    <xsl:template name="another-template">
        <xsl:message>TEMPLATE CALLED FROM FUNCTION</xsl:message>
    </xsl:template>

    <!-- test <xsl:with-param> invoked from <ixsl:schedule-action> -->

    <xsl:template match="button[@id = 'test-param']" mode="ixsl:onclick">
        <xsl:message>TEST FUNCTION</xsl:message>

        <ixsl:schedule-action http-request="map{ 'method': 'GET', 'href': 'test.xml', 'headers': map{ 'Accept': 'text/xml' } }">
            <xsl:call-template name="param-request-completed"/>
        </ixsl:schedule-action>
    </xsl:template>

    <xsl:template name="param-request-completed">
        <xsl:context-item as="map(*)" use="required"/>

        <xsl:choose>
            <xsl:when test="?status = 200 and ?media-type = 'application/xml'">
                <xsl:for-each select="?body">
                    <xsl:variable name="some-value" select="/note/to" as="xs:string?"/>
                    <xsl:if test="$some-value">
                        <ixsl:schedule-action http-request="map{ 'method': 'GET', 'href': 'test.xml', 'headers': map{ 'Accept': 'text/xml' } }">
                            <xsl:call-template name="param-second-request-completed">
                                <xsl:with-param name="some-value" select="$some-value"/>
                            </xsl:call-template>
                        </ixsl:schedule-action>
                    </xsl:if>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="ixsl:call(ixsl:window(), 'alert', [ ?message ])"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="param-second-request-completed">
        <xsl:context-item as="map(*)" use="required"/>
        <xsl:param name="some-value" as="xs:string"/>

        <xsl:message>PARAM $some-value: <xsl:value-of select="$some-value"/></xsl:message>
    </xsl:template>

</xsl:stylesheet>