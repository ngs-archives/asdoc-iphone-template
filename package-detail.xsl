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
	xmlns:str="http://exslt.org/strings" xmlns:redirect="http://xml.apache.org/xalan/redirect" extension-element-prefixes="redirect" exclude-result-prefixes="redirect str">

	<xsl:include href="asdoc-util.xsl"/>
	<xsl:param name="outputPath" select="'../out/'"/>
	<xsl:param name="overviewsFile" select="'../xml/overviews.xml'" />

	<xsl:template match="/">
		<xsl:for-each select="asdoc/packages/asPackage">
			<xsl:variable name="isTopLevel">
				<xsl:call-template name="isTopLevel">
					<xsl:with-param name="packageName" select="@name"/>
				</xsl:call-template>
			</xsl:variable>

			<xsl:variable name="packageFile">
				<xsl:value-of select="$outputPath"/>
				<xsl:choose>
					<xsl:when test="$isTopLevel='true'">package-detail.html</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="translate(@name,'.','/')"/>/package-detail.html</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:variable name="classListFile">
				<xsl:choose>
					<xsl:when test="$isTopLevel='true'">class-list.html</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="translate(@name,'.','/')"/>/class-list.html</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:variable name="packageName">
				<xsl:choose>
					<xsl:when test="$isTopLevel='true'">Top Level</xsl:when>
					<xsl:otherwise>
						<xsl:text>Package </xsl:text>
						<xsl:value-of select="@name"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:variable name="title">
				<xsl:if test="$isTopLevel='true'">
					<xsl:value-of select="concat('Top Level - ',$title-base)"/>
				</xsl:if>
				<xsl:if test="$isTopLevel != 'true'">
					<xsl:value-of select="concat(@name,' Package - ',$title-base)"/>
				</xsl:if>
			</xsl:variable>

			<xsl:variable name="baseRef">
				<xsl:call-template name="getBaseRef">
					<xsl:with-param name="packageName" select="@name"/>
				</xsl:call-template>
			</xsl:variable>

			<redirect:write select="$packageFile">
				<xsl:copy-of select="$noLiveDocs" />
				<xsl:copy-of select="$docType" />
				<xsl:element name="html">
					<head>
						<title>
							<xsl:value-of select="$title"/>
						</title>
						<xsl:call-template name="getStyleLink">
							<xsl:with-param name="link" select="asdoc/link"/>
							<xsl:with-param name="packageName" select="@name"/>
						</xsl:call-template>
					</head>
					<body id="asdoc-package-{translate(@name,'.','-')}" class="package-detail">
						<div id="iwebkit-topbar">
							<div id="iwebkit-leftnav">
								<a href="{$baseRef}index.html"><img src="{$baseRef}images/home.png" alt="home" /></a>
								<a href="{$baseRef}package-list.html">All Packages</a>
							</div>
						</div>
						<div id="iwebkit-content">
							<ul class="pageitem" id="package-main">
								<li class="textbox">
									<span class="header"><xsl:value-of select="$packageName" /></span>
									<xsl:apply-templates mode="annotate" select="$config/annotate/item[@type='package' and string-length(@name) and str:tokenize(@name,',')[starts-with(current()/@name,.)]]" />
									<xsl:if test="not($config/overviews/package)">
										<xsl:variable name="packageComments" select="document($overviewsFile)/overviews/packages/package[@name=current()/@name]"/>
										<xsl:if test="string-length($packageComments/longDescription/.)">
											<xsl:call-template name="deTilda">
												<xsl:with-param name="inText" select="$packageComments/longDescription"/>
											</xsl:call-template>
											<xsl:for-each select="$packageComments">
												<xsl:call-template name="sees" />
											</xsl:for-each>
										</xsl:if>
									</xsl:if>
									<xsl:if test="$config/overviews/package">
										<xsl:variable name="pname" select="@name" />
										<xsl:for-each select="$config/overviews/package">
											<xsl:variable name="packageOverview" select="document(.)/overviews/packages/package[@name=$pname]" />
											<xsl:if test="$packageOverview/longDescription">
												<p> blah
													<xsl:call-template name="deTilda">
														<xsl:with-param name="inText" select="$packageOverview/longDescription" />
													</xsl:call-template>
												</p>
											</xsl:if>
											<xsl:for-each select="$packageOverview">
												<xsl:call-template name="sees">
													<xsl:with-param name="xrefId">
														<xsl:if test="$isTopLevel='true'">
															<xsl:text>global</xsl:text>
														</xsl:if>
														<xsl:if test="not($isTopLevel='true')">
															<xsl:value-of select="$pname" />
														</xsl:if>
													</xsl:with-param>
												</xsl:call-template>
											</xsl:for-each>
										</xsl:for-each>
									</xsl:if>
								</li>
							</ul>
							<xsl:if test="fields/field[@isConst='false']">
								<a name="fieldSummary"></a>
								<span class="graytitle">
									<xsl:if test="$isTopLevel='true'">
										<xsl:text>Global </xsl:text>
									</xsl:if>
									<xsl:text>Properties</xsl:text>
								</span>
								<ul class="pageitem">
									<xsl:for-each select="fields/field[@isConst='false']">
										<xsl:sort select="@name" order="ascending"/>
										<xsl:call-template name="getPageItemMenu">
											<xsl:with-param name="name" select="@name" />
											<xsl:with-param name="href" select="concat('package.html#',@name)" />
										</xsl:call-template>
										<xsl:call-template name="getTextBox">
											<xsl:with-param name="class">textbox thintop</xsl:with-param>
											<xsl:with-param name="content">
												<xsl:call-template name="shortDescriptionReview" />
												<xsl:if test="string-length(normalize-space(shortDescription/.))">
													<xsl:value-of select="shortDescription" disable-output-escaping="yes"/>
												</xsl:if>
											</xsl:with-param>
										</xsl:call-template>
									</xsl:for-each>
								</ul>
							</xsl:if>
							<xsl:if test="methods/method">
								<a name="methodSummary"></a>
								<span class="graytitle">
									<xsl:if test="$isTopLevel='true'">
										<xsl:text>Global </xsl:text>
									</xsl:if>
									<xsl:text>Functions</xsl:text>
								</span>
								<ul class="pageitem">
									<xsl:for-each select="methods/method">
										<xsl:sort select="@name" order="ascending"/>
										<xsl:call-template name="getPageItemMenu">
											<xsl:with-param name="name" select="@name" />
											<xsl:with-param name="href" select="concat('package.html#',@name,'()')" />
										</xsl:call-template>
										<xsl:call-template name="getTextBox">
											<xsl:with-param name="class">textbox thintop</xsl:with-param>
											<xsl:with-param name="content">
												<xsl:call-template name="shortDescriptionReview" />
												<xsl:if test="string-length(normalize-space(shortDescription/.))">
													<xsl:value-of select="shortDescription" disable-output-escaping="yes"/>
												</xsl:if>
											</xsl:with-param>
										</xsl:call-template>
									</xsl:for-each>
								</ul>
							</xsl:if>
							<xsl:if test="fields/field[@isConst='true']">
								<a name="constantSummary"></a>
								<span class="graytitle">
									<xsl:if test="$isTopLevel='true'">
										<xsl:text>Global </xsl:text>
									</xsl:if>
									<xsl:text>Constants</xsl:text>
								</span>
								<ul class="pageitem">
									<xsl:for-each select="fields/field[@isConst='true']">
										<xsl:sort select="@name" order="ascending"/>
										
										<xsl:call-template name="getPageItemMenu">
											<xsl:with-param name="name" select="@name" />
											<xsl:with-param name="href" select="concat('package.html#',@name)" />
										</xsl:call-template>
										<xsl:call-template name="getTextBox">
											<xsl:with-param name="class">textbox thintop</xsl:with-param>
											<xsl:with-param name="content">
												<xsl:call-template name="shortDescriptionReview" />
												<xsl:if test="string-length(normalize-space(shortDescription/.))">
													<xsl:value-of select="shortDescription" disable-output-escaping="yes"/>
												</xsl:if>
											</xsl:with-param>
										</xsl:call-template>
									</xsl:for-each>
								</ul>
							</xsl:if>
							<xsl:if test="classes/asClass[@type='interface']">
								<a name="interfaceSummary"></a>
								<span class="graytitle">Interfaces</span>
								<ul class="pageitem">
									<xsl:for-each select="classes//asClass[@type='interface']">
										<xsl:sort select="@name" order="ascending"/>

										<xsl:call-template name="getPageItemMenu">
											<xsl:with-param name="name" select="@name" />
											<xsl:with-param name="href" select="concat(@name,'.html')" />
										</xsl:call-template>
										<xsl:call-template name="getTextBox">
											<xsl:with-param name="class">textbox thintop</xsl:with-param>
											<xsl:with-param name="content">
												<xsl:call-template name="shortDescriptionReview" />
												<xsl:if test="deprecated">
													<xsl:apply-templates select="deprecated"/>
												</xsl:if>
												<xsl:if test="not(deprecated)">
													<xsl:if test="string-length(normalize-space(shortDescription/.))">
														<xsl:value-of select="shortDescription" disable-output-escaping="yes"/>
													</xsl:if>
												</xsl:if>
											</xsl:with-param>
										</xsl:call-template>
									</xsl:for-each>
								</ul>
							</xsl:if>
							<xsl:if test="classes//asClass[@type!='interface']">
								<a name="classSummary"></a>
								<span class="graytitle">Classes</span>
								<ul class="pageitem">
									<xsl:for-each select="classes//asClass[@type!='interface']">
										<xsl:sort select="@name" order="ascending"/>
										<xsl:call-template name="getPageItemMenu">
											<xsl:with-param name="name" select="@name" />
											<xsl:with-param name="href" select="concat(@name,'.html')" />
										</xsl:call-template>
										<xsl:call-template name="getTextBox">
											<xsl:with-param name="class">textbox thintop</xsl:with-param>
											<xsl:with-param name="content">
												<xsl:call-template name="shortDescriptionReview" />
												<xsl:if test="deprecated">
													<xsl:apply-templates select="deprecated"/>
												</xsl:if>
												<xsl:if test="not(deprecated)">
													<xsl:if test="string-length(normalize-space(shortDescription/.))">
														<xsl:value-of select="shortDescription" disable-output-escaping="yes"/>
													</xsl:if>
												</xsl:if>
											</xsl:with-param>
										</xsl:call-template>
									</xsl:for-each>
								</ul>
							</xsl:if>
						</div>
						<xsl:call-template name="getFooter" />
						<xsl:copy-of select="$copyrightComment"/>
					</body>
				</xsl:element>
				<xsl:copy-of select="$copyrightComment"/>
			</redirect:write>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>