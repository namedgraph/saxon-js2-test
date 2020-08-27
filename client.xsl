<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
    <!ENTITY typeahead  "http://graphity.org/typeahead#">
    <!ENTITY lapp       "https://w3id.org/atomgraph/linkeddatahub/apps/domain#">
    <!ENTITY apl        "https://w3id.org/atomgraph/linkeddatahub/domain#">
    <!ENTITY ac         "https://w3id.org/atomgraph/client#">
    <!ENTITY a          "https://w3id.org/atomgraph/core#">
    <!ENTITY rdf        "http://www.w3.org/1999/02/22-rdf-syntax-ns#">
    <!ENTITY rdfs       "http://www.w3.org/2000/01/rdf-schema#">
    <!ENTITY xsd        "http://www.w3.org/2001/XMLSchema#">
    <!ENTITY owl        "http://www.w3.org/2002/07/owl#">
    <!ENTITY skos       "http://www.w3.org/2004/02/skos/core#">
    <!ENTITY srx        "http://www.w3.org/2005/sparql-results#">
    <!ENTITY http       "http://www.w3.org/2011/http#">
    <!ENTITY ldt        "https://www.w3.org/ns/ldt#">
    <!ENTITY c          "https://www.w3.org/ns/ldt/core/domain#">
    <!ENTITY dh         "https://www.w3.org/ns/ldt/document-hierarchy/domain#">
    <!ENTITY sd         "http://www.w3.org/ns/sparql-service-description#">
    <!ENTITY sp         "http://spinrdf.org/sp#">
    <!ENTITY spin       "http://spinrdf.org/spin#">
    <!ENTITY dct        "http://purl.org/dc/terms/">
    <!ENTITY foaf       "http://xmlns.com/foaf/0.1/">
    <!ENTITY sioc       "http://rdfs.org/sioc/ns#">
]>
<xsl:stylesheet
xmlns:xhtml="http://www.w3.org/1999/xhtml"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT"
xmlns:prop="http://saxonica.com/ns/html-property"
xmlns:style="http://saxonica.com/ns/html-style-property"
xmlns:js="http://saxonica.com/ns/globalJS"
xmlns:xs="http://www.w3.org/2001/XMLSchema"
xmlns:typeahead="&typeahead;"
xmlns:a="&a;"
xmlns:ac="&ac;"
xmlns:lapp="&lapp;"
xmlns:apl="&apl;"
xmlns:rdf="&rdf;"
xmlns:rdfs="&rdfs;"
xmlns:owl="&owl;"
xmlns:ldt="&ldt;"
xmlns:core="&c;"
xmlns:dh="&dh;"
xmlns:srx="&srx;"
xmlns:sd="&sd;"
xmlns:sp="&sp;"
xmlns:spin="&spin;"
xmlns:dct="&dct;"
xmlns:foaf="&foaf;"
xmlns:sioc="&sioc;"
xmlns:skos="&skos;"
xmlns:bs2="http://graphity.org/xsl/bootstrap/2.3.2"
exclude-result-prefixes="xs prop"
extension-element-prefixes="ixsl"
version="2.0"
>

    <!-- INITIAL TEMPLATE -->
    
    <xsl:template name="main">
    </xsl:template>

    <!-- FUNCTIONS -->

    <xsl:template match="button[@id = 'test']" mode="ixsl:onclick">
        <xsl:message>TEST</xsl:message>
    </xsl:template>

    <xsl:template match="button[@class = 'class']" mode="ixsl:onclick">
        <xsl:message>TEST</xsl:message>
    </xsl:template>

</xsl:stylesheet>