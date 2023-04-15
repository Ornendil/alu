<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://iso25964.org/ iso25964-1_v1.4" 
	xmlns:iso25964="http://iso25964.org/"
	exclude-result-prefixes="iso25964">
<xsl:output
	encoding="utf-8"
	omit-xml-declaration="yes"
	indent="yes"/>
	
	<xsl:key name="nodeChildren" match="iso25964:ISO25964Interchange/iso25964:Thesaurus/iso25964:ThesaurusArray" use="iso25964:hasSuperOrdinateConcept"/>
	<xsl:key name="nodeParent" match="iso25964:ISO25964Interchange/iso25964:Thesaurus/iso25964:ThesaurusArray" use="iso25964:hasMemberConcept"/>
	<xsl:key name="nodeChildren2" match="iso25964:ISO25964Interchange/iso25964:HierarchicalRelationship" use="iso25964:isHierRelConcept"/>
	<xsl:key name="conceptNr" match="iso25964:ISO25964Interchange/iso25964:Thesaurus/iso25964:ThesaurusConcept" use="iso25964:identifier"/>
	
	<xsl:template match="iso25964:ISO25964Interchange">
				<div class="systematisk"> <!--The main container for all the terms-->
					<xsl:for-each select="iso25964:Thesaurus/iso25964:ThesaurusConcept"><!--Move through all the concepts-->
						<xsl:if test="iso25964:topConcept"><!--Select only the ones that are top concepts-->
							<div class="conceptFamily"> <!--Container for top concepts-->
								<xsl:if test="iso25964:notation">
									<span class="identifier"><xsl:value-of select="iso25964:notation"/></span>
								</xsl:if>
								<xsl:if test="not(iso25964:notation)">
									<span class="identifier">&#160;</span>
								</xsl:if>
								<h3><xsl:value-of select="iso25964:PreferredTerm/iso25964:lexicalValue"/></h3><!--Display the name of the top concepts-->
								<xsl:if test="iso25964:status">
									<div class="status">&lt;<xsl:value-of select="iso25964:status"/>&gt;</div>
								</xsl:if>
								<xsl:apply-templates select="key('nodeChildren',iso25964:identifier)"/><!--Display the arrays where the superordinate concept is equal to the current concept's ID-->
								<xsl:apply-templates select="key('nodeChildren2',iso25964:identifier)"/><!--Display the arrays where the superordinate concept is equal to the current concept's ID-->
							</div>
						</xsl:if>
					</xsl:for-each>
				</div>
	</xsl:template>
	
	<xsl:template match="iso25964:ISO25964Interchange/iso25964:Thesaurus/iso25964:ThesaurusArray">
		<xsl:for-each select="."><!--Move through all arrays-->
			<div class="node">
				<div class="nodeLabel">
					<xsl:value-of select="iso25964:NodeLabel/iso25964:lexicalValue"/><!--Display node label-->
				</div>
				<xsl:for-each select="key('conceptNr',iso25964:hasMemberConcept)"><!--Go through the concepts where the concept's ID is equal to the current member concept-->
					<div class="sub">
						<xsl:if test="iso25964:notation">
							<span class="identifier"><xsl:value-of select="iso25964:notation"/></span>
						</xsl:if>
						<xsl:if test="not(iso25964:notation)">
							<span class="identifier">&#160;</span>
						</xsl:if>
						<span class="lex"><xsl:value-of select="iso25964:PreferredTerm/iso25964:lexicalValue"/></span><!--Display the term for the current member concept-->
						<xsl:if test="iso25964:status">
							<div class="status">&lt;<xsl:value-of select="iso25964:status"/>&gt;</div>
						</xsl:if>
						<xsl:apply-templates select="key('nodeChildren',iso25964:identifier)"/><!--Display the arrays where the superordinate concept is equal to the current concept's ID-->
						<xsl:apply-templates select="key('nodeChildren2',iso25964:identifier)"/><!--Display the arrays where the superordinate concept is equal to the current concept's ID-->
					</div>
				</xsl:for-each>
			</div>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="iso25964:ISO25964Interchange/iso25964:HierarchicalRelationship">
		<xsl:for-each select="."><!--Move through all relationals-->
				<xsl:for-each select="key('conceptNr',iso25964:hasHierRelConcept)"><!--Go through the concepts where the concept's ID is equal to the current narrower concept-->
					<xsl:if test="not(key('nodeParent',iso25964:identifier))"><!--Select the concepts where the concept's ID is not in an array-->
						<div class="node">
							<div class="sub">
								<xsl:if test="iso25964:notation">
									<span class="identifier"><xsl:value-of select="iso25964:notation"/></span>
								</xsl:if>
								<xsl:if test="not(iso25964:notation)">
									<span class="identifier">&#160;</span>
								</xsl:if>
								<span class="lex"><xsl:value-of select="iso25964:PreferredTerm/iso25964:lexicalValue"/></span><!--Display the term for the current member concept-->
								<xsl:if test="iso25964:status">
									<div class="status">&lt;<xsl:value-of select="iso25964:status"/>&gt;</div>
								</xsl:if>
								<xsl:apply-templates select="key('nodeChildren',iso25964:identifier)"/><!--Display the arrays where the superordinate concept is equal to the current concept's ID-->
								<xsl:apply-templates select="key('nodeChildren2',iso25964:identifier)"/><!--Display the arrays where the superordinate concept is equal to the current concept's ID-->
							</div>
						</div>
					</xsl:if>
				</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>