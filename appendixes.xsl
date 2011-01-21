<?xml version='1.0'?>

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

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dyn="http://exslt.org/dynamic">

	<xsl:import href="asdoc-util.xsl" />
	<xsl:param name="title" select="concat('Appendixes - ',$title-base)"/>
	<xsl:param name="overviewsFile" select="'../xml/overviews.xml'"/>

	<xsl:variable name="overviews" select="document($overviewsFile)/overviews" />

	<xsl:template match="/">
		<xsl:copy-of select="$docType" />
		<xsl:element name="html">
			<head>
				<xsl:call-template name="getStyleLink">
					<xsl:with-param name="link" select="/asdoc/link"/>
				</xsl:call-template>
				<title>
					<xsl:text>Appendixes</xsl:text>
					<xsl:call-template name="getPageTitlePostFix" />
				</title>
			</head>
			<body id="asdoc-appendixes">
				<div id="iwebkit-topbar">
					<div id="iwebkit-title">Appendixes</div>
					<div id="iwebkit-leftnav">
						<a href="index.html"><img src="images/home.png" alt="home" /></a>
					</div>
				</div>
				<div id="content">
					<xsl:if test="string-length($overviews/appendixes/description/.)">
						<ul class="pageitem">
							<xsl:call-template name="getTextBox">
								<xsl:with-param name="content">
									<p>
										<xsl:value-of disable-output-escaping="yes" select="$overviews/appendixes/description/." />
									</p>
									<xsl:for-each select="$overviews/appendixes">
										<xsl:call-template name="sees">
											<xsl:with-param name="xrefId" select="'appendixes'" />
										</xsl:call-template>
									</xsl:for-each>
								</xsl:with-param>
							</xsl:call-template>
						</ul>
					</xsl:if>
					<ul class="pageitem">
						<xsl:if test="$config/appendixes[@deprecated='true']">
							<xsl:call-template name="getPageItemMenu">
								<xsl:with-param name="name" select="'Deprecated'" />
								<xsl:with-param name="href" select="'deprecated.html'" />
							</xsl:call-template>
							<xsl:call-template name="getTextBox">
								<xsl:with-param name="class" select="'textbox thintop'" />
								<xsl:with-param name="content">
									<xsl:value-of select="$overviews/deprecated/shortDescription/." />
								</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
						<xsl:for-each select="$config/appendixes/appendix">
							<xsl:call-template name="getPageItemMenu">
								<xsl:with-param name="name" select="@label" />
								<xsl:with-param name="href" select="@href" />
							</xsl:call-template>
							<xsl:call-template name="getTextBox">
								<xsl:with-param name="class" select="'textbox thintop'" />
								<xsl:with-param name="content">
									<xsl:variable name="overview" select="dyn:evaluate(concat('$overviews/',@overview,'/shortDescription/.'))" />
									<xsl:if test="string-length(normalize-space($overview))">
										<xsl:value-of select="$overview" />
									</xsl:if>
									<xsl:if test="not(string-length(normalize-space($overview)))">
										<xsl:value-of select="$nbsp" />
									</xsl:if>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:for-each>
					</ul>
					<xsl:call-template name="getFooter" />
				</div>
			</body>
		</xsl:element>
		<xsl:copy-of select="$copyrightComment"/>
	</xsl:template>

</xsl:stylesheet>