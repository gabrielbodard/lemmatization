<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0" exclude-result-prefixes="#all">

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <xsl:variable name="dirpath">../dir.xml</xsl:variable>
    <xsl:variable name="epidocpath">../epidoc-in/</xsl:variable>

    <xsl:template match="/">
        <xsl:variable name="allwords">
            <xsl:element name="words">
                <xsl:for-each select="document($dirpath)//file">
                    <xsl:variable name="thisepidoc" select="."/>
                    <xsl:for-each
                        select="document(concat($epidocpath, $thisepidoc))//tei:w[not(@part)]">
                        <xsl:element name="w">
                            <xsl:copy-of select="@lemma"/>
                            <xsl:value-of select="normalize-unicode(normalize-space(.))"/>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:element>
        </xsl:variable>

        <xsl:variable name="groupwords">
            <xsl:element name="table">
                <xsl:for-each-group select="$allwords//w" group-by=".">
                    <xsl:sort
                        select="lower-case(translate(normalize-unicode(., 'NFKD'),
                        '&#x02BC;&#x0300;&#x0301;&#x0308;&#x0313;&#x0314;&#x0342;&#x0345;',''))"/>
                    <xsl:element name="word">
                        <xsl:element name="form">
                            <xsl:value-of select="."/>
                        </xsl:element>
                        <xsl:element name="lemma">
                            <xsl:for-each-group select="current-group()//@lemma" group-by=".">
                                <xsl:value-of select="."/><xsl:text>, </xsl:text>
                            </xsl:for-each-group>
                        </xsl:element>
                    </xsl:element>
                </xsl:for-each-group>
            </xsl:element>
        </xsl:variable>

        <xsl:result-document href="xml-out/tokentable.xml">
            <xsl:copy-of select="$groupwords"/>
        </xsl:result-document>
    </xsl:template>

</xsl:stylesheet>
