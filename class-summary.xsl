<?xml version="1.0" encoding="UTF-8"?>

<!--

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at
	
	http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
	either express or implied. See the License for the specific language
	governing permissions and limitations under the License.

-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:include href="asdoc-util.xsl"/>
	<xsl:param name="localTitle" select="'All Classes'" />
	<xsl:variable name="title" select="concat($localTitle,' - ',$title-base)"/>

	<xsl:param name="overviewsFile" select="'../xml/overviews.xml'"/>
	<xsl:param name="filter" select="'*'" />
	<xsl:param name="outfile" select="'class-summary'" />

	<xsl:variable name="useFilter">
		<xsl:if test="contains($filter,'*')">
			<xsl:value-of select="substring-before($filter,'*')" />
		</xsl:if>
		<xsl:if test="not(contains($filter,'*'))">
			<xsl:value-of select="$filter" />
		</xsl:if>
	</xsl:variable>

	<xsl:template match="/">
		<xsl:copy-of select="$noLiveDocs" />
		<xsl:copy-of select="$docType" />
		<xsl:element name="html">
			<head>
				<title>
					<xsl:value-of select="$localTitle" />
					<xsl:call-template name="getPageTitlePostFix" />
				</title>
				<xsl:call-template name="getStyleLink">
					<xsl:with-param name="link" select="asdoc/link"/>
				</xsl:call-template>
			</head>
			<body id="asdoc-class-summary">
				<div id="iwebkit-topbar">
					<div id="iwebkit-leftnav">
						<a href="index.html"><img src="images/home.png" alt="home" /></a>
					</div>
					<div id="iwebkit-rightbutton">
						<a href="all-classes.html">List</a>
					</div>
				</div>
				<div id="iwebkit-content">
					<xsl:variable name="overviews" select="document($overviewsFile)/overviews"/>
					<xsl:if test="string-length($overviews/all-classes/description/.) and count($overviews/all-classes)">
						<ul class="pageitem">
							<xsl:call-template name="getTextBox">
								<xsl:with-param name="content">
									<p>
										<xsl:value-of select="$overviews/all-classes/description/. " />
									</p>
									<xsl:for-each select="$overviews/all-classes">
										<xsl:call-template name="sees">
											<xsl:with-param name="xrefId" select="'all-classes'" />
										</xsl:call-template>
									</xsl:for-each>
								</xsl:with-param>
							</xsl:call-template>
						</ul>
					</xsl:if>
					<ul class="pageitem classlist">
						<xsl:for-each select="//asClass[starts-with(@packageName,$useFilter) or ($useFilter='flash.' and @packageName='')]">
							<xsl:sort select="@name" order="ascending" data-type="text"/>
							<xsl:variable name="classPath" select="translate(@packageName,'.','/')"/>
							<xsl:call-template name="getPageItemMenu">
								<xsl:with-param name="name" select="@name" />
								<xsl:with-param name="comment" select="@type" />
								<xsl:with-param name="class" select="concat('menu ',@type)" />
								<xsl:with-param name="href">
									<xsl:if test="$classPath">
										<xsl:value-of select="concat($classPath,'/')" />
									</xsl:if>
									<xsl:value-of select="concat(@name,'.html')"/>
								</xsl:with-param>
								<xsl:with-param name="air" select="versions/playerversion/@name = 'AIR'" />
							</xsl:call-template>
							<xsl:call-template name="getPageItemMenu">
								<xsl:with-param name="name">
									<xsl:if test="$classPath"><xsl:value-of select="@packageName" /></xsl:if>
									<xsl:if test="not($classPath)">Top Level</xsl:if>
								</xsl:with-param>
								<xsl:with-param name="class">menu package thintop</xsl:with-param>
								<xsl:with-param name="href">
									<xsl:if test="$classPath">
										<xsl:value-of select="concat($classPath,'/')" />
									</xsl:if>
									<xsl:text>package-detail.html</xsl:text>
								</xsl:with-param>
							</xsl:call-template>
							<xsl:call-template name="getTextBox">
								<xsl:with-param name="class">textbox thintop</xsl:with-param>
								<xsl:with-param name="content">
									<xsl:if test="deprecated">
										<xsl:apply-templates select="deprecated"/>
									</xsl:if>
									<xsl:if test="not(deprecated)">
										<xsl:if test="string-length(normalize-space(shortDescription/.)) &gt; 0">
											<xsl:value-of select="shortDescription" disable-output-escaping="yes"/>
										</xsl:if>
										<xsl:if test="not(string-length(normalize-space(shortDescription/.)) &gt; 0)">
											<xsl:value-of select="$nbsp" />
										</xsl:if>
									</xsl:if>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:for-each>
					</ul>
				</div>
				<xsl:call-template name="getFooter" />
			</body>
		</xsl:element>
		<xsl:copy-of select="$copyrightComment"/>
	</xsl:template>
</xsl:stylesheet>