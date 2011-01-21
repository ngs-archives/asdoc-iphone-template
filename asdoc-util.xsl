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
	xmlns:date="http://exslt.org/dates-and-times" exclude-result-prefixes="exslt date str"
	xmlns:str="http://exslt.org/strings"
	xmlns:exslt="http://exslt.org/common" >

	<!-- <xsl:output method="html" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" encoding="UTF-8" indent="yes"/> -->
	<xsl:output method="html" encoding="UTF-8" indent="yes" />

	<xsl:variable name="newline">
		<xsl:text>
</xsl:text>
	</xsl:variable>
	<xsl:variable name="markOfTheWeb" select="'&lt;!-- saved from url=(0014)about:internet -->'" />
	<xsl:variable name="docType">
		<xsl:text disable-output-escaping="yes">&lt;!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"></xsl:text>
		<xsl:value-of select="$newline" />
		<xsl:if test="$config/options[@standalone='true']">
			<xsl:value-of disable-output-escaping="yes" select="$markOfTheWeb" />
			<xsl:value-of select="$newline" />
		</xsl:if>
	</xsl:variable>	
	<xsl:variable name="frameDocType">
		<xsl:text disable-output-escaping="yes">&lt;!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd"></xsl:text>
		<xsl:value-of select="$newline" />
		<xsl:if test="$config/options[@standalone='true']">
			<xsl:value-of  disable-output-escaping="yes" select="$markOfTheWeb" />
			<xsl:value-of select="$newline" />
		</xsl:if>
	</xsl:variable>
	<xsl:param name="configFilename" select="'ASDoc_Config.xml'"/>
	<xsl:variable name="config" select="document($configFilename)/asDocConfig"/>
	<xsl:param name="packageCommentsFilename" select="'packages.xml'"/>
	<xsl:param name="AS1tooltip" select="'This example can be used with ActionScript 1.0'" />
	<xsl:param name="AS2tooltip" select="'This example requires ActionScript 2.0'" />
	<xsl:param name="AS3tooltip" select="'This example requires ActionScript 3.0'" />
	<xsl:param name="showASIcons" select="'false'" />
	<xsl:param name="showInheritanceIcon" select="'true'" />
	<xsl:param name="inheritanceIcon" select="'inherit-arrow.jpg'" />
	<xsl:param name="isEclipse" select="$config/options[@eclipse='true']" />
	<xsl:param name="isLiveDocs" select="$config/options[@livedocs='true']" />
	<xsl:param name="isStandalone" select="$config/options[@standalone='true']" />
	<xsl:param name="liveDocsSearchSite" select="$config/liveDocsSearchSite/." />
	<xsl:param name="showLangVersionWarnings">
		<xsl:if test="$config/warnings/@langversion='true'">
			<xsl:value-of select="'true'"/>
		</xsl:if>
	</xsl:param>
	<xsl:param name="showPlayerVersionWarnings">
		<xsl:if test="$config/warnings/@playerversion='true'">
			<xsl:value-of select="'true'"/>
		</xsl:if>
	</xsl:param>
	<xsl:param name="noLiveDocs">
		<xsl:if test="$config/options[@livedocs='true']">
			<xsl:comment>livedocs:no</xsl:comment>
			<xsl:value-of select="$newline" />
		</xsl:if>
	</xsl:param>
	<xsl:param name="showXrefs" select="$config/xrefs[@show='true']" />
	<xsl:variable name="xrefs">
		<xsl:if test="$showXrefs">
			<xsl:copy-of select="document($config/xrefs/@mapfile)/helpreferences" />
		</xsl:if>
	</xsl:variable>
	<xsl:param name="title-base" select="$config/windowTitle/."/>
	<xsl:param name="page-title-base" select="$config/title/."/>
	<xsl:param name="timestamp" select="date:format-date(date:date-time(),'EEE MMM d yyyy, h:mm a z')" />
	<xsl:param name="copyright">
		<xsl:value-of disable-output-escaping="no" select="$config/footer"/>
	</xsl:param>
	<xsl:variable name="copyrightComment">
		<xsl:comment><xsl:copy-of select="$copyright"/></xsl:comment>
	</xsl:variable>
	<xsl:variable name="upperCase">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
	<xsl:variable name="lowerCase">abcdefghijklmnopqrstuvwxyz</xsl:variable>
	<xsl:variable name="emdash">
		<xsl:text> &#x2014; </xsl:text>
	</xsl:variable>
	<xsl:variable name="asterisk">
		<xsl:text>&#x2A;</xsl:text>
	</xsl:variable>
	<xsl:variable name="nbsp">
		<xsl:text>&#xA0;</xsl:text>
	</xsl:variable>
	<xsl:variable name="degree">
		<xsl:text>&#xB0;</xsl:text>
	</xsl:variable>
	<xsl:variable name="trademark">
		<xsl:text>&#x2122;</xsl:text>
	</xsl:variable>
	<xsl:variable name="registered">
		<xsl:text>&#xAE;</xsl:text>
	</xsl:variable>

	<xsl:template name="getBaseRef">
		<xsl:param name="packageName"/>

		<xsl:variable name="isTopLevel">
			<xsl:call-template name="isTopLevel">
				<xsl:with-param name="packageName" select="$packageName"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:if test="$isTopLevel='false'">
			<xsl:variable name="newName" select="substring-after($packageName,'.')"/>
			<xsl:if test="$packageName">
				<xsl:text>../</xsl:text>
				<xsl:call-template name="getBaseRef">
					<xsl:with-param name="packageName" select="$newName"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="getInheritedIcon">
		<xsl:param name="baseRef" select="''" />
		<span class="inherited-icon">
			<img src="{$baseRef}images/inheritedSummary.gif" alt="Inherited" title="Inherited" class="inheritedSummaryImage" />
		</span>
	</xsl:template>
	
	<xsl:template name="getInlineScript">
		<xsl:param name="script" />
		<script type="text/javascript">
			<xsl:value-of select="concat('/*&lt;![CDATA[*/ ',$script,' /*]]&gt;*/')" disable-output-escaping="yes" />
		</script>
	</xsl:template>

	<xsl:template name="getStyleLink">
		<xsl:param name="link"/>
		<xsl:param name="packageName"/>
		<xsl:param name="baseRef">
			<xsl:call-template name="getBaseRef">
				<xsl:with-param name="packageName" select="$packageName"/>
			</xsl:call-template>
		</xsl:param>
		<meta name = "format-detection" content = "telephone=no" />
		<meta name="apple-mobile-web-app-capable" content="yes" />
		<meta name="viewport" content="minimum-scale=1.0, width=device-width, maximum-scale=0.6667, user-scalable=no" />
		<link rel="apple-touch-icon" type="image/png" href="{concat($baseRef,'images/touchicon.png')}" />
		<link rel="stylesheet" type="text/css" href="{concat($baseRef,'style.css')}" media="screen" />
		<link rel="stylesheet" type="text/css" href="{concat($baseRef,'print.css')}" media="screen" />
		<script type="text/javascript" src="{concat($baseRef,'asdoc.js')}"><xsl:text> </xsl:text></script>
	</xsl:template>
	
	<xsl:template name="getFooter">
		<xsl:if test="string-length($copyright)&gt;0">
			<div id="iwebkit-footer">
				<address><xsl:copy-of select="$copyright"/></address>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template name="getPageItemMenu">
		<xsl:param name="id" />
		<xsl:param name="packageName"/>
		<xsl:param name="class" select="'menu'" />
		<xsl:param name="name" />
		<xsl:param name="href" select="false()" />
		<xsl:param name="blank" select="false()" />
		<xsl:param name="comment" />
		<xsl:param name="arrow" select="true()" />
		<xsl:param name="air" select="false()" />
		<xsl:variable name="baseRef">
			<xsl:call-template name="getBaseRef">
				<xsl:with-param name="packageName" select="$packageName"/>
			</xsl:call-template>
		</xsl:variable>

		<li class="{$class}">
			<xsl:if test="string-length($id)&gt;0">
				<xsl:attribute name="id">
					<xsl:value-of select="$id" />
				</xsl:attribute>
			</xsl:if>
			<a>
				<xsl:if test="$href">
					<xsl:attribute name="href"><xsl:value-of select="$href" /></xsl:attribute>
				</xsl:if>
				<xsl:if test="$blank">
					<xsl:attribute name="target">_blank</xsl:attribute>
				</xsl:if>
				<xsl:if test="$air">
					<img src="{$baseRef}images/AirIcon12x32.gif" alt="On Adobe AIR" />
				</xsl:if>
				<xsl:if test="$name">
					<span class="name"><xsl:value-of select="$name"/></span>
				</xsl:if>
				<xsl:if test="$comment">
					<span class="comment"><xsl:value-of select="$comment"/></span>
				</xsl:if>
				<xsl:if test="$arrow and $href">
					<span class="arrow"><xsl:value-of select="' '"/></span>
				</xsl:if>
			</a>
		</li>
		
	</xsl:template>

	<xsl:template name="getTextBox">
		<xsl:param name="content" />
		<xsl:param name="id" />
		<xsl:param name="class" select="'textbox'" />
		<xsl:if test="string-length(normalize-space(translate($content,$nbsp,'')))">
			<li class="{$class}">
				<xsl:if test="string-length($id)&gt;0">
					<xsl:attribute name="id">
						<xsl:value-of select="$id" />
					</xsl:attribute>
				</xsl:if>
				<xsl:copy-of select="$content" />
			</li>
		</xsl:if>
	</xsl:template>

	<xsl:template name="getTitleScript">
	</xsl:template>

	<xsl:template name="getLinks">
	</xsl:template>

	<xsl:template name="setTitle">
			<xsl:value-of disable-output-escaping="yes" select="$page-title-base" />
    </xsl:template>

	<xsl:template name="getNavLinks2">
		<xsl:param name="copyNum" />
		<xsl:param name="baseRef" />
		<xsl:param name="showPackages" />
		<xsl:param name="showAllClasses" />
		<xsl:param name="showLanguageElements" />
		<xsl:param name="showIndex" />
		<xsl:param name="splitIndex" />
		<xsl:param name="showAppendixes" />
		<xsl:param name="showConventions" />
		<xsl:param name="href" />
		<xsl:param name="fileName" />
		<xsl:param name="fileName2" />

		<xsl:if test="$showPackages">
			<a href="{$baseRef}package-summary.html" onclick="loadClassListFrame('{$baseRef}all-classes.html')">All&#xA0;Packages</a>
			<!-- <xsl:if test="$showAllClasses or $showIndex or $showLanguageElements"> -->
				<xsl:text>&#xA0;|&#xA0;</xsl:text>
			<!-- </xsl:if> -->
		</xsl:if>
		<xsl:if test="$showAllClasses">
			<a href="{$baseRef}class-summary.html" onclick="loadClassListFrame('{$baseRef}all-classes.html')">All&#xA0;Classes</a>
			<!-- <xsl:if test="$showIndex or $showLanguageElements"> -->
				<xsl:text>&#xA0;|&#xA0;</xsl:text>
			<!-- </xsl:if> -->
		</xsl:if>
		<xsl:if test="$showLanguageElements">
			<a href="{$baseRef}language-elements.html">Language&#xA0;Elements</a>
			<!-- <xsl:if test="$showIndex"> -->
				<xsl:text>&#xA0;| </xsl:text>
			<!-- </xsl:if> -->
		</xsl:if>
		<xsl:if test="$showIndex">
			<xsl:if test="$splitIndex='false'">
				<a href="{$baseRef}all-index.html" onclick="loadClassListFrame('{$baseRef}index-list.html')">Index</a>
			</xsl:if>
			<xsl:if test="$splitIndex!='false' and $config/languageElements/@show='true' and $config/languageElements/@operators='true'">
				<a href="{$baseRef}all-index-Symbols.html" onclick="loadClassListFrame('{$baseRef}index-list.html')">Index</a>
			</xsl:if>
			<xsl:if test="$splitIndex!='false' and ($config/languageElements/@show!='true' or $config/languageElements/@operators!='true')">
				<a href="{$baseRef}all-index-A.html" onclick="loadClassListFrame('{$baseRef}index-list.html')">Index</a>
			</xsl:if>
			<xsl:text>&#xA0;|&#xA0;</xsl:text>
		</xsl:if>
		<xsl:if test="$showAppendixes and $config/appendixes/@show='true'">
			<a href="{$baseRef}appendixes.html">Appendixes</a>
			<xsl:text>&#xA0;|&#xA0;</xsl:text>
		</xsl:if>
		<xsl:if test="$showConventions='true'">
			<a href="{$baseRef}conventions.html">Conventions</a>
			<xsl:text>&#xA0;|&#xA0;</xsl:text>
		</xsl:if>

		<a id="framesLink{$copyNum}" href="{$baseRef}index.html?{$href}{$fileName}.html&amp;amp;{$fileName2}">Frames</a>
		<a id="noFramesLink{$copyNum}" style="display:none" href="" onclick="parent.location=document.location">No&#xA0;Frames</a>
	</xsl:template>

	<xsl:template name="getNavLinks">
		<xsl:param name="copyNum" />
		<xsl:param name="baseRef" />
		<xsl:param name="showPackages" />
		<xsl:param name="showAllClasses" />
		<xsl:param name="showLanguageElements" />
		<xsl:param name="showMXMLOnly" />
		<xsl:param name="showIndex" />
		<xsl:param name="splitIndex" />
		<xsl:param name="showAppendixes" />
		<xsl:param name="showConventions" />
		<xsl:param name="href" />
		<xsl:param name="fileName" />
		<xsl:param name="fileName2" />

		<div width="100%" class="topLinks" align="right" style="padding-bottom:5px">
			<span id="navigationCell{$copyNum}" style="display:none;font-size:14px;font-weight:bold">
<!-- 				<xsl:if test="$showInnerClasses or $showInterfaces or $showClasses or $showConstants or $showPackageConstants or $showProperties or $showPackageProperties or $showConstructors or $showMethods or $showPackageFunctions or $showStyles or $showEffects or $showEvents or $showIncludeExamples or $additionalLinks">
					<xsl:text disable-output-escaping="yes">&amp;nbsp;| </xsl:text>
				</xsl:if> -->
				<xsl:if test="$showPackages">
					<a href="{$baseRef}package-summary.html" onclick="loadClassListFrame('{$baseRef}all-classes.html')">All&#xA0;Packages</a>
					<!-- <xsl:if test="$showAllClasses or $showIndex or $showLanguageElements"> -->
						<xsl:text>&#xA0;| </xsl:text>
					<!-- </xsl:if> -->
				</xsl:if>
				<xsl:if test="$showAllClasses">
					<a href="{$baseRef}class-summary.html" onclick="loadClassListFrame('{$baseRef}all-classes.html')">All&#xA0;Classes</a>
					<!-- <xsl:if test="$showIndex or $showLanguageElements"> -->
						<xsl:text>&#xA0;| </xsl:text>
					<!-- </xsl:if> -->
				</xsl:if>
				<xsl:if test="$showLanguageElements">
					<a href="{$baseRef}language-elements.html">Language&#xA0;Elements</a>
					<!-- <xsl:if test="$showIndex"> -->
						<xsl:text>&#xA0;| </xsl:text>
					<!-- </xsl:if> -->
				</xsl:if>
				<xsl:if test="$showMXMLOnly">
					<a href="{$baseRef}mxml-tag-detail.html" onclick="loadClassListFrame('{$baseRef}mxml-tags.html')">MXML&#xA0;Only&#xA0;Components</a>
					<xsl:text>&#xA0;| </xsl:text>
				</xsl:if>
				<xsl:if test="$showIndex">
					<xsl:if test="$splitIndex='false'">
						<a href="{$baseRef}all-index.html" onclick="loadClassListFrame('{$baseRef}index-list.html')">Index</a>
					</xsl:if>
					<xsl:if test="$splitIndex!='false' and $config/languageElements/@show='true' and $config/languageElements/@operators='true'">
						<a href="{$baseRef}all-index-Symbols.html" onclick="loadClassListFrame('{$baseRef}index-list.html')">Index</a>
					</xsl:if>
					<xsl:if test="$splitIndex!='false' and ($config/languageElements/@show!='true' or $config/languageElements/@operators!='true')">
						<a href="{$baseRef}all-index-A.html" onclick="loadClassListFrame('{$baseRef}index-list.html')">Index</a>
					</xsl:if>
					<xsl:text>&#xA0;| </xsl:text>
				</xsl:if>
				<xsl:if test="$showAppendixes and $config/appendixes/@show='true'">
					<a href="{$baseRef}appendixes.html">Appendixes</a>
					<xsl:text>&#xA0;| </xsl:text>
				</xsl:if>
				<xsl:if test="$showConventions='true'">
					<a href="{$baseRef}conventions.html">Conventions</a>
					<xsl:text>&#xA0;| </xsl:text>
				</xsl:if>

				<a id="framesLink{$copyNum}" href="{$baseRef}index.html?{$href}{$fileName}.html&amp;amp;{$fileName2}">Frames</a>
				<a id="noFramesLink{$copyNum}" style="display:none" href="" onclick="parent.location=document.location">No&#xA0;Frames</a>
			</span>
		</div>
	</xsl:template>

	<xsl:template name="getFeedbackLink">
	</xsl:template>

	<!-- TODO support multiple? -->
	<xsl:template name="version">
		<xsl:if test="$showLangVersionWarnings='true' and not(count(versions/langversion))">
			<xsl:message>WARNING: no langversion for <xsl:if test="../../@name">
				<xsl:value-of select="../../@name"/>
				<xsl:text>.</xsl:text>
			</xsl:if><xsl:value-of select="@name"/></xsl:message>
		</xsl:if>
		<xsl:if test="$showPlayerVersionWarnings='true' and not(count(versions/playerversion))">
			<xsl:message>WARNING: no playerversion for <xsl:if test="../../@name">
				<xsl:value-of select="../../@name"/>
				<xsl:text>.</xsl:text>
			</xsl:if><xsl:value-of select="@name"/></xsl:message>
		</xsl:if>
		<xsl:if test="$showPlayerVersionWarnings='true'">
			<table class="class-info">
				<xsl:if test="$config/options[@docversion='3']">
					<tr class="player-version">
						<th>Player version</th>
						<td>Flash Player 8.5</td>
					</tr>
				</xsl:if>
				<xsl:if test="not($config/options[@docversion='3'])">
					<xsl:if test="count(versions/langversion[not(starts-with(@version,'1'))]) or count(versions/playerversion)">
						<xsl:if test="count(versions/langversion[not(starts-with(@version,'1'))])">
							<tr ckass="lang-version">
								<th>Language version</th>
								<td>
									<xsl:text>ActionScript </xsl:text>
									<xsl:value-of select="translate(versions/langversion/@version,'+','')"/>
									<xsl:if test="substring-before(versions/langversion/@version, '+')">
										<xsl:text> and later</xsl:text>
									</xsl:if>
									<xsl:if test="string-length(normalize-space(versions/langversion))">
										<xsl:value-of select="$emdash"/>
										<xsl:call-template name="deTilda">
											<xsl:with-param name="inText" select="normalize-space(versions/langversion)"/>
										</xsl:call-template>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="count(versions/playerversion)">
							<tr class="player-version">
							<th>Player version</th>
								<td>
									<xsl:choose>
										<xsl:when test="versions/playerversion/@name='Flash'">
											<xsl:text>Flash Player </xsl:text>
										</xsl:when>
										<xsl:when test="versions/playerversion/@name='Lite'">
											<xsl:text>Flash Lite </xsl:text>
										</xsl:when>
									</xsl:choose>
				 					<xsl:value-of select="translate(translate(versions/playerversion/@version,'+',''),',','.')"/>
									<xsl:if test="substring-before(versions/playerversion/@version, '+')">
										<xsl:text> and later</xsl:text>
									</xsl:if>
									<xsl:if test="string-length(normalize-space(versions/playerversion))">
										<xsl:value-of select="$emdash"/>
										<xsl:call-template name="deTilda">
											<xsl:with-param name="inText" select="normalize-space(versions/playerversion)"/>
										</xsl:call-template>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
					</xsl:if>
				</xsl:if>
			</table>
		</xsl:if>
	</xsl:template>

	<xsl:template name="isTopLevel">
		<xsl:param name="packageName"/>
		<xsl:value-of select="string-length($packageName)=0 or contains($packageName,'$$')"/>
	</xsl:template>

	<xsl:template name="getPackageComments">
		<xsl:param name="name"/>
		<xsl:element name="package">
			<xsl:copy-of select="document($packageCommentsFilename)/packages/package[@name=$name]"/>
		</xsl:element>
	</xsl:template>

	<xsl:template name="getFirstSentence">
		<xsl:param name="inText"/>
		<xsl:variable name="text" select="normalize-space($inText)"/>
		<xsl:variable name="periodWithTag">
			<xsl:text disable-output-escaping="yes">.&lt;</xsl:text>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="string-length($text) = 0"/>
			<xsl:when test="substring-before($text,'. ')">
				<xsl:value-of select="substring-before($text,'. ')" disable-output-escaping="yes"/>.</xsl:when>
			<xsl:when test="substring-before($text,$periodWithTag)">
				<xsl:value-of select="substring-before($inText,$periodWithTag)" disable-output-escaping="yes"/>.</xsl:when>
			<xsl:when test="substring-before($text,'.')">
				<xsl:value-of select="substring-before($text,'.')" disable-output-escaping="yes"/>.</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text" disable-output-escaping="yes"/>.</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="deTilda">
		<xsl:param name="inText"/>
		<xsl:variable name="text">
			<xsl:call-template name="search-and-replace">
				<xsl:with-param name="search-string" select="'~~'"/>
				<xsl:with-param name="replace-string" select="'*'"/>
				<xsl:with-param name="input">
 					<xsl:call-template name="convertListing">
						<xsl:with-param name="inText" select="$inText"/>
					</xsl:call-template>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>		
		<xsl:variable name="text2">
			<xsl:call-template name="search-and-replace">
				<xsl:with-param name="search-string" select="'TAAB'" />
				<xsl:with-param name="replace-string" select="'    '" />
				<xsl:with-param name="input" select="$text" />
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="$text2" disable-output-escaping="yes"/>
	</xsl:template>

	<xsl:template name="listingIcon">
		<xsl:param name="version" />

		<xsl:variable name="conditionalText">
			<xsl:choose>
				<xsl:when test="number($version)=3">
					<xsl:text>3.gif' alt='</xsl:text>
					<xsl:value-of select="$AS3tooltip" />
					<xsl:text>' title='</xsl:text>
					<xsl:value-of select="$AS3tooltip" />
				</xsl:when>
				<xsl:when test="number($version)=2">
					<xsl:text>2.gif' alt='</xsl:text>
					<xsl:value-of select="$AS2tooltip" />
					<xsl:text>' title='</xsl:text>
					<xsl:value-of select="$AS2tooltip" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>1.gif' alt='</xsl:text>
					<xsl:value-of select="$AS1tooltip" />
					<xsl:text>' title='</xsl:text>
					<xsl:value-of select="$AS1tooltip" /></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:text disable-output-escaping="yes">&lt;img src='</xsl:text>
		<xsl:call-template name="getBaseRef">
			<xsl:with-param name="packageName" select="ancestor-or-self::asClass/@packageName" />
		</xsl:call-template>
		<xsl:text>images/AS</xsl:text>
		<xsl:value-of select="$conditionalText" />
		<xsl:text>' width='96' height='15' style='margin-right:5px' /&gt;</xsl:text>
	</xsl:template>

	<xsl:template name="convertListing">
		<xsl:param name="inText" select="''"/>

		<xsl:if test="not(contains($inText,'&lt;listing'))">
			<xsl:value-of select="$inText"/>
		</xsl:if>
		<xsl:if test="contains($inText,'&lt;listing')">
			<xsl:value-of select="substring-before($inText,'&lt;listing')"/>
			
			<xsl:if test="$showASIcons='true'">
				<xsl:text disable-output-escaping="yes">&lt;div class='listingIcons'&gt;</xsl:text>
				<xsl:choose>
					<xsl:when test="contains(substring-before($inText,'&lt;/listing&gt;'),'version=&quot;3')">
						<xsl:call-template name="listingIcon">
							<xsl:with-param name="version" select="3" />
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="contains(substring-before($inText,'&lt;/listing&gt;'),'version=&quot;2')">
						<xsl:call-template name="listingIcon">
							<xsl:with-param name="version" select="2" />
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="listingIcon">
							<xsl:with-param name="version" select="1" />
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text disable-output-escaping="yes">&lt;/div&gt;</xsl:text>
			</xsl:if>

			<xsl:variable name="remainder" select="substring-after(substring-after($inText,'&lt;listing'),'&gt;')"/>
			<xsl:text disable-output-escaping="yes">&lt;div class='listing'&gt;&lt;pre&gt;</xsl:text>
			<xsl:value-of select="substring-before($remainder,'&lt;/listing&gt;')"/>
			<xsl:text disable-output-escaping="yes">&lt;/pre&gt;&lt;/div&gt;</xsl:text>
			<xsl:call-template name="convertListing">
				<xsl:with-param name="inText" select="substring-after($remainder,'&lt;/listing&gt;')"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>


	<xsl:template name="getKeywords">
		<xsl:variable name="keywords">
			<xsl:if test=".//Xkeyword">
				<xsl:for-each select=".//keyword">
					<xsl:value-of select="normalize-space()"/>
					<xsl:text>, </xsl:text>
				</xsl:for-each>
			</xsl:if>
			<xsl:value-of select="@name"/>
			<xsl:if test="string-length(@packageName)">
				<xsl:text>,</xsl:text>
				<xsl:call-template name="convertFullName">
					<xsl:with-param name="fullname" select="@fullname"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="fields/field">
				<xsl:text>,</xsl:text>
				<xsl:for-each select="fields/field">
					<xsl:value-of select="@name"/>
					<xsl:if test="position() != last()">
						<xsl:text>,</xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:if>
			<xsl:if test="methods/method">
				<xsl:text>,</xsl:text>
				<xsl:for-each select="methods/method">
					<xsl:value-of select="@name"/>
					<xsl:if test="position() != last()">
						<xsl:text>,</xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:if>
		</xsl:variable>

		<meta name="keywords" content="{$keywords}"/>
	</xsl:template>

	<xsl:template name="convertFullName">
		<xsl:param name="fullname"/>
		<xsl:param name="separator">.</xsl:param>
		<xsl:param name="justClass">false</xsl:param>

		<xsl:variable name="trimmed">
			<xsl:call-template name="search-and-replace">
				<xsl:with-param name="input" select="$fullname"/>
				<xsl:with-param name="search-string">:public</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="trimmed2">
			<xsl:call-template name="search-and-replace">
				<xsl:with-param name="input" select="$trimmed"/>
				<xsl:with-param name="search-string">:internal</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="trimmed3" select="translate($trimmed2,':','.')"/>
		<xsl:choose>
			<xsl:when test="$justClass = 'true'">
				<xsl:call-template name="substring-after-last">
					<xsl:with-param name="input" select="translate($trimmed3,'/','.')"/>
					<xsl:with-param name="substr">.</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($trimmed3,'/')">
				<xsl:value-of select="translate(substring-before($trimmed3,'/'),'.',$separator)"/>
				<xsl:text>.</xsl:text>
				<xsl:variable name="trimmed4" select="substring-after($trimmed3,'/')"/>
				<xsl:if test="contains($trimmed4,'.')">
					<xsl:variable name="trimmed5">
						<xsl:call-template name="substring-after-last">
							<xsl:with-param name="input" select="$trimmed4"/>
							<xsl:with-param name="substr" select="'.'"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:value-of select="translate($trimmed5,'.',$separator)"/>
				</xsl:if>
				<xsl:if test="not(contains($trimmed4,'.'))">
					<xsl:value-of select="translate($trimmed4,'.',$separator)"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="translate($trimmed3,'.',$separator)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="sees">
		<xsl:param name="labelClass" select="'label'" />
		<xsl:param name="xrefId">
			<xsl:choose>
				<xsl:when test="self::operator">
					<xsl:text>operator#</xsl:text>
				</xsl:when>
				<xsl:when test="self::statement">
					<xsl:text>statement#</xsl:text>
				</xsl:when>
				<xsl:when test="self::specialType">
					<xsl:text>specialType#</xsl:text>
				</xsl:when>
				<xsl:when test="self::statements">
					<xsl:text>statements</xsl:text>
				</xsl:when>
				<xsl:when test="self::operators">
					<xsl:text>operators</xsl:text>
				</xsl:when>
				<xsl:when test="self::specialTypes">
					<xsl:text>special-types</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="ancestor::asPackage/@name='$$Global$$' and not(ancestor-or-self::asClass)">
						<xsl:text>global</xsl:text>					
						<xsl:if test="ancestor::asClass">
							<xsl:text>.</xsl:text>
						</xsl:if>
					</xsl:if>
					<xsl:if test="not(ancestor::asPackage/@name='$$Global$$')"> 
						<xsl:value-of select="ancestor::asPackage/@name" />			
						<xsl:if test="ancestor-or-self::asClass">
							<xsl:text>.</xsl:text>
						</xsl:if>
					</xsl:if>
					<xsl:if test="ancestor-or-self::asClass">
						<xsl:value-of select="ancestor::asClass/@name" />
					</xsl:if>
					<xsl:choose>
						<xsl:when test="self::constructor">
							<xsl:text>#method:</xsl:text>
						</xsl:when>
						<xsl:when test="self::method">
							<xsl:text>#method:</xsl:text>
						</xsl:when>
						<xsl:when test="self::field">
							<xsl:text>#property:</xsl:text>
						</xsl:when>
						<xsl:when test="self::event">
							<xsl:text>#event:</xsl:text>
						</xsl:when>
						<xsl:when test="self::style">
							<xsl:text>#style:</xsl:text>
						</xsl:when>
						<xsl:when test="self::effect">
							<xsl:text>#effect:</xsl:text>
						</xsl:when>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="@name" />
		</xsl:param>
		<xsl:param name="packageName">
			<xsl:if test="ancestor-or-self::asPackage/@name!='$$Global$$'">
				<xsl:value-of select="ancestor-or-self::asPackage/@name" />
			</xsl:if>
		</xsl:param>

		<xsl:variable name="numSees" select="count(sees/see[normalize-space(@label) or @href])" />
		<xsl:if test="$numSees or exslt:nodeSet($xrefs)/helpreferences/helpreference[normalize-space(id/.)=$xrefId]">
			<dl class="sees">
				<dt>See also</dt>
				<xsl:for-each select="sees/see[string-length(@href) or string-length(@label)]">
					<dd>
						<xsl:if test="string-length(@href)">
							<a href="{@href}">
								<xsl:if test="normalize-space(@label)">
									<xsl:value-of select="normalize-space(@label)"/>
								</xsl:if>
								<xsl:if test="not(normalize-space(@label))">
									<xsl:value-of select="@href"/>
								</xsl:if>
							</a>
						</xsl:if>
						<xsl:if test="not(string-length(@href)) and string-length(@label) &gt; 0">
							<span><xsl:value-of select="normalize-space(@label)" /></span>
						</xsl:if>
					</dd>
				</xsl:for-each>
				<xsl:variable name="baseRef">
					<xsl:call-template name="getBaseRef">
						<xsl:with-param name="packageName" select="$packageName" />
					</xsl:call-template>
				</xsl:variable>
				<xsl:for-each select="exslt:nodeSet($xrefs)/helpreferences/helpreference[normalize-space(id/.)=$xrefId]">
					<dd>
						<xsl:if test="string-length(@href)">
							<a href="{concat($baseRef,$config/xrefs/@baseRef,href/.)}">
								<xsl:if test="normalize-space(@label)">
									<xsl:value-of select="normalize-space(@label)"/>
								</xsl:if>
								<xsl:if test="not(normalize-space(@label))">
									<xsl:value-of select="@href"/>
								</xsl:if>
							</a>
						</xsl:if>
						<xsl:if test="not(string-length(@href)) and string-length(@label) &gt; 0">
							<span><xsl:value-of select="normalize-space(@label)" /></span>
						</xsl:if>
					</dd>
				</xsl:for-each>
			</dl>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="getSimpleClassName">
		<xsl:param name="fullClassName"/>
		<xsl:choose>
			<xsl:when test="contains($fullClassName,':')">
				<xsl:call-template name="substring-after-last">
					<xsl:with-param name="input" select="$fullClassName"/>
					<xsl:with-param name="substr" select="':'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($fullClassName,'.')">
				<xsl:call-template name="substring-after-last">
					<xsl:with-param name="input" select="$fullClassName"/>
					<xsl:with-param name="substr" select="'.'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$fullClassName"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:variable name="deprecatedLabel">
		<b>Deprecated</b>
	</xsl:variable>

	<xsl:template match="deprecated">
		<xsl:param name="showDescription" select="'true'"/>

		<xsl:copy-of select="$deprecatedLabel"/>
			<xsl:if test="string-length(@as-of)">
				<xsl:text> since </xsl:text><xsl:value-of select="normalize-space(@as-of)"/>
			</xsl:if>
			<xsl:if test="$showDescription='true' and string-length(normalize-space())">
				<xsl:value-of select="$emdash"/>
				<xsl:call-template name="deTilda">
					<xsl:with-param name="inText" select="normalize-space()"/>
				</xsl:call-template>
			</xsl:if>
		<xsl:if test="$showDescription!='true' or not(string-length(normalize-space()))">
			<xsl:text>.</xsl:text>
		</xsl:if>
		<br />
	</xsl:template>

	<xsl:template match="item" mode="annotate">
		<xsl:for-each select="annotation">
			<xsl:if test="@type='text'">
				<li class="textbox">
					<div class="annotation"><xsl:value-of disable-output-escaping="yes" select="." /></div>
				</li>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="shortDescriptionReview">
		<xsl:if test="(review or customs/review) and $config/options/@showReview='true'">
			<font color="red">Review needed. </font>
		</xsl:if>
	</xsl:template>

	<xsl:template name="getPageTitlePostFix">
		<xsl:if test="string-length($config/pageTitlePostFix/.)">
			<xsl:text> </xsl:text>
			<xsl:value-of select="$config/pageTitlePostFix/." />
		</xsl:if>
	</xsl:template>

	<xsl:template name="addKeywords">
		<xsl:param name="keyword" />
		<xsl:param name="num" select="$config/keywords/@num" />

		<xsl:if test="$config/keywords[@show='true'] and $keyword">
			<div style="display:none">
				<xsl:call-template name="duplicateString">
					<xsl:with-param name="input" select="concat($keyword,' ')" />
					<xsl:with-param name="count" select="$num" />
				</xsl:call-template>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template name="duplicateString">
		<xsl:param name="input" />
		<xsl:param name="count" select="1" />

		<xsl:choose>
			<xsl:when test="not($count) or not($input)" />
			<xsl:when test="$count=1">
				<xsl:value-of select="$input" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$count mod 2">
					<xsl:value-of select="$input" />
				</xsl:if>
				<xsl:call-template name="duplicateString">
					<xsl:with-param name="input" select="concat($input,$input)" />
					<xsl:with-param name="count" select="floor($count div 2)" />
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

 	<xsl:template name="substring-before-last">
		<xsl:param name="input"/>
		<xsl:param name="substr"/>

		<xsl:if test="$substr and contains($input,$substr)">
			<xsl:variable name="tmp" select="substring-after($input,$substr)"/>
			<xsl:value-of select="substring-before($input,$substr)"/>
			<xsl:if test="contains($tmp,$substr)">
				<xsl:value-of select="$substr"/>
				<xsl:call-template name="substring-before-last">
					<xsl:with-param name="input" select="$tmp"/>
					<xsl:with-param name="substr" select="$substr"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template name="substring-after-last">
		<xsl:param name="input"/>
		<xsl:param name="substr"/>

		<xsl:variable name="tmp" select="substring-after($input,$substr)"/>
		<xsl:choose>
			<xsl:when test="$substr and contains($tmp,$substr)">
				<xsl:call-template name="substring-after-last">
					<xsl:with-param name="input" select="$tmp"/>
					<xsl:with-param name="substr" select="$substr"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$tmp"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="search-and-replace">
		<xsl:param name="input"/>
		<xsl:param name="search-string"/>
		<xsl:param name="replace-string"/>

		<xsl:choose>
			<xsl:when test="$search-string and contains($input,$search-string)">
				<xsl:value-of select="substring-before($input,$search-string)"/>
				<xsl:value-of select="$replace-string"/>
				<xsl:call-template name="search-and-replace">
					<xsl:with-param name="input" select="substring-after($input,$search-string)"/>
					<xsl:with-param name="search-string" select="$search-string"/>
					<xsl:with-param name="replace-string" select="$replace-string"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$input"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>