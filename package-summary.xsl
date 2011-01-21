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
	<xsl:variable name="title" select="concat('All Packages - ',$title-base)"/>
	<xsl:param name="overviewsFile" select="'../xml/overviews.xml'"/>
	<xsl:param name="filter" select="'*'" />
	<xsl:param name="outfile" select="'package-summary'" />
	<xsl:param name="overviewsFile" select="'../xml/overviews.xml'" />

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
			<body id="asdoc-package-summary">
				<div id="iwebkit-topbar">
					<div id="iwebkit-leftnav">
						<a href="index.html"><img src="images/home.png" alt="home" /></a>
					</div>
					<div id="iwebkit-rightbutton">
						<a href="package-list.html">List</a>
					</div>
					<div id="iwebkit-title">All Packages</div>
				</div>
				<div id="iwebkit-content">
					<xsl:variable name="overviews" select="document($overviewsFile)/overviews"/>
					<xsl:if test="string-length($overviews/all-packages/description/.)">
						<ul class="pageitem">
							<xsl:call-template name="getTextBox">
								<xsl:with-param name="content">
									<p>
										<xsl:value-of disable-output-escaping="yes" select="$overviews/all-packages/description/." />
									</p>
									<xsl:for-each select="$overviews/all-packages">
										<xsl:call-template name="sees">
											<xsl:with-param name="xrefId" select="'all-packages'" />
										</xsl:call-template>
									</xsl:for-each>
								</xsl:with-param>
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
							<xsl:variable name="packageFile">
								<xsl:if test="$isTopLevel='false'">
									<xsl:value-of select="translate(@name,'.','/')"/>
									<xsl:text>/</xsl:text>
								</xsl:if>
								<xsl:text>package-detail.html</xsl:text>
							</xsl:variable>
							<xsl:variable name="classListFile">
								<xsl:if test="$isTopLevel='false'">
									<xsl:value-of select="translate(@name,'.','/')"/>
									<xsl:text>/</xsl:text>
								</xsl:if>
								<xsl:text>class-list.html</xsl:text>
							</xsl:variable>

							<xsl:if test="classes/asClass or methods/method or fields/field">

								<xsl:call-template name="getPageItemMenu">
									<xsl:with-param name="class">menu package</xsl:with-param>
									<xsl:with-param name="name">
										<xsl:if test="$isTopLevel='true'">
											<xsl:text>Top Level</xsl:text>
										</xsl:if>
										<xsl:if test="$isTopLevel='false'">
											<xsl:value-of select="@name"/>
										</xsl:if>
									</xsl:with-param>
									<xsl:with-param name="href" select="$packageFile" />
								</xsl:call-template>

								<xsl:variable name="overview" select="normalize-space(document($overviewsFile)/overviews/packages/package[@name=current()/@name]/shortDescription/.)" />

								<xsl:if test="string-length($overview)">
									<xsl:call-template name="getTextBox">
										<xsl:with-param name="class">textbox thintop</xsl:with-param>
										<xsl:with-param name="content">
											<xsl:call-template name="deTilda">
												<xsl:with-param name="inText" select="$overview" />
											</xsl:call-template>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:if>

								<xsl:if test="$config/overviews/package">
									<xsl:variable name="pname" select="@name" />


									<xsl:call-template name="getTextBox">
										<xsl:with-param name="class">textbox thintop</xsl:with-param>
										<xsl:with-param name="content">

											<xsl:for-each select="$config/overviews/package">
												<xsl:variable name="packageOverview" select="normalize-space(document(.)/overviews/packages/package[@name=$pname]/shortDescription/.)" />									
												<xsl:if test="string-length($packageOverview)">
													<xsl:call-template name="deTilda">
														<xsl:with-param name="inText" select="$packageOverview" />
													</xsl:call-template>
												</xsl:if>
											</xsl:for-each>
										</xsl:with-param>
									</xsl:call-template>
									<xsl:value-of select="$nbsp" />
								</xsl:if>

							</xsl:if>
						</xsl:for-each>
					</ul>
				</div>
				<xsl:call-template name="getFooter" />
			</body>
		</xsl:element>
		<xsl:copy-of select="$copyrightComment"/>
	</xsl:template>
</xsl:stylesheet>