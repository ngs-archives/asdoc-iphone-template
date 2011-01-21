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

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:exslt="http://exslt.org/common" 
	xmlns:str="http://exslt.org/strings"
	xmlns:redirect="http://xml.apache.org/xalan/redirect" extension-element-prefixes="redirect"  exclude-result-prefixes="exslt str redirect">

	<xsl:include href="asdoc-util.xsl"/>
	<xsl:param name="basedir" select="'../xml/'"/>
	<xsl:param name="directivesFile" select="'directives.xml'"/>
	<xsl:param name="globalFuncFile" select="'global_functions.xml'"/>
	<xsl:param name="globalPropsFile" select="'global_props.xml'"/>
	<xsl:param name="constantsFile" select="'constants.xml'"/>
	<xsl:param name="operatorsFile" select="'operators.xml'"/>
	<xsl:param name="statementsFile" select="'statements.xml'"/>
	<xsl:param name="specialTypesFile" select="'specialTypes.xml'" />
	<xsl:param name="unsupportedFile" select="'unsupported.xml'" />
	<xsl:param name="fscommandFile" select="'fscommand.xml'" />
	<xsl:param name="splitIndex" select="$config/options[@splitIndex='true']" />
	<xsl:param name="outputPath" select="'../out/'"/>
	<xsl:param name="symbolsName" select="'Symbols'" />
	<xsl:param name="overviewsFile" select="'../xml/overviews.xml'" />

	<xsl:variable name="directives">
		<xsl:if test="$config/languageElements[@show='true' and @directives='true']">
			<xsl:copy-of select="document(concat($basedir,$directivesFile))/asdoc"/>
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="globalFuncs">
		<xsl:if test="$config/languageElements[@show='true' and @functions='true'] and $config/options[@docversion!='3']">
			<xsl:copy-of select="document(concat($basedir,$globalFuncFile))/asdoc"/>
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="globalProps">
		<xsl:if test="$config/languageElements[@show='true' and @properties='true']">
			<xsl:copy-of select="document(concat($basedir,$globalPropsFile))/asdoc"/>
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="constants">
		<xsl:if test="$config/languageElements[@show='true' and @constants='true'] and $config/options[@docversion!='3']">
			<xsl:copy-of select="document(concat($basedir,$constantsFile))/asdoc"/>
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="operators">
		<xsl:if test="$config/languageElements[@show='true' and @operators='true']">
			<xsl:copy-of select="document(concat($basedir,$operatorsFile))/asdoc"/>
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="statements">
		<xsl:if test="$config/languageElements[@show='true' and @statements='true']">
			<xsl:copy-of select="document(concat($basedir,$statementsFile))/asdoc"/>
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="specialTypes">
		<xsl:if test="$config/languageElements[@show='true' and @specialTypes='true']">
			<xsl:copy-of select="document(concat($basedir,$specialTypesFile))/asdoc"/>
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="unsupported">
		<xsl:if test="$config/index[@showUnsupported='true']">
			<xsl:copy-of select="document(concat($basedir,$unsupportedFile))/asdoc" />
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="fscommand">
		<xsl:if test="$config/index[@showFscommand='true']">
			<xsl:copy-of select="document(concat($basedir,$fscommandFile))/asdoc" />
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="matches" select="//*[((self::method or self::field or self::constructor or self::style or self::effect) and not(ancestor::asAncestor)) or self::asPackage or self::asClass or (self::event and (not(parent::method) and not(parent::constructor) and not(parent::eventsDefined) and not(ancestor::asAncestor)))] | exslt:nodeSet($directives)/asdoc/object/methods/method | exslt:nodeSet($globalFuncs)/asdoc/object/methods/method | exslt:nodeSet($globalProps)/asdoc/object/fields/field | exslt:nodeSet($constants)/asdoc/object/fields/field | exslt:nodeSet($operators)/asdoc/operators/operator | exslt:nodeSet($statements)/asdoc/statements/statement | exslt:nodeSet($specialTypes)/asdoc/specialTypes/specialType | exslt:nodeSet($unsupported)/asdoc/unsupported//*[@name] | exslt:nodeSet($fscommand)/asdoc/fscommand | $config/index/entry"/>
						
	<xsl:variable name="symbols">
		<xsl:text disable-output-escaping="yes">+,:!?/.^~*=%|&amp;&lt;>()[]{}"</xsl:text>
	</xsl:variable>
	<xsl:variable name="letters">
		<xsl:if test="$config/languageElements[@show='true' and (@operators='true' or @specialTypes='true')]">
			<xsl:value-of select="$symbolsName" />
			<xsl:text> </xsl:text>
		</xsl:if>
		<xsl:text>A B C D E F G H I J K L M N O P Q R S T U V W X Y Z</xsl:text>
	</xsl:variable>
	<xsl:variable name="letterSet" select="str:tokenize($letters)" />

	<xsl:template match="/">
		<xsl:if test="$splitIndex='false'">
			<xsl:apply-templates select="asdoc" />
		</xsl:if>
		<xsl:if test="$splitIndex!='false'">
			<xsl:variable name="context" select="/" />
			<xsl:for-each select="$letterSet">
				<xsl:variable name="fileName" select="concat('index/',.)" />
				<redirect:write select="concat($outputPath,$fileName,'.html')">
					<xsl:apply-templates select="$context/asdoc">
 						<xsl:with-param name="displayLetters" select="str:tokenize(.)" />
						<xsl:with-param name="fileName" select="$fileName" />
						<xsl:with-param name="letter" select="." />
					</xsl:apply-templates>
				</redirect:write>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

	<xsl:template match="asdoc">
		<xsl:param name="displayLetters" select="$letterSet" />
		<xsl:param name="fileName" select="'all-index'" />
		<xsl:param name="letter" />
		
		<xsl:variable name="title">
			<xsl:if test="$splitIndex and $letter">
				<xsl:value-of select="$letter" />
			</xsl:if>
			<xsl:if test="not($splitIndex)">
				<xsl:text>All</xsl:text>
			</xsl:if>
			<xsl:text> Index</xsl:text>
			<xsl:call-template name="getPageTitlePostFix" />
		</xsl:variable>

		<xsl:copy-of select="$noLiveDocs" />
		<xsl:copy-of select="$docType" />
		<xsl:element name="html">
			<head>
				<title><xsl:value-of select="$title" /></title>
				<xsl:call-template name="getStyleLink">
					<xsl:with-param name="link" select="asdoc/link"/>
					<xsl:with-param name="baseRef" select="'../'"/>
				</xsl:call-template>
			</head>
			<body id="asdoc-all-index">
				<div id="iwebkit-topbar">
					<div id="iwebkit-leftnav">
						<a href="../index.html"><img src="../images/home.png" alt="home" /></a>
					</div>
					<div id="iwebkit-title"><xsl:value-of select="$title" /></div>
				</div>
				<div id="iwebkit-content">
					<ul class="pageitem" id="package-main">
						<xsl:for-each select="$displayLetters">
							<xsl:variable name="firstUpper" select="."/>
							<xsl:variable name="firstLower" select="translate($firstUpper,$upperCase,$lowerCase)"/>
							<xsl:variable name="checkingSymbol" select=".=$symbolsName and $config/languageElements[@show='true' and (@operators='true' or @specialTypes='true')]"/>

							<xsl:for-each select="$matches">
								<xsl:sort select="concat(translate(self::asPackage[@name='$$Global$$']/@name,'Global$','Top Le'),translate(@symbol,$symbols,''),translate(@name,'#_.( ',''))" data-type="text" />
								<xsl:sort select="../../@packageName"/>
								<xsl:sort select="../../@name"/>

								<xsl:variable name="isSymbol" select="string-length(@symbol) > 0 and not(contains($letters,translate(substring(@symbol,1,1),$lowerCase,$upperCase)))"/>
								<xsl:variable name="isSpecialSymbol" select="self::specialType and not(contains($letters,translate(substring(@name,1,1),$lowerCase,$upperCase)))" />
								<xsl:variable name="isRestParam" select="starts-with(@name,'...')" />
								<xsl:variable name="sortableName">
									<xsl:choose>
										<!-- special case for -Infinity -->
										<xsl:when test="@name='-Infinity'">
											<xsl:value-of select="substring(@name,2)"/>
										</xsl:when>
										<xsl:when test="@name='$$Global$$'">
											<xsl:value-of select="'Top Level'" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:if test="$isSymbol">
												<xsl:value-of select="@symbol"/>
											</xsl:if>
											<xsl:if test="not($isSymbol)">
												<xsl:if test="string-length(@symbol) > 0">
													<xsl:value-of select="@symbol"/>
												</xsl:if>
												<xsl:if test="not(string-length(@symbol) > 0)">
													<xsl:value-of select="translate(@name,'#_.( ','')"/>
												</xsl:if>
											</xsl:if>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>

								<xsl:variable name="symbolMatch" select="$checkingSymbol and ($isSymbol or $isSpecialSymbol or $isRestParam)"/>
								<xsl:if test="$symbolMatch or starts-with($sortableName,$firstLower) or starts-with($sortableName,$firstUpper)">
									<xsl:choose>
										<xsl:when test="ancestor::unsupported">
											<xsl:call-template name="getPageItemMenu">
												<xsl:with-param name="href" select="'unsupported.html'" />
												<xsl:with-param name="name">
													<xsl:value-of select="@name" />
													<xsl:if test="self::method">
														<xsl:text>()</xsl:text>
													</xsl:if>
												</xsl:with-param>
											</xsl:call-template>

											<xsl:call-template name="getTextBox">
												<xsl:with-param name="content" select="'Unsupported '" />
												<xsl:with-param name="class" select="'textbox thintop'" />
											</xsl:call-template>
											
											<xsl:choose>
												<xsl:when test="self::globalFunction">
													<xsl:call-template name="getPageItemMenu">
														<xsl:with-param name="href" select="'global_functions.html'" />
														<xsl:with-param name="name" select="../@label" />
													</xsl:call-template>
												</xsl:when>
												<xsl:when test="self::fscommand">
													<xsl:call-template name="getPageItemMenu">
														<xsl:with-param name="href" select="'global_functions.html#fscommand()'" />
														<xsl:with-param name="name" select="../@label" />
													</xsl:call-template>
												</xsl:when>
												<xsl:otherwise>
													<xsl:call-template name="getTextBox">
														<xsl:with-param name="content">
															<xsl:if test="self::eventHandler and not(string-length(@class))">
																<xsl:text> global </xsl:text>
															</xsl:if>
															<xsl:value-of select="parent::node()/@label" />
														</xsl:with-param>
													</xsl:call-template>
												</xsl:otherwise>
											</xsl:choose>
											<xsl:if test="string-length(@package)">
												<xsl:call-template name="getTextBox">
													<xsl:with-param name="class" select="'textbox thintop'" />
													<xsl:with-param name="content">
														<xsl:text> in </xsl:text>
														<xsl:if test="string-length(@class)">
															<xsl:text>class </xsl:text>
															<a href="">
																<xsl:value-of select="@package" />
															</a>
														</xsl:if>
														<xsl:if test="not(string-length(@class))">
															<xsl:text>package </xsl:text>
															<a href="{concat(translate(@package,'.','/'),'/package-detail.html')}">
																<xsl:value-of select="@package" />
															</a>
														</xsl:if>
													</xsl:with-param>
												</xsl:call-template>
											</xsl:if>
											<xsl:if test="not(string-length(@package))">
												<xsl:call-template name="getTextBox">
													<xsl:with-param name="class" select="'textbox thintop'" />
													<xsl:with-param name="content">
														<xsl:choose>
															<xsl:when test="self::class">
																<xsl:text> in </xsl:text>
																<a href="../package-detail.html">Top Level</a>
															</xsl:when>
															<xsl:otherwise>
																<xsl:if test="string-length(@class)">
																	<xsl:text> in class </xsl:text>
																	<a href="../{@class}.html">
																		<xsl:value-of select="@class" />
																	</a>
																</xsl:if>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:with-param>
												</xsl:call-template>
											</xsl:if>
										</xsl:when>
										<xsl:when test="self::fscommand">
											<xsl:call-template name="getPageItemMenu">
												<xsl:with-param name="href" select="concat('fscommand/',@name,'.html')" />
												<xsl:with-param name="name" select="@name" />
											</xsl:call-template>
											<xsl:call-template name="getTextBox">
												<xsl:with-param name="class" select="'textbox thintop'" />
												<xsl:with-param name="content">
													<xsl:text>Command for </xsl:text>
													<a href="global_functions.html#fscommand2()">
														<xsl:text>fscommand2</xsl:text>
													</a>
													<xsl:text> global function</xsl:text>
												</xsl:with-param>
											</xsl:call-template>
										</xsl:when>
										<xsl:when test="(self::method and (not(@type) or (@type!='handler'))) or self::constructor">
											<xsl:variable name="isTopLevel">
												<xsl:call-template name="isTopLevel">
													<xsl:with-param name="packageName">
														<xsl:if test="ancestor::asClass">
															<xsl:value-of select="../../@packageName"/>
														</xsl:if>
														<xsl:if test="not(ancestor::asClass)">
															<xsl:value-of select="../../@name"/>
														</xsl:if>
													</xsl:with-param>
												</xsl:call-template>
											</xsl:variable>
											<xsl:variable name="classPath">
												<!-- AS2 lang elements -->
												<xsl:text>../</xsl:text>
												<xsl:if test="$isTopLevel='false'">
													<xsl:if test="ancestor::asClass">
														<xsl:value-of select="translate(../../@packageName,'.','/')"/>
													</xsl:if>
													<xsl:if test="not(ancestor::asClass)">
														<xsl:value-of select="translate(../../@name,'.','/')"/>
													</xsl:if>
												</xsl:if>
											</xsl:variable>
											<xsl:choose>
												<!-- AS2 lang elements -->
												<xsl:when test="../../@type='list'">
													<xsl:call-template name="getPageItemMenu">
														<xsl:with-param name="href" select="concat('../',../../@href,'#',@name,'()')" />
														<xsl:with-param name="name" select="@name" />
													</xsl:call-template>
												</xsl:when>
												<xsl:when test="ancestor::asClass">
													<xsl:call-template name="getPageItemMenu">
														<xsl:with-param name="href" select="concat($classPath,'/',../../@name,'.html#',@name,'()')" />
														<xsl:with-param name="name" select="@name" />
													</xsl:call-template>
												</xsl:when>
												<xsl:otherwise>
													<xsl:call-template name="getPageItemMenu">
														<xsl:with-param name="href" select="concat($classPath,'/package.html#',@name, '()')" />
														<xsl:with-param name="name" select="@name" />
													</xsl:call-template>
												</xsl:otherwise>
											</xsl:choose>
											<xsl:call-template name="getTextBox">
												<xsl:with-param name="class" select="'textbox thintop'" />
												<xsl:with-param name="content">
													<xsl:if test="not(@type) or @type!='directive'">
														<xsl:variable name="params">
															<xsl:call-template name="getParamList">
																<xsl:with-param name="params" select="params"/>
															</xsl:call-template>
														</xsl:variable>
														<p>
															<code>
																<xsl:value-of select="@name" />
																<xsl:text>(</xsl:text>
																<xsl:copy-of select="$params"/>
																<xsl:text>)</xsl:text>
															</code>
														</p>
													</xsl:if>
													<p>
														<xsl:if test="self::method">
															<xsl:call-template name="getMethodDesc">
																<xsl:with-param name="classPath" select="$classPath"/>
															</xsl:call-template>
														</xsl:if>
														<xsl:if test="self::constructor">
															<xsl:call-template name="getConstructorDesc">
																<xsl:with-param name="classPath" select="$classPath"/>
															</xsl:call-template>
														</xsl:if>
													</p>
												</xsl:with-param>
											</xsl:call-template>
										</xsl:when>
										<xsl:when test="self::field">
											<xsl:variable name="isTopLevel">
												<xsl:call-template name="isTopLevel">
													<xsl:with-param name="packageName">
														<xsl:if test="ancestor::asClass">
															<xsl:value-of select="../../@packageName"/>
														</xsl:if>
														<xsl:if test="not(ancestor::asClass)">
															<xsl:value-of select="../../@name"/>
														</xsl:if>
													</xsl:with-param>
												</xsl:call-template>
											</xsl:variable>
											<xsl:variable name="classPath">
												<!-- AS2 lang elements -->
												<xsl:text>../</xsl:text>
												<xsl:if test="$isTopLevel='false'">
													<xsl:if test="ancestor::asClass">
														<xsl:value-of select="translate(../../@packageName,'.','/')"/>
													</xsl:if>
													<xsl:if test="not(ancestor::asClass)">
														<xsl:value-of select="translate(../../@name,'.','/')"/>
													</xsl:if>
												</xsl:if>
											</xsl:variable>
											<xsl:call-template name="getPageItemMenu">
												<xsl:with-param name="href">
													<xsl:choose>
														<xsl:when test="../../@type='list'">
															<xsl:value-of select="concat('../',../../@href,'#',@name)" />
														</xsl:when>
														<xsl:when test="ancestor::asClass">
															<xsl:value-of select="concat($classPath,'/',../../@name,'.html#',@name)" />
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="concat($classPath,'/','package.html#',@name)" />
														</xsl:otherwise>
													</xsl:choose>
												</xsl:with-param>
												<xsl:with-param name="name" select="@name" />
											</xsl:call-template>
											<xsl:call-template name="getTextBox">
												<xsl:with-param name="class" select="'textbox thintop'" />
												<xsl:with-param name="content">
													<xsl:call-template name="getPropertyDesc">
														<xsl:with-param name="classPath" select="$classPath"/>
													</xsl:call-template>
												</xsl:with-param>
											</xsl:call-template>
										</xsl:when>
										<xsl:when test="self::style or self::effect">
											<xsl:variable name="isTopLevel">
												<xsl:call-template name="isTopLevel">
													<xsl:with-param name="packageName">
														<xsl:if test="ancestor::asClass">
															<xsl:value-of select="../../@packageName"/>
														</xsl:if>
														<xsl:if test="not(ancestor::asClass)">
															<xsl:value-of select="../../@name"/>
														</xsl:if>
													</xsl:with-param>
												</xsl:call-template>
											</xsl:variable>
											<xsl:variable name="classPath">
												<!-- AS2 lang elements -->
												<xsl:text>../</xsl:text>
												<xsl:if test="$isTopLevel='false'">
													<xsl:if test="ancestor::asClass">
														<xsl:value-of select="translate(../../@packageName,'.','/')"/>
													</xsl:if>
													<xsl:if test="not(ancestor::asClass)">
														<xsl:value-of select="translate(../../@name,'.','/')"/>
													</xsl:if>
												</xsl:if>
											</xsl:variable>
											<xsl:variable name="aname">
												<xsl:if test="self::style">style</xsl:if>
												<xsl:if test="self::effect">effect</xsl:if>
											</xsl:variable>
											<xsl:variable name="cname">
												<xsl:if test="self::style">Style</xsl:if>
												<xsl:if test="self::effect">Effect</xsl:if>
											</xsl:variable>
											<xsl:call-template name="getPageItemMenu">
												<xsl:with-param name="href" select="concat($classPath,'/',../../@name,'.html#',$aname,':',@name)" />
												<xsl:with-param name="name" select="@name" />
											</xsl:call-template>
											<xsl:call-template name="getTextBox">
												<xsl:with-param name="class" select="'textbox thintop'" />
												<xsl:with-param name="content">
													<xsl:value-of select="$cname" />
													<xsl:text> in class </xsl:text>
													<xsl:call-template name="getClassRef">
														<xsl:with-param name="classPath" select="$classPath"/>
													</xsl:call-template>
												</xsl:with-param>
											</xsl:call-template>
										</xsl:when>
										<xsl:when test="self::asPackage">
											<xsl:variable name="isTopLevel">
												<xsl:call-template name="isTopLevel">
													<xsl:with-param name="packageName" select="@name" />
												</xsl:call-template>
											</xsl:variable>
											<xsl:variable name="packagePath">
												<xsl:text>../</xsl:text>
												<xsl:if test="$isTopLevel='false'">
													<xsl:value-of select="translate(@name,'.','/')" />
												</xsl:if>
											</xsl:variable>
											<xsl:call-template name="getPageItemMenu">
												<xsl:with-param name="href" select="concat($packagePath,'/package-detail.html')" />
												<xsl:with-param name="name">
													<xsl:if test="$isTopLevel='true'">
														<xsl:text>Top Level</xsl:text>
													</xsl:if>
													<xsl:if test="$isTopLevel='false'">
														<xsl:value-of select="@name" />
													</xsl:if>
												</xsl:with-param>
											</xsl:call-template>
											<xsl:call-template name="getTextBox">
												<xsl:with-param name="class" select="'textbox thintop'" />
												<xsl:with-param name="content">
													<xsl:text>Package</xsl:text>
												</xsl:with-param>
											</xsl:call-template>
										</xsl:when>
										<xsl:when test="self::asClass">
											<xsl:variable name="isTopLevel">
												<xsl:call-template name="isTopLevel">
													<xsl:with-param name="packageName" select="@packageName" />
												</xsl:call-template>
											</xsl:variable>
											<xsl:variable name="classPath">
												<xsl:text>../</xsl:text>
												<xsl:if test="$isTopLevel='false'">
													<xsl:value-of select="translate(@packageName,'.','/')" />
												</xsl:if>
											</xsl:variable>
											<xsl:call-template name="getPageItemMenu">
												<xsl:with-param name="href" select="concat($classPath,'/',@name,'.html')" />
												<xsl:with-param name="name" select="@name" />
												<xsl:with-param name="class" select="concat('menu ',@type)" />
											</xsl:call-template>
											<xsl:call-template name="getTextBox">
												<xsl:with-param name="class" select="'textbox thintop'" />
												<xsl:with-param name="content">
													<xsl:call-template name="getClassDesc">
														<xsl:with-param name="packageName" select="@packageName"/>
													</xsl:call-template>
												</xsl:with-param>
											</xsl:call-template>
										</xsl:when>
										<xsl:when test="self::event or (self::method and @type='handler')">
											<xsl:variable name="isTopLevel">
												<xsl:call-template name="isTopLevel">
													<xsl:with-param name="packageName">
														<xsl:if test="ancestor::asClass">
															<xsl:value-of select="../../@packageName"/>
														</xsl:if>
														<xsl:if test="not(ancestor::asClass)">
															<xsl:value-of select="../../@name"/>
														</xsl:if>
													</xsl:with-param>
												</xsl:call-template>
											</xsl:variable>
											<xsl:variable name="classPath">
												<!-- AS2 lang elements -->
												<xsl:text>../</xsl:text>
												<xsl:if test="$isTopLevel='false'">
													<xsl:if test="ancestor::asClass">
														<xsl:value-of select="translate(../../@packageName,'.','/')"/>
													</xsl:if>
													<xsl:if test="not(ancestor::asClass)">
														<xsl:value-of select="translate(../../@name,'.','/')"/>
													</xsl:if>
												</xsl:if>
											</xsl:variable>
											<xsl:call-template name="getPageItemMenu">
												<xsl:with-param name="href">
													<xsl:choose>
														<xsl:when test="../../@type='list'">
															<xsl:value-of select="concat('../',../../@href,'#event:',@name)" />
														</xsl:when>
														<xsl:when test="ancestor::asClass">
															<xsl:value-of select="concat($classPath,'/',../../@name,'.html#event:',@name)"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="concat($classPath,'/package-detail.html#event:',@name)"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:with-param>
												<xsl:with-param name="name" select="@name" />
												<xsl:with-param name="class" select="concat('menu ',@type)" />
											</xsl:call-template>
											<xsl:call-template name="getTextBox">
												<xsl:with-param name="class" select="'textbox thintop'" />
												<xsl:with-param name="content">
													<xsl:if test="@type='handler'">
														<p>
															<code>
																<xsl:value-of select="@name" />
																<xsl:variable name="params">
																	<xsl:call-template name="getParamList">
																		<xsl:with-param name="params" select="params"/>
																	</xsl:call-template>
																</xsl:variable>
																<xsl:text>(</xsl:text>
																<xsl:copy-of select="$params"/>
																<xsl:text>)</xsl:text>
															</code>
														</p>
													</xsl:if>
													<xsl:call-template name="getEventDesc">
														<xsl:with-param name="classPath" select="$classPath"/>
													</xsl:call-template>
												</xsl:with-param>
											</xsl:call-template>
										</xsl:when>
										<xsl:when test="self::operator or self::statement">
											<xsl:variable name="suffix">
												<xsl:if test="self::operator and deprecated">
													<xsl:value-of select="'_deprecated'"/>
												</xsl:if>
												<xsl:if test="self::statment or not(deprecated)">
													<xsl:value-of select="''"/>
												</xsl:if>
											</xsl:variable>
											<xsl:variable name="href">
												<xsl:text>../</xsl:text>
												<xsl:if test="$config/options/@docversion='2'">
													<xsl:value-of select="../@href" />
												</xsl:if>
												<xsl:if test="not($config/options/@docversion='2')">
													<xsl:value-of select="local-name()" />
													<xsl:text>s.html</xsl:text>
												</xsl:if>
											</xsl:variable>
											<xsl:call-template name="getPageItemMenu">
												<xsl:with-param name="href" select="concat($href,'#',translate(@name,' ','_'),$suffix)" />
												<xsl:with-param name="name">
													<xsl:if test="string-length(@symbol)">
														<xsl:value-of select="@symbol"/>
														<xsl:text> (</xsl:text>
													</xsl:if>
													<xsl:value-of select="@name"/>
													<xsl:if test="string-length(@symbol)">
														<xsl:text>)</xsl:text>
													</xsl:if>
												</xsl:with-param>
											</xsl:call-template>
											<xsl:call-template name="getTextBox">
												<xsl:with-param name="class" select="'textbox thintop'" />
												<xsl:with-param name="content">
													<xsl:if test="self::operator">
														<xsl:text>Operator</xsl:text>
													</xsl:if>
													<xsl:if test="self::statement">
														<xsl:text>Statement</xsl:text>
													</xsl:if>
												</xsl:with-param>
											</xsl:call-template>
										</xsl:when>
										<xsl:when test="self::specialType">
											<xsl:call-template name="getPageItemMenu">
												<xsl:with-param name="href" select="concat('../specialTypes.html#',@name)" />
												<xsl:with-param name="name">
													<xsl:text>Special Type</xsl:text>
												</xsl:with-param>
											</xsl:call-template>
										</xsl:when>
										<xsl:when test="self::entry">
											<xsl:call-template name="getPageItemMenu">
												<xsl:with-param name="href" select="concat('../',@href)" />
												<xsl:with-param name="name">
													<xsl:text>MXML Only Component</xsl:text>
												</xsl:with-param>
											</xsl:call-template>
										</xsl:when>
									</xsl:choose>
									
									<xsl:call-template name="getTextBox">
										<xsl:with-param name="class" select="'textbox thintop'" />
										<xsl:with-param name="content">
											<xsl:choose>
												<xsl:when test="deprecated">
													<xsl:apply-templates select="deprecated"/>
												</xsl:when>
												<xsl:when test="(self::field or self::method or self::constructor or self::event) and ../../deprecated">
													<xsl:copy-of select="$deprecatedLabel"/>
													<em>
														<xsl:text>. The </xsl:text>
														<xsl:value-of select="../../@name"/>
														<xsl:text> class is deprecated</xsl:text>
														<xsl:if test="string-length(../../deprecated/@as-of)"> 
															<xsl:text> as of </xsl:text>
															<xsl:value-of select="../../deprecated/@as-of"/>
														</xsl:if>
														<xsl:text>.</xsl:text>
													</em>
												</xsl:when>
												<xsl:when test="self::entry">
													<xsl:call-template name="deTilda">
														<xsl:with-param name="inText" select="node()" />
													</xsl:call-template>
												</xsl:when>
												<xsl:when test="self::asPackage">
													<xsl:call-template name="getPackageComment">
														<xsl:with-param name="packageName" select="@name" />
													</xsl:call-template>
												</xsl:when>
												<xsl:otherwise>
													<!-- AS2 lang elements -->
													<xsl:if test="string-length(shortDescription/.) or string-length(short-description)">
														<xsl:call-template name="deTilda">
															<xsl:with-param name="inText" select="shortDescription/. | short-description/."/>
														</xsl:call-template>
													</xsl:if>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
							</xsl:for-each>
						</xsl:for-each>
					
					</ul>
				</div>
				<xsl:call-template name="getFooter" />
			</body>
		</xsl:element>
		<xsl:copy-of select="$copyrightComment"/>
	</xsl:template>

	<xsl:template name="getClassRef">
		<xsl:param name="classPath"/>

		<xsl:choose>
			<xsl:when test="string-length($classPath) > 1">
				<xsl:value-of select="../../@packageName"/>
				<xsl:text>.</xsl:text>
				<a href="{$classPath}/{../../@name}.html">
					<xsl:value-of select="../../@name"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<a href="../{../../@name}.html">
					<xsl:value-of select="../../@name"/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="getMethodDesc">
		<xsl:param name="classPath"/>

		<!-- AS2 lang elements -->
		<xsl:if test="../../@type and ../../@type!='list'">
			<!-- TODO handle more variations (override,final?) -->
			<xsl:if test="@isStatic = 'true'">Static method in</xsl:if>
			<xsl:if test="@isStatic != 'true'">Method in</xsl:if>
			<xsl:text> </xsl:text>
			<xsl:value-of select="../../@type"/>
			<xsl:text> </xsl:text>
			<xsl:call-template name="getClassRef">
				<xsl:with-param name="classPath" select="$classPath"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="not(../../@type)">
			<xsl:if test="@isStatic = 'true'">Package static function in </xsl:if>
			<xsl:if test="@isStatic != 'true'">Package function in </xsl:if>
			<xsl:variable name="isTopLevel">
				<xsl:call-template name="isTopLevel">
					<xsl:with-param name="packageName" select="ancestor::asPackage/@name"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:if test="$isTopLevel='false'">
				<a href="{$classPath}/package.html">
					<xsl:value-of select="ancestor::asPackage/@name" />
				</a>
			</xsl:if>
			<xsl:if test="$isTopLevel!='false'">
				<a href="../package.html">Top Level</a>
			</xsl:if>
		</xsl:if>
		<!-- AS2 lang elements -->
		<xsl:if test="../../@type='list'">
			<xsl:if test="@type='directive'">
				<xsl:text>Compiler Directive</xsl:text>
			</xsl:if>
			<xsl:if test="@type!='directive'">
				<xsl:text>Global function</xsl:text>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template name="getConstructorDesc">
		<xsl:param name="classPath"/>

		<xsl:text>Constructor in class</xsl:text>
		<xsl:text> </xsl:text>
		<xsl:call-template name="getClassRef">
			<xsl:with-param name="classPath" select="$classPath"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="getPropertyDesc">
		<xsl:param name="classPath"/>

		<!-- AS2 lang elements -->
		<xsl:if test="../../@type and ../../@type!='list'">
			<xsl:if test="@isStatic = 'true'">
				<xsl:if test="@isConst = 'true'">Constant static property in</xsl:if>
				<xsl:if test="@isConst != 'true'">Static property in</xsl:if>
			</xsl:if>
			<xsl:if test="@isStatic != 'true'">
				<xsl:if test="@isConst = 'true'">Constant property in</xsl:if>
				<xsl:if test="@isConst != 'true'">Property in</xsl:if>
			</xsl:if>
			<xsl:text> </xsl:text>
			<xsl:value-of select="../../@type"/>
			<xsl:text> </xsl:text>
			<xsl:call-template name="getClassRef">
				<xsl:with-param name="classPath" select="$classPath"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="not(../../@type)">
			<xsl:if test="@isStatic = 'true'">
				<xsl:if test="@isConst = 'true'">Package constant static property in </xsl:if>
				<xsl:if test="@isConst != 'true'">Package static property in </xsl:if>
			</xsl:if>
			<xsl:if test="@isStatic != 'true'">
				<xsl:if test="@isConst = 'true'">Package constant property in </xsl:if>
				<xsl:if test="@isConst != 'true'">Package property in </xsl:if>
			</xsl:if>
			<xsl:variable name="isTopLevel">
				<xsl:call-template name="isTopLevel">
					<xsl:with-param name="packageName" select="ancestor::asPackage/@name"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:if test="$isTopLevel='false'">
				<a href="{$classPath}/package.html">
					<xsl:value-of select="ancestor::asPackage/@name" />
				</a>
			</xsl:if>
			<xsl:if test="$isTopLevel!='false'">
				<a href="../package.html">Top Level</a>
			</xsl:if>
		</xsl:if>
		<!-- AS2 lang elements -->
		<xsl:if test="../../@type='list'">
			<xsl:if test="../../@name='Constants'">
				<xsl:text>Constant property</xsl:text>
			</xsl:if>
			<xsl:if test="../../@name!='Constants'">
				<xsl:text>Global property</xsl:text>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template name="getEventDesc">
		<xsl:param name="classPath"/>

		<!-- AS2 lang elements -->
		<xsl:if test="../../@type!='list'">
			<xsl:choose>
				<xsl:when test="@type = 'handler'">
					<xsl:text>Event handler in</xsl:text>
				</xsl:when>
				<xsl:when test="@type != 'handler'">
					<xsl:text>Event listener in</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Event in</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text> </xsl:text>
			<xsl:value-of select="../../@type"/>
			<xsl:text> </xsl:text>
			<xsl:call-template name="getClassRef">
				<xsl:with-param name="classPath" select="$classPath"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="not(../../@type) or ../../@type='list'">
			<xsl:if test="@type = 'handler'">
				<xsl:text>Global event handler</xsl:text>
			</xsl:if>
			<xsl:if test="@type != 'handler'">
				<xsl:text>Global event listener</xsl:text>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template name="getPackageComment">
		<xsl:param name="packageName" />
		
		<xsl:if test="not($config/overviews/package)">
			<xsl:variable name="packageComments" select="document($overviewsFile)/overviews/packages/package[@name=$packageName]"/>
			<xsl:if test="string-length($packageComments/shortDescription/.)">
				<xsl:call-template name="deTilda">
					<xsl:with-param name="inText" select="$packageComments/shortDescription"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$config/overviews/package">
			<xsl:for-each select="$config/overviews/package">
				<xsl:variable name="packageOverview" select="document(.)/overviews/packages/package[@name=$packageName]" />									
				<xsl:if test="string-length($packageOverview/shortDescription/.)">
					<xsl:call-template name="deTilda">
						<xsl:with-param name="inText" select="$packageOverview/shortDescription" />
					</xsl:call-template>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

	<xsl:template name="getClassDesc">
		<xsl:param name="packageName"/>

		<xsl:if test="string-length($packageName)=0">

			<xsl:if test="@isFinal = 'true'">
				<xsl:if test="@isDynamic = 'true'">Final dynamic class</xsl:if>
				<xsl:if test="not(@isDynamic) or @isDynamic != 'true'">Final class</xsl:if>
			</xsl:if>
			<xsl:if test="@isFinal != 'true'">
				<xsl:if test="@isDynamic = 'true'">Dynamic class</xsl:if>
				<xsl:if test="not(@isDynamic) or @isDynamic != 'true'">
					<xsl:if test="@type='interface'">Interface</xsl:if>
					<xsl:if test="@type!='interface'">Class</xsl:if>
				</xsl:if>
			</xsl:if>
			<xsl:text> in </xsl:text>
			<a href="../package-detail.html">Top Level</a>
		</xsl:if>
		<xsl:if test="string-length($packageName)">
			<xsl:if test="@isFinal = 'true'">
				<xsl:if test="@isDynamic = 'true'">Final dynamic class</xsl:if>
				<xsl:if test="not(@isDynamic) or @isDynamic != 'true'">Final class</xsl:if>
			</xsl:if>
			<xsl:if test="@isFinal != 'true'">
				<xsl:if test="@isDynamic = 'true'">Dynamic class</xsl:if>
				<xsl:if test="not(@isDynamic) or @isDynamic != 'true'">
					<xsl:if test="@type='interface'">Interface</xsl:if>
					<xsl:if test="@type!='interface'">Class</xsl:if>
				</xsl:if>
			</xsl:if>
			<xsl:text> in package </xsl:text>
			<a href="../{translate($packageName,'.','/')}/package-detail.html">
				<xsl:value-of select="$packageName"/>
			</a>
		</xsl:if>
	</xsl:template>

	<xsl:template name="getParamList">
		<xsl:param name="params"/>

		<xsl:for-each select="$params/param">
			<xsl:if test="position()>1">
				<xsl:text>, </xsl:text>
			</xsl:if>
			<xsl:if test="$config/options/@docversion='2' and @optional='true'">
				<xsl:text>[</xsl:text>
			</xsl:if>
			<xsl:if test="not(@type = 'restParam')">
				<xsl:variable name="href">
					<!-- AS2 lang elements -->
					<xsl:if test="../../../../@type='list'">
						<xsl:value-of select="@type"/>
					</xsl:if>
					<xsl:if test="../../../../@type!='list'">
						<xsl:call-template name="convertFullName">
							<xsl:with-param name="fullname" select="classRef/@fullName"/>
							<xsl:with-param name="separator">/</xsl:with-param>
						</xsl:call-template>
					</xsl:if>
				</xsl:variable>
				<xsl:value-of select="@name" />
				<xsl:if test="string-length($href)">
					<xsl:text>:</xsl:text>
					<xsl:if test="../../../../@type='list'">
						<a href="{$href}.html">
							<xsl:value-of select="@type" />
						</a>
					</xsl:if>
					<xsl:if test="../../../../@type!='list'">
						<a href="{$href}.html">
							<xsl:attribute name="onclick">
								<xsl:text>javascript:loadClassListFrame('</xsl:text>
								<xsl:call-template name="substring-before-last">
									<xsl:with-param name="input" select="$href" />
									<xsl:with-param name="substr" select="'/'" />
								</xsl:call-template>
								<xsl:text>./class-list.html');</xsl:text>
							</xsl:attribute>
							<xsl:value-of select="@type" />
						</a>
					</xsl:if>
				</xsl:if>
			</xsl:if>
			<xsl:if test="@type = 'restParam'">
				<xsl:text>... rest</xsl:text>
			</xsl:if>
			<xsl:if test="$config/options/@docversion='2' and @optional='true'">
				<xsl:text>]</xsl:text>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>