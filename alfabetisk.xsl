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
	<xsl:key name="conceptID" match="iso25964:ISO25964Interchange/iso25964:Thesaurus/iso25964:ThesaurusConcept" use="iso25964:identifier" />
	<xsl:key name="hasRel" match="iso25964:ISO25964Interchange/iso25964:AssociativeRelationship" use="iso25964:hasRelatedConcept"/>
	<xsl:key name="isRel" match="iso25964:ISO25964Interchange/iso25964:AssociativeRelationship" use="iso25964:isRelatedConcept"/>
	<xsl:key name="rel" match="iso25964:ISO25964Interchange/iso25964:AssociativeRelationship" use="iso25964:isRelatedConcept|iso25964:hasRelatedConcept"/>
	
	
	<xsl:template match="iso25964:ISO25964Interchange">
		<div class="alfabetisk">
			<xsl:for-each select="iso25964:Thesaurus/iso25964:ThesaurusConcept/iso25964:PreferredTerm | iso25964:Thesaurus/iso25964:ThesaurusConcept/iso25964:SimpleNonPreferredTerm">
				<xsl:sort select="translate(iso25964:lexicalValue, 'abcdefghijklmnopqrstuvwxyzæøå','ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ')" order="ascending" />
				<div class="term">
					<!--Vis termen-->
					<div class="preferredTerm nonPreferredTerm">
						<xsl:choose>
							<xsl:when test="(../iso25964:notation) and not(iso25964:role)">
								<b><xsl:value-of select="iso25964:lexicalValue"/></b>
								<span class="identifier">(<xsl:value-of select="../iso25964:notation"/>)</span>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="iso25964:lexicalValue"/>
							</xsl:otherwise>
						</xsl:choose>
					</div>
					<xsl:variable name="vThisTerm" select="../iso25964:identifier"/>
					<!--Hvis termen har en status, for eksempel som "Dårlig Term", vis en rød melding-->
					<!--<div class="status"> 
							<xsl:if test="../iso25964:status">
								<xsl:value-of select="../iso25964:status"/>
							</xsl:if>
					</div>-->
					<!--Hvis termen er en foretrukken term og har en Scope Note, vis denne-->
					<xsl:choose>
						<xsl:when test="iso25964:role">
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="../iso25964:ScopeNote/iso25964:lexicalValue">
								<div class="scopeNote">NOTE: <xsl:value-of select="../iso25964:ScopeNote/iso25964:lexicalValue"/></div>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
					<!--Hvis termen er en foretrukken term og har uforetrukne termer, vis at denne er brukt for disse-->
					<xsl:choose>
						<xsl:when test="iso25964:role">
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="../iso25964:SimpleNonPreferredTerm">
								<div class="useFor">BF: 
									<xsl:for-each select="../iso25964:SimpleNonPreferredTerm">
										<xsl:sort select="translate(iso25964:lexicalValue, 'abcdefghijklmnopqrstuvwxyzæøå','ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ')" order="ascending" />
										<xsl:value-of select="iso25964:lexicalValue"/> <br/>
									</xsl:for-each>
								</div>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
					<!--Hvis dette er en uforetrukken term, bruk foretrukken term-->
					<xsl:variable name="vPreferredTerm" select="../iso25964:PreferredTerm/iso25964:lexicalValue"/>
					<xsl:if test="iso25964:role">
						<div class="use">
							BRUK <xsl:value-of select="$vPreferredTerm"/><span class="identifier">(<xsl:value-of select="../iso25964:notation"/>)</span>
						</div>
					</xsl:if>
					<!--Hvis termen er en foretrukken term og har en overordnet term, vis denne-->
					<xsl:choose>
						<xsl:when test="iso25964:role">
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="//iso25964:HierarchicalRelationship">
								<xsl:if test="iso25964:hasHierRelConcept = $vThisTerm">
									<div class="broaderTerm">
										<xsl:variable name="vBroaderTerm" select="iso25964:isHierRelConcept"/>
										OT: 
										<xsl:for-each select="//iso25964:Thesaurus/iso25964:ThesaurusConcept">
											<xsl:if test="iso25964:identifier = $vBroaderTerm">
												<xsl:value-of select="iso25964:PreferredTerm/iso25964:lexicalValue"/>
											</xsl:if>
										</xsl:for-each>
										<br/>
									</div>
								</xsl:if>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
					<!--Hvis termen er en foretrukken term og har underordnete termer, vis disse-->
					<xsl:choose>
						<xsl:when test="iso25964:role">
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="key('nodeChildren2',../iso25964:identifier)">
								<div class="narrowerTerm">UT: 
									<xsl:for-each select="key('nodeChildren2',../iso25964:identifier)">
										<xsl:sort select="translate(key('conceptID', iso25964:hasHierRelConcept)/iso25964:PreferredTerm/iso25964:lexicalValue, 'abcdefghijklmnopqrstuvwxyzæøå','ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ')" order="ascending"/>
										<xsl:value-of select="key('conceptID', iso25964:hasHierRelConcept)/iso25964:PreferredTerm/iso25964:lexicalValue"/><br/>
									</xsl:for-each>
								</div>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
					<!--Hvis termen er en foretrukken term og har relaterte termer, vis disse-->
					<xsl:if test="not(iso25964:role)">
						<xsl:if test="key('rel',../iso25964:identifier)">
							<div class="relatedTerm">SO: 
								<xsl:for-each select="//iso25964:AssociativeRelationship">
									<xsl:sort select="translate(key('conceptID', iso25964:isRelatedConcept|iso25964:hasRelatedConcept)/iso25964:PreferredTerm/iso25964:lexicalValue, 'abcdefghijklmnopqrstuvwxyzæøå','ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ')"/>
									<xsl:sort select="translate(key(
																	'conceptID', (
																		concat(
																			substring('iso25964:isRelatedConcept', number(not(key('conceptID', iso25964:hasRelatedConcept)))*26),
																			substring('iso25964:hasRelatedConcept', number(not(key('conceptID', iso25964:isRelatedConcept)))*27)
																		) 
																	)
																)
																/iso25964:PreferredTerm/iso25964:lexicalValue, 'abcdefghijklmnopqrstuvwxyzæøå','ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ')" order="ascending"/>
									<xsl:if test="iso25964:isRelatedConcept = $vThisTerm">
										<xsl:value-of select="key('conceptID', iso25964:hasRelatedConcept)/iso25964:PreferredTerm/iso25964:lexicalValue"/><br/>
									</xsl:if>
									<xsl:if test="iso25964:hasRelatedConcept = $vThisTerm">
										<xsl:value-of select="key('conceptID', iso25964:isRelatedConcept)/iso25964:PreferredTerm/iso25964:lexicalValue"/><br/>
									</xsl:if>
								</xsl:for-each>
							</div>
						</xsl:if>
					</xsl:if>
				</div>
			</xsl:for-each>
		</div>
	</xsl:template>
</xsl:stylesheet>