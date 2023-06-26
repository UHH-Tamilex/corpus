<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:exsl="http://exslt.org/common"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:tst="https://github.com/tst-project"
                exclude-result-prefixes="x tst">

<xsl:output method="html" encoding="UTF-8" omit-xml-declaration="yes"/>

<xsl:template match="tei:TEI">
    <html>
        <body>
            <xsl:apply-templates/>
        </body>
    </html>
</xsl:template>

<xsl:template match="tei:s">
    <xsl:apply-templates/>
</xsl:template>

<!--xsl:template match="tei:w">
    <xsl:choose>
        <xsl:when test="@norm">
            <xsl:variable name="clean" select="translate(@norm,'+=*~%^','')"/>
            <xsl:element name="ruby">
                <xsl:apply-templates/>
                <xsl:element name="rp">(</xsl:element>
                <xsl:element name="rt">
                    <xsl:attribute name="data-anno">lookup <xsl:value-of select="$clean"/> in the Madras lexicon</xsl:attribute>
                    <xsl:value-of select="@norm"/>&#8203;
                </xsl:element>
                <xsl:element name="rp">)</xsl:element>
            </xsl:element>
        </xsl:when>
        <xsl:otherwise>
            <xsl:element name="span">
                <xsl:attribute name="class">word</xsl:attribute>
                <xsl:attribute name="data-anno">lookup <xsl:value-of select="text()"/> in the Madras lexicon</xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template-->

<!--xsl:template match="tei:w">
    <xsl:choose>
        <xsl:when test="@norm">
            <xsl:variable name="clean" select="translate(@norm,'+=*~%^','')"/>
            <xsl:element name="ruby">
                <xsl:apply-templates/>
                <xsl:element name="rp">(</xsl:element>
                <xsl:element name="rt">
                    <xsl:attribute name="lang">ta</xsl:attribute>
                    <xsl:attribute name="data-norm"><xsl:value-of select="$clean"/></xsl:attribute>
                    <xsl:attribute name="data-anno"/>
                    <xsl:element name="span">
                        <xsl:attribute name="lang">en</xsl:attribute>
                        <xsl:attribute name="class">anno-inline</xsl:attribute>
                        <xsl:if test="@ana">
                            <xsl:value-of select="@ana"/>
                            <xsl:element name="hr"/>
                        </xsl:if>
                        <xsl:text>lookup </xsl:text>
                        <xsl:element name="span">
                            <xsl:attribute name="lang">ta</xsl:attribute>
                            <xsl:value-of select="$clean"/>
                        </xsl:element>
                        <xsl:text> in the Madras lexicon</xsl:text>
                    </xsl:element>
                    <xsl:value-of select="@norm"/>&#8203;
                </xsl:element-->
                <!-- zero-width space forces the annotation to be displayed even if it is the same as the text being annotated -->
                <!--xsl:element name="rp">)</xsl:element>
            </xsl:element>
        </xsl:when>
        <xsl:otherwise>
            <xsl:element name="span">
                <xsl:attribute name="class">word</xsl:attribute>
                <xsl:attribute name="data-norm"><xsl:value-of select="text()"/></xsl:attribute>
                    <xsl:attribute name="data-anno"/>
                    <xsl:element name="span">
                        <xsl:attribute name="lang">en</xsl:attribute>
                        <xsl:attribute name="class">anno-inline</xsl:attribute>
                        <xsl:if test="@ana">
                            <xsl:value-of select="@ana"/>
                            <xsl:element name="hr"/>
                        </xsl:if>
                        <xsl:text>lookup </xsl:text>
                        <xsl:element name="span">
                            <xsl:attribute name="lang">ta</xsl:attribute>
                            <xsl:value-of select="text()"/>
                        </xsl:element>
                        <xsl:text> in the Madras lexicon</xsl:text>
                    </xsl:element>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template-->

<xsl:template match="tei:w">
    <xsl:element name="span">
        <xsl:attribute name="class">word</xsl:attribute>
        <xsl:variable name="apos">'</xsl:variable>
        <xsl:variable name="clean" select="translate(translate(@norm,'+=*~%^[]()',''),$apos,'u')"/>
        <xsl:if test="@norm">
            <xsl:attribute name="data-norm"><xsl:value-of select="@norm"/></xsl:attribute>
        </xsl:if>
        <xsl:attribute name="data-anno"/>
        <xsl:element name="span">
            <xsl:attribute name="lang">en</xsl:attribute>
            <xsl:attribute name="class">anno-inline</xsl:attribute>
            <xsl:if test="@ana">
                <xsl:value-of select="@ana"/>
                <xsl:element name="hr"/>
            </xsl:if>
            <xsl:text>lookup </xsl:text>
            <xsl:element name="span">
                <xsl:attribute name="lang">ta</xsl:attribute>
                <xsl:choose>
                    <xsl:when test="$clean"><xsl:value-of select="$clean"/></xsl:when>
                    <xsl:otherwise><xsl:value-of select="text()"/></xsl:otherwise>
                </xsl:choose>
            </xsl:element>
            <xsl:text> in the Madras lexicon</xsl:text>
        </xsl:element>
        <xsl:element name="span">
            <xsl:attribute name="class">lemma</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:element>
</xsl:template>

<xsl:template match="tei:caesura">
    <xsl:element name="br"/>
</xsl:template>

</xsl:stylesheet>
