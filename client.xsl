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

    <xsl:import href="import.xsl"/>

    <xsl:param name="global-param" as="xs:anyURI"/>

    <xsl:template name="main">
        <xsl:message>GLOBAL PARAM: <xsl:value-of select="$global-param"/></xsl:message>

        <xsl:message>TEST FUNCTION</xsl:message>

        <ixsl:schedule-action http-request="map{ 'method': 'GET', 'href': 'test.xml', 'headers': map{ 'Accept': 'text/xml' } }">
            <xsl:call-template name="param-request-completed"/>
        </ixsl:schedule-action>
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

<!--     <xsl:template match="button[@id = 'test-param']" mode="ixsl:onclick">
        <xsl:message>TEST FUNCTION</xsl:message>
    
        <ixsl:schedule-action http-request="map{ 'method': 'GET', 'href': 'test.xml', 'headers': map{ 'Accept': 'text/xml' } }">
            <xsl:call-template name="param-request-completed"/>
        </ixsl:schedule-action>
    </xsl:template> -->

    <xsl:template name="param-request-completed">
        <xsl:context-item as="map(*)" use="required"/>

        <xsl:choose>
            <xsl:when test="?status = 200 and ?media-type = 'application/xml'">
                <xsl:for-each select="?body">
                    <xsl:variable name="some-value" select="/note/url" as="xs:string?"/>
                    <xsl:message>SOME VALUE: <xsl:value-of select="$some-value"/></xsl:message>
                    <xsl:if test="$some-value">
                        <ixsl:schedule-action http-request="map{ 'method': 'GET', 'href': $some-value, 'headers': map{ 'Accept': 'text/xml' } }">
                            <xsl:call-template name="param-second-request-completed">
                                <xsl:with-param name="some-value" select="$some-value"/>
                                <xsl:with-param name="other-value" select="$global-param"/>
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
        <xsl:param name="other-value" as="xs:string"/>

        <xsl:message>PARAM $some-value: <xsl:value-of select="$some-value"/></xsl:message>
        <xsl:message>PARAM $other-value: <xsl:value-of select="$other-value"/></xsl:message>
    </xsl:template>

    <!-- ONBLUR -->

    <xsl:template match="input[tokenize(@class, ' ') = 'typeahead']" mode="ixsl:onblur">
        <xsl:message>TYPEAHEAD ONBLUR!</xsl:message>
        <xsl:sequence select="ixsl:call(ixsl:window(), 'alert', [ 'typeahead blur' ])"/>
    </xsl:template>

    <!-- ONSUBMIT -->

    <xsl:template match="form" mode="ixsl:onsubmit">
        <xsl:message>FORM ONSUBMIT!</xsl:message>

        <xsl:sequence select="ixsl:call(ixsl:event(), 'preventDefault', [])"/>
        <xsl:sequence select="ixsl:call(ixsl:window(), 'alert', [ 'form submit' ])"/>
    </xsl:template>

    <!-- CUSTOM HANDLER -->
    
    <xsl:template match="button[@id = 'custom-handler']" mode="ixsl:onclick">
        <xsl:message>CUSTOM HANDLER BUTTON</xsl:message>

        <xsl:sequence select="js:customFetch(., 'test.xml')"/>
    </xsl:template>

    <xsl:template match="." mode="ixsl:oncustomEvent">
        <xsl:message>CUSTOM EVENT HANDLER</xsl:message>
        <xsl:variable name="event" select="ixsl:event()"/>
        <xsl:variable name="response" select="ixsl:get($event, 'detail')"/>
        
        <xsl:message>
            RESPONSE URL: <xsl:value-of select="ixsl:get($response, 'url')"/>
        </xsl:message>
    </xsl:template>

    <!-- PUSH STATE -->

    <xsl:template match="button[@id = 'push-state']" mode="ixsl:onclick">
        <xsl:variable name="js-statement" as="element()">
            <root statement="{{ 'state': 'smth' }}"/>
        </xsl:variable>
        <xsl:variable name="json-state" select="ixsl:eval(string($js-statement/@statement))"/>
        <xsl:sequence select="js:history.pushState($json-state, '')[9999999999]"/>

        <xsl:message>
            HISTORY LENGTH: <xsl:value-of select="ixsl:get(ixsl:window(), 'history.length')"/>
        </xsl:message>
    </xsl:template>

    <xsl:template match="button[@id = 'push-state-js']" mode="ixsl:onclick">
        <xsl:variable name="js-statement" as="element()">
            <root statement="history.pushState({{ 'state': 'smth' }}, '')"/>
        </xsl:variable>
        <xsl:sequence select="ixsl:eval(string($js-statement/@statement))[9999999999]"/>

        <xsl:message>
            HISTORY LENGTH: <xsl:value-of select="ixsl:get(ixsl:window(), 'history.length')"/>
        </xsl:message>
    </xsl:template>

    <xsl:template match="button[@id = 'result-page']" mode="ixsl:onclick">
        <xsl:variable name="div-id" select="'some-id'" as="xs:string"/>

        <xsl:result-document href="#{$div-id}" method="ixsl:append-content">
            <div>APPENDED CONTENT</div>
        </xsl:result-document>

        <xsl:for-each select="id($div-id, ixsl:page())">
            <ixsl:set-style name="background-color" select="'red'" object="."/>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>