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
	<xsl:variable name="title" select="concat('All Classes - ',$title-base)"/>

	<xsl:template match="/">
		<xsl:copy-of select="$noLiveDocs" />
		<xsl:copy-of select="$docType" />
		<xsl:element name="html">
			<head>
				<title>
					<xsl:value-of select="$title"/>
				</title>
				<xsl:call-template name="getStyleLink">
					<xsl:with-param name="link" select="asdoc/link"/>
				</xsl:call-template>
			</head>
			<body id="asdoc-all-classes">
				<div id="iwebkit-topbar">
					<div id="iwebkit-leftnav">
						<a href="index.html"><img src="images/home.png" alt="home" /></a>
					</div>
					<div id="iwebkit-rightbutton">
						<a href="class-summary.html">Summary</a>
					</div>
					<div id="iwebkit-title">All Classes</div>
				</div>
				<div id="iwebkit-content">
					<ul class="pageitem classlist">
						<xsl:for-each select="//asClass">
							<xsl:sort select="@name" order="ascending"/>
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
						</xsl:for-each>
					</ul>
				</div>
				<xsl:call-template name="getFooter" />
			</body>
		</xsl:element>
		<xsl:copy-of select="$copyrightComment"/>
	</xsl:template>
</xsl:stylesheet>