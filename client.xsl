<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT"
xmlns:ac="https://w3id.org/atomgraph/client#"
xmlns:xs="http://www.w3.org/2001/XMLSchema"
xmlns:js="http://saxonica.com/ns/globalJS"
xmlns:c="https://www.w3.org/ns/ldt/core/domain#"
xmlns:svg="http://www.w3.org/2000/svg"
exclude-result-prefixes="#all"
extension-element-prefixes="ixsl"
version="2.0"
>

    <!-- <xsl:import href="import.xsl"/> -->

    <xsl:param name="global-param" as="xs:anyURI"/>

    <xsl:key name="elements-by-class" match="*" use="@class"/>
    <xsl:key name="lines-by-start" match="svg:line" use="@ac:id1"/>
    <xsl:key name="lines-by-end" match="svg:line" use="@ac:id2"/>

    <xsl:variable name="xhtml" as="document-node()">
        <xsl:document>
            <html lang="en">
               <head></head>
               <body>
                  <div id="abc" class="some-class"/>
               </body>
            </html>
        </xsl:document>
    </xsl:variable>

    <xsl:template name="main">
        <xsl:message>GLOBAL PARAM: <xsl:value-of select="$global-param"/></xsl:message>

        <xsl:message>TEST FUNCTION</xsl:message>

        <ixsl:schedule-action http-request="map{ 'method': 'GET', 'href': 'test.xml', 'headers': map{ 'Accept': 'text/xml' } }">
            <xsl:call-template name="param-request-completed"/>
        </ixsl:schedule-action>

        <xsl:call-template name="some-template"/>
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

    <!-- @CLASS KEY() -->

    <xsl:template match="button[@id = 'class-key']" mode="ixsl:onclick">
        <xsl:result-document href="#wrapper" method="ixsl:replace-content">
            <xsl:copy-of select="$xhtml//body/*"/>
        </xsl:result-document>

        <xsl:call-template name="some-template"/>
    </xsl:template>

    <xsl:template name="some-template">
        <xsl:for-each select="id('abc', ixsl:page())">
            <xsl:value-of select="ixsl:call(ixsl:window(), 'alert', [ 'Found by @id' ])"/>
        </xsl:for-each>
        <xsl:for-each select="key('elements-by-class', 'some-class', ixsl:page())">
            <xsl:value-of select="ixsl:call(ixsl:window(), 'alert', [ 'Found by @class' ])"/>
        </xsl:for-each>
    </xsl:template>

    <!-- NEXT MATCH -->

    <xsl:template match="button[@id = 'next-match']" mode="ixsl:onclick" priority="1">
        <xsl:message>button[@id = 'next-match']</xsl:message>

        <xsl:next-match/>
    </xsl:template>

    <xsl:template match="button[@class = 'whateverest']" mode="ixsl:onclick">
        <xsl:message>button[@class = 'whateverest']</xsl:message>
    </xsl:template>

    <!--EMPTY VALUE -->

    <xsl:template match="input[@id = 'empty-value']" mode="ixsl:onclick">
        <xsl:message>ixsl:contains(., 'value'): <xsl:value-of select="ixsl:contains(., 'value')"/> ixsl:get(., 'value'): <xsl:value-of select="ixsl:get(., 'value')"/></xsl:message>
    </xsl:template>

    <!-- CIRCULAR KEY -->

<!--     <xsl:template match="button[@id = 'circular-key']" mode="ixsl:onclick">
        <xsl:message>
            <xsl:for-each select="key('lines-by-start', @id, ixsl:page()) | key('lines-by-end', @id, ixsl:page())">
                <xsl:copy-of select="."/>
            </xsl:for-each>
        </xsl:message>
    </xsl:template> -->

    <!-- SVG EVENTS -->

    <xsl:template match="svg:circle" mode="ixsl:onclick">
        <xsl:value-of select="ixsl:call(ixsl:window(), 'alert', [ 'svg:circle onclick' ])"/>
    </xsl:template>

    <xsl:template match="svg:circle" mode="ixsl:ondrag">
        <xsl:value-of select="ixsl:call(ixsl:window(), 'alert', [ 'svg:circle ondrag' ])"/>
    </xsl:template>

    <xsl:template match="svg:*" mode="ixsl:onwheel">
        <xsl:value-of select="ixsl:call(ixsl:window(), 'alert', [ 'svg:* onwheel' ])"/>
    </xsl:template>

    <xsl:template match="p" mode="ixsl:ondrag">
        <xsl:message>p ondrag</xsl:message>
    </xsl:template>

    <xsl:template match="p" mode="ixsl:ondragstart">
        <xsl:message>p ondragstart</xsl:message>
        <ixsl:set-property name="dataTransfer.effectAllowed" select="'move'" object="ixsl:event()"/>
        <xsl:sequence select="ixsl:call(ixsl:get(ixsl:event(), 'dataTransfer'), 'setData', [ 'text/uri-list', 'http://whateverest.com' ])"/>
    </xsl:template>

    <xsl:template match="p" mode="ixsl:ondragend">
        <xsl:message>p ondragend</xsl:message>
    </xsl:template>

    <xsl:template match="p" mode="ixsl:ondragover">
        <ixsl:set-property name="dataTransfer.dropEffect" select="'move'" object="ixsl:event()"/>
        <xsl:sequence select="ixsl:call(ixsl:event(), 'preventDefault', [])"/>
        <xsl:message>p ondragover</xsl:message>
    </xsl:template>

    <xsl:template match="p" mode="ixsl:ondrop">
        <xsl:message>
            Data: <xsl:value-of select="ixsl:call(ixsl:get(ixsl:event(), 'dataTransfer'), 'getData', [ 'text/uri-list' ])"/>
        </xsl:message>

        <xsl:sequence select="ixsl:call(ixsl:event(), 'preventDefault', [])"/>
        <xsl:message>p ondrop</xsl:message>
    </xsl:template>

    <!-- SECONDARY TRANSFORMATION -->

    <xsl:template match="button[@id = 'load-mapped-doc']" mode="ixsl:onclick">
        <xsl:message>
            <xsl:copy-of select="document('http://www.w3.org/1999/02/22-rdf-syntax-ns')"/> <!-- URL mapped to test.xml in documentPool -->
        </xsl:message>
        <xsl:message>path(): <xsl:value-of select="path()"/></xsl:message>
    </xsl:template>

    <xsl:template match="button[@id = 'add-listener']" mode="ixsl:onclick">
        <xsl:variable as="element()" name="js-statement">
            <root statement="{{ }}"></root>
        </xsl:variable>
        <xsl:variable name="stylesheet-params" select="ixsl:eval(string($js-statement/@statement))"/>
        <xsl:variable name="template-params" select="ixsl:eval(string($js-statement/@statement))"/>
        <!-- ixslTemplateListener is in client.js -->
        <xsl:variable name="js-function" select="ixsl:call(ixsl:get(ixsl:window(), 'ixslTemplateListener'), 'bind', [ (), static-base-uri(), 'onClickTemplate', $stylesheet-params, $template-params ])"/>
        <xsl:sequence select="ixsl:call(id('onclick-listener', ixsl:page()), 'addEventListener', [ 'click', $js-function ])[current-date() lt xs:date('2000-01-01')]"></xsl:sequence>
    </xsl:template>

    <xsl:template name="onClickTemplate">
        <xsl:message>onClickTemplate</xsl:message>
    </xsl:template>

    <xsl:template match="button[@id = 'onclick-call']" mode="ixsl:onclick">
        <xsl:variable as="element()" name="js-statement">
            <root statement="{{ }}"></root>
        </xsl:variable>
        <xsl:variable name="stylesheet-params" select="ixsl:eval(string($js-statement/@statement))"/>
        <xsl:variable name="template-params" select="ixsl:eval(string($js-statement/@statement))"/>
        <!-- ixslTemplateListener is in client.js -->
        <xsl:sequence select="js:ixslTemplateListener(static-base-uri(), 'onClickTemplate', $stylesheet-params, $template-params, ())[current-date() lt xs:date('2000-01-01')]"/>
    </xsl:template>

    <xsl:template match="button[@id = 'onclick-call-without-params']" mode="ixsl:onclick">
        <!-- ixslTemplateListener is in client.js -->
        <xsl:sequence select="js:ixslTemplateListener(static-base-uri(), 'onClickTemplate', (), (), ())[current-date() lt xs:date('2000-01-01')]"/>
    </xsl:template>

    <!-- LOOKING UP CREATING ELEMENT -->

    <xsl:template match="button[@id = 'look-up-created-element']" mode="ixsl:onclick">
        <xsl:variable name="select-id" select="'select-in-container'" as="xs:string"/>

        <xsl:for-each select="id('container', ixsl:page())">
            <xsl:result-document href="?." method="ixsl:replace-content">
                <select id="{$select-id}"/>
            </xsl:result-document>
        </xsl:for-each>

        <xsl:variable name="container" select="id($select-id, ixsl:page())" as="element()"/>
        <xsl:call-template name="add-options">
            <xsl:with-param name="container" select="$container"/>
            <xsl:with-param name="step" select="1"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="button[@id = 'look-up-created-element-in-schedule-action']" mode="ixsl:onclick">
        <xsl:variable name="select-id" select="'select-in-container'" as="xs:string"/>

        <xsl:for-each select="id('container', ixsl:page())">
            <xsl:result-document href="?." method="ixsl:replace-content">
                <select id="{$select-id}"/>
            </xsl:result-document>
        </xsl:for-each>

        <xsl:for-each select="1 to 5">
            <!-- <xsl:variable name="container" select="id($select-id, ixsl:page())" as="element()"/> -->
            <ixsl:schedule-action wait="2000">
                <xsl:call-template name="add-options">
                    <xsl:with-param name="container" select="id($select-id, ixsl:page())"/>
                    <xsl:with-param name="step" select="."/>
                </xsl:call-template>
            </ixsl:schedule-action>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="add-options">
        <xsl:param name="container" as="element()"/>
        <xsl:param name="step" as="xs:integer"/>
        <xsl:message>Adding options</xsl:message>

        <xsl:for-each select="$container">
            <xsl:result-document href="?." method="ixsl:append-content">
                <option><xsl:value-of select="$step"/></option>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>


    <xsl:template match="button[@id = 'load-doc']" mode="ixsl:onclick">
        <xsl:for-each select="id('base-uri', ixsl:page())">
            <xsl:result-document href="?." method="ixsl:append-content">
                Doc base URI: <xsl:value-of select="base-uri(document('https://namedgraph.github.io/saxon-js2-test/test.xml'))"/>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="button[@id = 'load-doc-async']" mode="ixsl:onclick">
        <ixsl:schedule-action http-request="map{ 'method': 'GET', 'href': 'https://namedgraph.github.io/saxon-js2-test/test.xml', 'headers': map{ 'Accept': 'application/rdf+xml' } }">
            <xsl:call-template name="docLoaded"/>
        </ixsl:schedule-action>
    </xsl:template>

    <xsl:template name="docLoaded">
        <xsl:context-item as="map(*)" use="required"/>
        <xsl:variable name="body" select="?body" as="document-node()"/>
        <xsl:for-each select="id('base-uri', ixsl:page())">
            <xsl:result-document href="?." method="ixsl:append-content">
                Async doc base URI: <xsl:value-of select="base-uri($body)"/>
                <ixsl:set-property name="baseURI" select="'https://namedgraph.github.io/saxon-js2-test/test.xml'" object="$body"/>
                Async doc set base URI: <xsl:value-of select="base-uri($body)"/>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>