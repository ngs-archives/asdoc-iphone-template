<?xml version="1.0" encoding="utf-8"?>

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

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:redirect="http://xml.apache.org/xalan/redirect" 
xmlns:str="http://exslt.org/strings" 
xmlns:exslt="http://exslt.org/common" 
extension-element-prefixes="redirect" 
exclude-result-prefixes="redirect str exslt">

	<xsl:import href="asdoc-util.xsl" />
	<xsl:import href="class-parts.xsl" />

	<xsl:param name="outputPath" select="'../out'"/>
	<xsl:param name="showExamples">true</xsl:param>
	<xsl:param name="showIncludeExamples">true</xsl:param>
	<xsl:param name="showSWFs" select="'false'" />
	<xsl:param name="tabSpaces" select="'    '" />
	<xsl:variable name="tab">
		<xsl:text>	</xsl:text>
	</xsl:variable>

	<xsl:template match="/">
		<xsl:for-each select="//asClass">
			<xsl:sort select="@name" order="ascending" />
			<xsl:apply-templates select="." />
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="//asClass">
		<xsl:variable name="isTopLevel">
			<xsl:call-template name="isTopLevel">
				<xsl:with-param name="packageName" select="@packageName"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="isInnerClass" select="ancestor::asClass"/>
		<xsl:variable name="packagePath" select="translate(@packageName, '.', '/')"/>
		<xsl:variable name="classFile">
			<xsl:value-of select="$outputPath"/>
			<xsl:if test="$isTopLevel='false'">
				<xsl:value-of select="$packagePath"/>
				<xsl:text>/</xsl:text>
			</xsl:if>
			<xsl:value-of select="@name"/>
			<xsl:text>.html</xsl:text>
		</xsl:variable>
		<xsl:variable name="title" select="concat(concat(@name,' - '),$title-base)"/>
		<xsl:variable name="classDeprecated">
			<xsl:if test="deprecated">
				<xsl:value-of select="'true'"/>
			</xsl:if>
			<xsl:if test="not(deprecated)">
				<xsl:value-of select="'false'"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="baseRef">
			<xsl:call-template name="getBaseRef">
				<xsl:with-param name="packageName" select="@packageName" />
			</xsl:call-template>
		</xsl:variable>

		<redirect:write select="$classFile">
			<xsl:copy-of select="$docType"/>
			<xsl:element name="html">
				<head>
					<xsl:call-template name="getKeywords"/>
					<title>
						<xsl:if test="$isTopLevel='false'">
							<xsl:value-of select="@packageName" />
							<xsl:text>.</xsl:text>
						</xsl:if>
						<xsl:value-of select="@name" />
						<xsl:call-template name="getPageTitlePostFix" />
					</title>
					<xsl:call-template name="getStyleLink">
						<xsl:with-param name="link" select="/asdoc/link"/>
						<xsl:with-param name="packageName" select="@packageName"/>
					</xsl:call-template>
					<script type="text/javascript" src="{$baseRef}cookies.js">//</script>
				</head>
				<body id="asdoc-{concat(translate(@packageName,'.','-'),'-',@name)}">
					
					<div id="iwebkit-topbar">
						<div id="iwebkit-leftnav">
							<a href="{$baseRef}index.html"><img src="{$baseRef}images/home.png" alt="home" /></a>
							<xsl:call-template name="getInlineScript">
								<xsl:with-param name="script">
									<xsl:text>if(document.referrer&amp;&amp;document.location.toString().split('#')[1]!=document.referrer.split('#')[1]) </xsl:text>
									<xsl:text>document.write(</xsl:text>
									<xsl:text>'&lt;a href=&quot;'+document.referrer+'&quot;&gt;Back&lt;/a&gt;'</xsl:text>
									<xsl:text>);</xsl:text>
								</xsl:with-param>
							</xsl:call-template>
						</div>
					</div>
					<div id="iwebkit-content">
						<xsl:call-template name="classHeader">
							<xsl:with-param name="classDeprecated" select="$classDeprecated" />
						</xsl:call-template>

						<!--  PUBLIC PROPERTY SUMMARY  -->
						<xsl:call-template name="fieldSummary">
							<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
							<xsl:with-param name="baseRef" select="$baseRef" />
						</xsl:call-template>

						<!--  PROTECTED PROPERTY SUMMARY  -->
						<xsl:call-template name="fieldSummary">
							<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
							<xsl:with-param name="accessLevel" select="'protected'" />
							<xsl:with-param name="baseRef" select="$baseRef" />
						</xsl:call-template>

						<!--  METHOD SUMMARY -->
						<xsl:call-template name="methodSummary">
							<xsl:with-param name="className" select="@name" />
							<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
							<xsl:with-param name="baseRef" select="$baseRef" />
						</xsl:call-template>

						<!--  PROTECTED METHOD SUMMARY -->
						<xsl:call-template name="methodSummary">
							<xsl:with-param name="className" select="@name" />
							<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
							<xsl:with-param name="baseRef" select="$baseRef" />
							<xsl:with-param name="accessLevel" select="'protected'" />
						</xsl:call-template>

						<!--  EVENT SUMMARY  -->
						<xsl:call-template name="eventsGeneratedSummary">
							<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
							<xsl:with-param name="baseRef" select="$baseRef" />
						</xsl:call-template>

						<!-- STYLE SUMMARY -->
						<xsl:call-template name="stylesSummary">
							<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
							<xsl:with-param name="baseRef" select="$baseRef" />
						</xsl:call-template>

						<!-- EFFECT SUMMARY -->
						<xsl:call-template name="effectsSummary">
							<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
							<xsl:with-param name="baseRef" select="$baseRef" />
						</xsl:call-template>

						<!--  PUBLIC CONSTANT SUMMARY  -->
						<xsl:call-template name="fieldSummary">
							<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
							<xsl:with-param name="isConst" select="'true'" />
							<xsl:with-param name="baseRef" select="$baseRef" />
						</xsl:call-template>

						<!--  PROTECTED CONSTANT SUMMARY  -->
						<xsl:call-template name="fieldSummary">
							<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
							<xsl:with-param name="isConst" select="'true'" />
							<xsl:with-param name="accessLevel" select="'protected'" />
							<xsl:with-param name="baseRef" select="$baseRef" />
						</xsl:call-template>

						<xsl:call-template name="getInlineScript">
							<xsl:with-param name="script">showHideInherited();</xsl:with-param>
						</xsl:call-template>

						<!--  PROPERTY DETAIL -->
						<xsl:apply-templates select="fields" mode="detail">
							<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
							<xsl:with-param name="baseRef" select="$baseRef" />
						</xsl:apply-templates>

						<!-- CONSTRUCTOR DETAIL -->
						<xsl:if test="@type != 'interface' and count(constructors/constructor) &gt; 0">
							<span class="graytitle" id="constructorDetail">
								<xsl:text>Constructor detail</xsl:text>
							</span>
							<ul class="pageitem">
								<xsl:variable name="className" select="@name"/>
								<xsl:apply-templates select="constructors/constructor[@name = $className]" mode="detail">
									<xsl:with-param name="isConstructor">true</xsl:with-param>
									<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
									<xsl:with-param name="baseRef" select="$baseRef" />
								</xsl:apply-templates>
							</ul>
						</xsl:if>

						<!-- METHOD DETAIL -->
						<xsl:apply-templates select="methods" mode="detail">
							<xsl:with-param name="className" select="@name"/>
							<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
							<xsl:with-param name="baseRef" select="$baseRef" />
						</xsl:apply-templates>		

						<!--  EVENT DETAIL  -->
						<xsl:apply-templates select="eventsGenerated" mode="detail">
							<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
						</xsl:apply-templates>

						<!--  CONSTANT DETAIL -->
						<xsl:apply-templates select="fields" mode="detail">
							<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
							<xsl:with-param name="isConst" select="'true'" />
							<xsl:with-param name="baseRef" select="$baseRef" />
						</xsl:apply-templates>
						
						<!-- INCLUDE EXAMPLES -->
 						<xsl:if test="includeExamples/includeExample/codepart">
							<xsl:call-template name="includeExamples"/>
						</xsl:if>
					</div>
					<xsl:call-template name="getFooter" />
				</body>
			</xsl:element>
			<xsl:copy-of select="$copyrightComment"/>
		</redirect:write>
	</xsl:template>

</xsl:stylesheet>
