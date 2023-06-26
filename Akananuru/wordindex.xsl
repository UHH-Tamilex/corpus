<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:exsl="http://exslt.org/common"
                xmlns:x="http://www.tei-c.org/ns/1.0"
                xmlns:tst="https://github.com/tst-project"
                exclude-result-prefixes="x tst">

<xsl:import href="lib/xslt/copy.xsl"/>
<xsl:import href="lib/xslt/functions.xsl"/>
<xsl:import href="lib/xslt/definitions.xsl"/>
<xsl:import href="lib/xslt/common.xsl"/>
<xsl:import href="lib/xslt/teiheader.xsl"/>
<xsl:import href="lib/xslt/transcription.xsl"/>
<xsl:import href="lib/xslt/apparatus.xsl"/>

<xsl:output method="html" encoding="UTF-8" omit-xml-declaration="yes" indent="no"/>

<xsl:param name="root">./lib/</xsl:param>
<xsl:param name="debugging">false</xsl:param>

<xsl:template match="x:TEI">
    <xsl:call-template name="TEI"/>
</xsl:template>

<xsl:template name="TEI">
    <xsl:element name="html">
        <xsl:element name="head">
            <xsl:element name="meta">
                <xsl:attribute name="charset">utf-8</xsl:attribute>
            </xsl:element>
            <xsl:element name="meta">
                <xsl:attribute name="name">viewport</xsl:attribute>
                <xsl:attribute name="content">width=device-width,initial-scale=1</xsl:attribute>
            </xsl:element>
            <xsl:element name="title">
                <xsl:value-of select="//x:titleStmt/x:title"/>
            </xsl:element>
            <xsl:element name="link">
                <xsl:attribute name="rel">icon</xsl:attribute>
                <xsl:attribute name="type">image/png</xsl:attribute>
                <xsl:attribute name="href">lib/img/favicon-32.png</xsl:attribute>
            </xsl:element>
            <xsl:element name="link">
                <xsl:attribute name="rel">stylesheet</xsl:attribute>
                <xsl:attribute name="href"><xsl:value-of select="$root"/>css/tufte.css</xsl:attribute>
            </xsl:element>
            <xsl:element name="link">
                <xsl:attribute name="rel">stylesheet</xsl:attribute>
                <xsl:attribute name="href"><xsl:value-of select="$root"/>css/fonts.css</xsl:attribute>
            </xsl:element>
            <xsl:element name="link">
                <xsl:attribute name="rel">stylesheet</xsl:attribute>
                <xsl:attribute name="href"><xsl:value-of select="$root"/>css/tst.css</xsl:attribute>
            </xsl:element>
            <xsl:element name="link">
                <xsl:attribute name="rel">stylesheet</xsl:attribute>
                <xsl:attribute name="href"><xsl:value-of select="$root"/>css/header.css</xsl:attribute>
            </xsl:element>
            <xsl:element name="link">
                <xsl:attribute name="rel">stylesheet</xsl:attribute>
                <xsl:attribute name="href"><xsl:value-of select="$root"/>css/transcription.css</xsl:attribute>
            </xsl:element>
            <xsl:element name="link">
                <xsl:attribute name="rel">stylesheet</xsl:attribute>
                <xsl:attribute name="href"><xsl:value-of select="$root"/>css/apparatus.css</xsl:attribute>
            </xsl:element>
            <xsl:if test="$debugging = 'true'">
                <xsl:element name="link">
                    <xsl:attribute name="rel">stylesheet</xsl:attribute>
                    <xsl:attribute name="href">debugging/prism.css</xsl:attribute>
                </xsl:element>
            </xsl:if>
            <xsl:element name="link">
                <xsl:attribute name="rel">stylesheet</xsl:attribute>
                <xsl:attribute name="href">edition.css</xsl:attribute>
            </xsl:element>
            <xsl:element name="link">
                <xsl:attribute name="rel">stylesheet</xsl:attribute>
                <xsl:attribute name="href">wordindex.css</xsl:attribute>
            </xsl:element>
            <xsl:element name="style">
                <xsl:text>
                </xsl:text>
            </xsl:element>
            <xsl:element name="script">
                <xsl:attribute name="type">module</xsl:attribute>
                <xsl:attribute name="src">edition.mjs</xsl:attribute>
                <xsl:attribute name="id">editionscript</xsl:attribute>
            </xsl:element>
            <xsl:element name="script">
                <xsl:attribute name="src">raphael-min.js</xsl:attribute>
            </xsl:element>
            <xsl:element name="script">
                <xsl:attribute name="src">jsphylosvg-min.js</xsl:attribute>
            </xsl:element>
            <xsl:element name="script">
                <xsl:attribute name="type">module</xsl:attribute>
                <xsl:attribute name="src">wordindex.mjs</xsl:attribute>
            </xsl:element>
        </xsl:element>
        <xsl:element name="body">
            <xsl:attribute name="lang">en</xsl:attribute>   
            <xsl:element name="div">
                <xsl:attribute name="id">recordcontainer</xsl:attribute>
                <xsl:element name="div">
                    <xsl:choose>
                        <xsl:when test="x:facsimile/x:graphic">
                            <xsl:attribute name="id">record-thin</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="id">record-fat</xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:element name="div">
                        <xsl:attribute name="id">topbar</xsl:attribute>
                        <xsl:element name="div">
                            <xsl:attribute name="id">transbutton</xsl:attribute>
                            <xsl:attribute name="data-anno">change script</xsl:attribute>
                            <xsl:text>A</xsl:text>
                        </xsl:element>
                        <xsl:element name="div">
                            <xsl:attribute name="id">wordsplitbutton</xsl:attribute>
                            <xsl:attribute name="data-anno">word-split text</xsl:attribute>
<svg id="wordsplitsvg" width="22" height="22" viewBox="0 0 17 17" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><path d="M2.207 8h3.772v1h-3.772l1.646 1.646-0.707 0.707-2.853-2.853 2.854-2.854 0.707 0.707-1.647 1.647zM13.854 5.646l-0.707 0.707 1.646 1.647h-3.772v1h3.772l-1.646 1.646 0.707 0.707 2.853-2.853-2.853-2.854zM8 17h1v-17h-1v17z" fill="#000000" /></svg>
<svg id="metricalsvg" width="22" height="22" version="1.1" viewBox="0 0 17 17" xmlns="http://www.w3.org/2000/svg"><a><path d="m3.059 5.646-0.707 0.707 1.646 1.647h-3.772v1h3.772l-1.646 1.646 0.707 0.707 2.853-2.853zm4.941 11.354h1v-17h-1z"/></a><path d="m13.018 7.9969h3.772v1h-3.772l1.646 1.646-0.707 0.707-2.853-2.853 2.854-2.854 0.707 0.707z"/></svg>
                        </xsl:element>
                        <xsl:element name="div">
                            <xsl:attribute name="id">apparatusbutton</xsl:attribute>
                            <xsl:attribute name="data-anno">apparatus of variants</xsl:attribute>
<svg id="apparatussvg" width="22" height="21" fill="#000000" version="1.1" viewBox="0 0 381.66 415.46" xmlns="http://www.w3.org/2000/svg"><g fill="none" stroke="#000"><path d="m10.395 208.37c2.6785-185.49 346.77-166.49 346.77-166.49" stroke-width="20.48px"/><path d="m10.239 206.9c2.6785 185.49 346.77 166.49 346.77 166.49" stroke-width="20.48px"/><path d="m14.182 210.85 315.07 0.84841" stroke-width="20.581px"/><g stroke-width="21.098px"><path d="m287.4 179.06 54.215 32.066-51.981 34.443"/><path d="m307.59 9.0797 54.215 32.066-51.981 34.443"/><path d="m305.3 340.15 54.215 32.066-51.981 34.443"/></g></g></svg>
<svg id="translationsvg" width="22" height="21" fill="#000000" version="1.1" viewBox="0 0 381.66 415.46" xmlns="http://www.w3.org/2000/svg"><g fill="none" stroke="#000" stroke-width="22.641px"><path d="m-0.58397 41.896h381.87"/><path d="m-0.58397 205.74h381.87"/><path d="m-0.58397 369.58h381.87"/></g></svg>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="article">
                        <xsl:apply-templates/>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
            <xsl:variable name="manifest" select="x:facsimile/x:graphic/@url"/>
            <xsl:if test="$manifest">
                <xsl:element name="div">
                    <xsl:attribute name="id">viewer</xsl:attribute>
                    <xsl:attribute name="data-manifest">
                        <xsl:value-of select="$manifest"/>
                    </xsl:attribute>
                    <xsl:variable name="start" select="x:facsimile/x:graphic/@facs"/>
                    <xsl:attribute name="data-start">
                        <xsl:choose>
                            <xsl:when test="$start"><xsl:value-of select="$start - 1"/></xsl:when>
                            <xsl:otherwise>0</xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                </xsl:element>
            </xsl:if>
        </xsl:element>
    </xsl:element>
</xsl:template>

<xsl:template match="x:teiHeader">
    <xsl:element name="section">
        <xsl:call-template name="lang"/>
        <xsl:apply-templates />
    </xsl:element>
</xsl:template>
<xsl:template match="x:listWit">
    <xsl:element name="div">
        <xsl:attribute name="class">listWit</xsl:attribute>
        <xsl:apply-templates />
    </xsl:element>
</xsl:template>
<xsl:template match="x:witness">
    <xsl:element name="div">
        <xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
        <xsl:element name="div">
            <xsl:attribute name="class">abbr</xsl:attribute>
            <xsl:apply-templates select="x:abbr/node()"/>
        </xsl:element>
        <xsl:element name="div">
            <xsl:attribute name="class">expan</xsl:attribute>
            <xsl:apply-templates select="x:expan/node()"/>
        </xsl:element>
    </xsl:element>
</xsl:template>

<xsl:template match="x:xenoData">
    <div id="nexml"><xsl:copy-of select="./*"/></div>
</xsl:template>

<xsl:template match="x:text/x:body/x:div">
    <xsl:element name="div">
        <xsl:attribute name="class">dict-group</xsl:attribute>
        <xsl:element name="div">
            <xsl:apply-templates select="x:entry"/>
        </xsl:element>
        <xsl:apply-templates select="x:head"/>
    </xsl:element>
</xsl:template>
<xsl:template match="x:head">
    <xsl:element name="h2">
        <xsl:attribute name="class">dict-letter</xsl:attribute>
        <xsl:apply-templates/>
    </xsl:element>
</xsl:template>

<xsl:template match="x:text/x:body/x:div/x:div">
    <xsl:element name="div">
        <xsl:attribute name="class">wide</xsl:attribute>
        <xsl:call-template name="lang"/>
        <xsl:apply-templates/>
    </xsl:element>
</xsl:template>

<xsl:template match="x:entry">
    <xsl:element name="details">
        <xsl:attribute name="class">dict</xsl:attribute>
        <xsl:attribute name="id"><xsl:value-of select="x:form[@type='standard']"/></xsl:attribute>
        <xsl:apply-templates select="x:form[@type='standard']"/>
        <xsl:element name="div">
            <xsl:attribute name="class">dict-entry</xsl:attribute>
            <xsl:if test="x:form[@type='sandhi']">
                <xsl:element name="h4">
                    <xsl:attribute name="lang">en</xsl:attribute>
                    <xsl:text>sandhi forms</xsl:text>
                </xsl:element>
                <xsl:element name="div">
                    <xsl:attribute name="class">dict-sandhi</xsl:attribute>
                    <xsl:apply-templates select="x:form[@type='sandhi']"/>
                </xsl:element>
            </xsl:if>
            <xsl:if test="x:def">
                <xsl:element name="div">
                    <xsl:element name="h4">
                        <xsl:attribute name="lang">en</xsl:attribute>
                        <xsl:text>translations</xsl:text>
                    </xsl:element>
                    <xsl:element name="div">
                        <xsl:attribute name="class">dict-definitions</xsl:attribute>
                        <xsl:apply-templates select="x:def"/>
                    </xsl:element>
                </xsl:element>
            </xsl:if>
            <xsl:if test="x:cit">
                <xsl:element name="div">
                    <xsl:element name="h4">
                        <xsl:attribute name="lang">en</xsl:attribute>
                        <xsl:text>citations</xsl:text>
                    </xsl:element>
                    <xsl:element name="div">
                        <xsl:attribute name="class">dict-citations</xsl:attribute>
                        <xsl:apply-templates select="x:cit"/>
                    </xsl:element>
                </xsl:element>
            </xsl:if>
            <xsl:if test="x:app">
                <xsl:element name="div">
                    <xsl:element name="h4">
                        <xsl:attribute name="lang">en</xsl:attribute>
                        <xsl:text>variant readings</xsl:text>
                    </xsl:element>
                    <xsl:element name="div">
                        <xsl:attribute name="class">dict-variants</xsl:attribute>
                        <xsl:apply-templates select="x:app"/>
                    </xsl:element>
                </xsl:element>
            </xsl:if>
        </xsl:element>
    </xsl:element>
    <xsl:element name="hr"/>
</xsl:template>

<xsl:template match="x:form[@type='standard']">
    <xsl:element name="summary">
        <xsl:attribute name="class">dict-heading</xsl:attribute>
        <xsl:apply-templates/>
    </xsl:element>
</xsl:template>
<xsl:template match="x:form[@type='sandhi']">
    <xsl:element name="span">
        <xsl:apply-templates/>
    </xsl:element>
</xsl:template>

<xsl:template match="x:def">
    <xsl:element name="span">
        <xsl:call-template name="lang"/>
        <xsl:apply-templates/>
    </xsl:element>
</xsl:template>

<xsl:template match="x:cit">
    <xsl:element name="div">
        <xsl:apply-templates/>
    </xsl:element>
</xsl:template>
<xsl:template match="x:cit/x:q">
    <xsl:call-template name="splitwit">
        <xsl:with-param name="mss" select="@corresp"/>
    </xsl:call-template>
    <xsl:text> </xsl:text>
    <xsl:element name="span">
        <xsl:apply-templates/>
    </xsl:element>
</xsl:template>

<xsl:template match="x:app">
    <xsl:element name="details">
        <xsl:attribute name="class">dict-app</xsl:attribute>
        <xsl:element name="summary">
            <xsl:call-template name="splitwit">
                <xsl:with-param name="mss" select="@corresp"/>
            </xsl:call-template>
            <xsl:text> </xsl:text>
            <xsl:element name="div">
                <xsl:attribute name="class">dict-rdgs</xsl:attribute>
                <xsl:apply-templates select="x:lem"/>
                <xsl:apply-templates select="x:rdg"/>
            </xsl:element>
        </xsl:element>
        <xsl:element name="div">
            <xsl:attribute name="class">treebox</xsl:attribute>
        </xsl:element>
    </xsl:element>
</xsl:template>

<xsl:template match="x:rdg">
    <xsl:element name="span">
        <xsl:attribute name="class">dict-rdg</xsl:attribute>
        <xsl:attribute name="data-wit">
            <xsl:value-of select="translate(@wit,'#','')"/>
        </xsl:attribute>
        <xsl:apply-templates/>
    </xsl:element>
</xsl:template>

<xsl:template match="x:lem">
    <xsl:element name="span">
        <xsl:attribute name="class">dict-lemma</xsl:attribute>
        <xsl:attribute name="data-wit">
            <xsl:value-of select="translate(@wit,'#','')"/>
        </xsl:attribute>
        <xsl:apply-templates/>
    </xsl:element>
</xsl:template>

</xsl:stylesheet>
