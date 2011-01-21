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
	<xsl:variable name="title" select="concat('Package List - ',$title-base)"/>

	<xsl:template match="/">
		<xsl:copy-of select="$noLiveDocs" />
		<xsl:copy-of select="$docType" />
		<xsl:element name="html">
			<head>
				<title><xsl:value-of select="$title"/></title>
				<xsl:call-template name="getStyleLink">
					<xsl:with-param name="link" select="asdoc/link"/>
				</xsl:call-template>
			</head>
			<body id="asdoc-package-list">
				<div id="iwebkit-topbar">
					<div id="iwebkit-leftnav">
						<a href="index.html"><img src="images/home.png" alt="home" /></a>
					</div>
					<div id="iwebkit-rightbutton">
						<a href="package-summary.html">Summary</a>
					</div>
					<div id="iwebkit-title">All Packages</div>
				</div>
				<div id="iwebkit-content">
					<xsl:if test="asdoc/packages/asPackage[contains(@name,'$$')]/classes/asClass">
						<ul class="pageitem classlist">
							<xsl:call-template name="getPageItemMenu">
								<xsl:with-param name="name">Top Level</xsl:with-param>
								<xsl:with-param name="class">menu toplevel</xsl:with-param>
								<xsl:with-param name="href">package-detail.html</xsl:with-param>
							</xsl:call-template>
						</ul>
					</xsl:if>
					<ul class="pageitem classlist">
						<xsl:for-each select="asdoc/packages/asPackage[classes/asClass or methods/method or fields/field]">
							<xsl:sort select="@name"/>
							<xsl:variable name="isTopLevel">
								<xsl:call-template name="isTopLevel">
									<xsl:with-param name="packageName" select="@name"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="packagePath" select="translate(@name,'.','/')"/>
							<xsl:if test="$isTopLevel='false'">
								<xsl:call-template name="getPageItemMenu">
								<xsl:with-param name="class">menu package</xsl:with-param>
									<xsl:with-param name="name" select="@name" />
									<xsl:with-param name="href" select="concat($packagePath,'/package-detail.html')" />
								</xsl:call-template>
							</xsl:if>
						</xsl:for-each>
					</ul>
					<xsl:if test="$config/languageElements[@show='true']">
						<span class="graytitle"><a href="language-elements.html">Language Elements</a></span>
						<ul class="pageitem">
							<xsl:if test="$config/languageElements[@directives='true']">
								<xsl:call-template name="getPageItemMenu">
									<xsl:with-param name="name">Compiler Directives</xsl:with-param>
									<xsl:with-param name="href">directives.html</xsl:with-param>
								</xsl:call-template>
							</xsl:if>
							<xsl:if test="$config/languageElements[@constants='true']">
								<xsl:if test="$config/options[@docversion='3']">
									<xsl:call-template name="getPageItemMenu">
										<xsl:with-param name="name">Global Constants</xsl:with-param>
										<xsl:with-param name="href">package.html#constantSummary</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
								<xsl:if test="not($config/options[@docversion='3'])">
									<xsl:call-template name="getPageItemMenu">
										<xsl:with-param name="name">Global Constants</xsl:with-param>
										<xsl:with-param name="href">constants.html</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
							</xsl:if>
							<xsl:if test="$config/languageElements[@functions='true']">
								<xsl:if test="$config/options[@docversion='3']">
									<xsl:call-template name="getPageItemMenu">
										<xsl:with-param name="name">Global Functions</xsl:with-param>
										<xsl:with-param name="href">package.html#methodSummary</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
								<xsl:if test="not($config/options[@docversion='3'])">
									<xsl:call-template name="getPageItemMenu">
										<xsl:with-param name="name">Global Functions</xsl:with-param>
										<xsl:with-param name="href">global_functions.html</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
							</xsl:if>
							<xsl:if test="$config/languageElements[@properties='true']">
								<xsl:call-template name="getPageItemMenu">
									<xsl:with-param name="name">Global Properties</xsl:with-param>
									<xsl:with-param name="href">global_props.html</xsl:with-param>
								</xsl:call-template>
							</xsl:if>
							<xsl:if test="$config/languageElements[@operators='true']">
								<xsl:call-template name="getPageItemMenu">
									<xsl:with-param name="name">Operators</xsl:with-param>
									<xsl:with-param name="href">operators.html</xsl:with-param>
								</xsl:call-template>
							</xsl:if>
							<xsl:if test="$config/languageElements[@statements='true']">
								<xsl:call-template name="getPageItemMenu">
									<xsl:with-param name="name">Statements</xsl:with-param>
									<xsl:with-param name="href">statements.html</xsl:with-param>
								</xsl:call-template>
							</xsl:if>
							<xsl:if test="$config/languageElements[@specialTypes='true']">
								<xsl:call-template name="getPageItemMenu">
									<xsl:with-param name="name">Special Types</xsl:with-param>
									<xsl:with-param name="href">specialTypes.html</xsl:with-param>
								</xsl:call-template>
							</xsl:if>
							<xsl:for-each select="$config/languageElements/element">
								<xsl:call-template name="getPageItemMenu">
									<xsl:with-param name="name" select="@label" />
									<xsl:with-param name="href" select="@href" />
								</xsl:call-template>
							</xsl:for-each>
						</ul>
					</xsl:if>
					<xsl:if test="$config/appendixes[@show='true']">
						<span class="graytitle"><a href="appendixes.html">Appendixes</a></span>
						<ul class="pageitem">
							<xsl:if test="$config/appendixes[@deprecated='true']">
								<xsl:call-template name="getPageItemMenu">
									<xsl:with-param name="name">Deprecated</xsl:with-param>
									<xsl:with-param name="href">deprecated.html</xsl:with-param>
								</xsl:call-template>
							</xsl:if>
							<xsl:for-each select="$config/appendixes/appendix">
								<xsl:call-template name="getPageItemMenu">
									<xsl:with-param name="name" select="@label" />
									<xsl:with-param name="href" select="@href" />
								</xsl:call-template>
							</xsl:for-each>
						</ul>
					</xsl:if>
				</div>
				<xsl:call-template name="getFooter" />
			</body>
		</xsl:element>
		<xsl:copy-of select="$copyrightComment"/>
	</xsl:template>
</xsl:stylesheet>