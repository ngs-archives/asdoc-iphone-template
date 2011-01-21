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

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:str="http://exslt.org/strings"
exclude-result-prefixes="str">

	<xsl:import href="asdoc-util.xsl"/>

	<xsl:template name="classInheritance">
		<xsl:param name="baseRef" />
		<xsl:variable name="iconRef" select="concat($baseRef,'images/inherit-arrow.gif')" />

		<xsl:value-of select="@name" />
		<xsl:text> </xsl:text>
		<img src="{$iconRef}" title="Inheritance" alt="Inheritance" class="inheritArrow" />
		<xsl:text> </xsl:text>

		<xsl:for-each select="asAncestors/asAncestor">
            <xsl:if test="(classRef/@relativePath) != 'none'">
 			    <a href="{translate(classRef/@relativePath,':','/')}">
			  	  <xsl:value-of select="classRef/@name"/> 
				</a>
            </xsl:if>
            <xsl:if test="(classRef/@relativePath) = 'none'">
			    <xsl:value-of select="classRef/@name"/> 
            </xsl:if>
			<xsl:if test="position() != last()">
				<xsl:text> </xsl:text>
				<img src="{$iconRef}" title="Inheritance" alt="Inheritance" class="inheritArrow" />
				<xsl:text> </xsl:text>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="defaultProperty">
		<table class="class-info">
			<tr>
				<th>Default MXML Property</th>
				<td>
					<code><xsl:value-of select="@name" /></code>
				</td>
			</tr>
		</table>
	</xsl:template>

	<xsl:template name="classHeader">
		<xsl:param name="classDeprecated" />
		<xsl:variable name="baseRef">
			<xsl:call-template name="getBaseRef">
				<xsl:with-param name="packageName" select="@packageName" />
			</xsl:call-template>
		</xsl:variable>

		<ul class="pageitem" id="class-header">
			<xsl:variable name="name" select="@name" />
			<xsl:variable name="packageName" select="@packageName" />
			<xsl:call-template name="getTextBox">
				<xsl:with-param name="content">
					<span class="header">
						<xsl:if test="@type='interface'">
							<xsl:value-of select="concat('Interface',$nbsp,@name)" />
						</xsl:if>
						<xsl:if test="@type!='interface'">
							<xsl:value-of select="concat('Class',$nbsp,@name)" />
						</xsl:if>
					</span>
					<xsl:apply-templates mode="annotate" select="$config/annotate/item[@type='class' and ((@name=$name and (not(string-length(@packageName)) or @packageName=$packageName)) or (not(string-length(@name)) and string-length(@packageName) and str:tokenize(@packageName,',')[starts-with($packageName,.)]))]" />
					<table class="class-info">
						<tr class="package">
							<th>Package</th>
							<td>
								<a href="package-detail.html">
									<xsl:if test="string-length(@packageName) &gt; 0"><xsl:value-of select="@packageName"/></xsl:if>
									<xsl:if test="string-length(@packageName) = 0"><xsl:text>Top Level</xsl:text></xsl:if>
								</a>
							</td>
						</tr>
						<tr class="sign">
							<th>
								<xsl:if test="@type='class'">
									<xsl:text>Class</xsl:text>
								</xsl:if>
								<xsl:if test="@type='interface'">
									<xsl:text>Intereface</xsl:text>
								</xsl:if>
							</th>
							<td>
								<xsl:value-of select="@accessLevel"/>
								<xsl:if test="@isFinal='true'">
									<xsl:text> final </xsl:text>
								</xsl:if>
								<xsl:if test="@isDynamic='true'">
									<xsl:text> dynamic </xsl:text>
								</xsl:if>
								<xsl:text> </xsl:text>
								<xsl:value-of select="@type" />
								<xsl:text> </xsl:text>
								<xsl:value-of select="@name"/>
								<xsl:if test="@type='interface' and asAncestors/asAncestor">
									<xsl:text> extends </xsl:text>
									<xsl:for-each select="asAncestors/asAncestor">
										<a href="{classRef/@relativePath}">
											<xsl:value-of select="classRef/@name" />
										</a>
										<xsl:if test="position()!=last()">
											<xsl:text>, </xsl:text>
										</xsl:if>
									</xsl:for-each>
								</xsl:if>
							</td>
						</tr>
						<xsl:if test="@type!='interface' and asAncestors/asAncestor">
							<tr class="inheritance">
								<th>Inheritance</th>
								<td>
									<xsl:call-template name="classInheritance">
										<xsl:with-param name="baseRef" select="$baseRef" />
									</xsl:call-template>
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="asImplements/asAncestor">
							<tr class="implements">
								<th>Implements</th>
								<td>
									<xsl:for-each select="asImplements/asAncestor">
										<xsl:sort select="classRef/@name"/>
										<xsl:if test="(classRef/@relativePath) != 'none'">
								 			<a href="{translate(classRef/@relativePath,':','/')}">
												<xsl:value-of select="classRef/@name"/>
											</a>
										</xsl:if>
										<xsl:if test="(classRef/@relativePath) = 'none'">
											<xsl:value-of select="classRef/@name"/>
										</xsl:if>
										<xsl:if test="position() != last()">
											<xsl:text>, </xsl:text>
										</xsl:if>
									</xsl:for-each>
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="asDecendants/classRef">
							<tr class="decendants">
								<th>
									<xsl:if test="@type='interface'">
										<xsl:text>Subinterfaces</xsl:text>
									</xsl:if>
									<xsl:if test="@type!='interface'">
										<xsl:text>Subclasses</xsl:text>
									</xsl:if>
								</th>
								<td>
									<xsl:for-each select="asDecendants/classRef">
										<xsl:sort select="@name"/>
										<a href="{translate(@relativePath,':','/')}">
											<xsl:value-of select="@name"/>
										</a>
										<xsl:if test="position() != last()">
											<xsl:text>, </xsl:text>
										</xsl:if>
									</xsl:for-each>
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="implementers/classRef">
							<tr class="implementers">
								<th>Implementors</th>
								<td>
									<xsl:for-each select="implementers/classRef">
										<xsl:sort select="@name"/>
										<a href="{translate(@relativePath,':','/')}">
											<xsl:value-of select="@name"/>
										</a>
										<xsl:if test="position() != last()">
											<xsl:text>, </xsl:text>
										</xsl:if>
									</xsl:for-each>
								</td>
							</tr>
						</xsl:if>
					</table>
					<xsl:call-template name="version"/>
					<xsl:apply-templates select="defaultProperty" />
					<xsl:apply-templates select="example"/>
					<xsl:call-template name="includeExampleLink"/>
					<xsl:call-template name="sees">
						<xsl:with-param name="labelClass" select="'classHeaderTableLabel'" />
					</xsl:call-template>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:if test="customs/mxml">
				<xsl:call-template name="getTextBox">
					<xsl:with-param name="class" select="'textbox thintop'" />
					<xsl:with-param name="content">
						<dl class="sees" id="mxmlSyntax">
							<dt>
								<span class="t">
									<xsl:text>MXML Syntax </xsl:text>
								</span>
								<span class="showButton showHideButton">
									<a href="#mxmlSyntaxSummary" onclick="toggleMXMLOnly();">
										<img src="{$baseRef}images/collapsed.gif" title="collapsed" alt="collapsed" class="collapsedImage" />
										<xsl:text> Show MXML Syntax</xsl:text>
									</a>
								</span>
								<span class="hideButton showHideButton">
									<a href="#mxmlSyntaxSummary" onclick="toggleMXMLOnly();">
										<img src="{$baseRef}images/expanded.gif" title="expanded" alt="expanded" class="expandedImage" />
										<xsl:text> Hide MXML Syntax</xsl:text>
									</a>
								</span>
							</dt>
							<dd class="hiddenBlockTarget">
								<code><xsl:value-of disable-output-escaping="yes" select="customs/mxml/." /></code>
							</dd>
						</dl>
						<xsl:call-template name="getInlineScript">
							<xsl:with-param name="script">setMXMLOnly();</xsl:with-param>
						</xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			<xsl:call-template name="getTextBox">
				<xsl:with-param name="class" select="'textbox thintop'" />
				<xsl:with-param name="content">
					<xsl:if test="$classDeprecated='true'">
						<xsl:apply-templates select="deprecated"/>
						<br/>
					</xsl:if>
					<xsl:call-template name="description"/>
				</xsl:with-param>
			</xsl:call-template>
		</ul>
	</xsl:template>

	<xsl:template name="showHideLinks">
		<xsl:param name="baseRef" />
		<xsl:param name="title" />
		<xsl:param name="id" />
		<xsl:call-template name="getTextBox">
			<xsl:with-param name="class" select="'showHideLinks textbox'" />
			<xsl:with-param name="content">
				<span class="hideButton showHideButton">
					<a href="#summaryTable{$id}" onclick="javascript:setInheritedVisible(false,'{$id}');"><img class="showHideLinkImage" src="{$baseRef}images/expanded.gif" /><xsl:value-of select="concat(' Hide Inherited ', $title)" /></a>
				</span>
				<span class="showButton showHideButton">
					<a href="#summaryTable{$id}" onclick="javascript:setInheritedVisible(true,'{$id}');"><img class="showHideLinkImage" src="{$baseRef}images/collapsed.gif" /><xsl:value-of select="concat(' Show Inherited ', $title)" /></a>
				</span>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="definedByTable">
		<xsl:param name="td" />
		<xsl:if test="string-length($td)&gt;0">
			<table class="class-info">
				<tr class="defined">
					<th>Defined by</th>
					<td><xsl:copy-of select="$td" /></td>
				</tr>
			</table>
		</xsl:if>
	</xsl:template>

	<!-- FIELDS -->
	<xsl:template name="fieldSummary">
		<xsl:param name="classDeprecated" select="false()"/>
		<xsl:param name="isConst" select="'false'" />
		<xsl:param name="accessLevel" select="'public'" />
		<xsl:param name="baseRef" select="''" />
		<xsl:param name="isGlobal" select="false()" />
		<xsl:param name="showAnchor" select="true()" />

		<xsl:variable name="hasFields" select="count(fields/field[@isConst=$isConst and (@accessLevel=$accessLevel or @accessLevel=$config/namespaces/namespace[@summaryDisplay=$accessLevel]/.)]) &gt; 0" />
		<xsl:variable name="hasInherited" select="count(asAncestors/asAncestor/fields/field[@isConst=$isConst and (@accessLevel=$accessLevel or @accessLevel=$config/namespaces/namespace[@summaryDisplay=$accessLevel]/.)]) &gt; 0" />

		<xsl:variable name="hasPublic">
			<xsl:if test="$accessLevel='protected'">
				<xsl:value-of select="count(fields/field[@isConst=$isConst and (@accessLevel='public' or @accessLevel=$config/namespaces/namespace[@summaryDisplay='public']/.)]) &gt; 0 or count(asAncestors/asAncestor/fields/field[@isConst=$isConst and (@accessLevel='public' or @accessLevel=$config/namespaces/namespace[@summaryDisplay='public']/.)]) &gt; 0" />
			</xsl:if>
			<xsl:if test="not($accessLevel='protected')">
				<xsl:value-of select="false()" />
			</xsl:if>
		</xsl:variable>

		<xsl:variable name="fieldId">
			<xsl:if test="$accessLevel='protected'">
				<xsl:text>Protected</xsl:text>
			</xsl:if>
			<xsl:if test="$isConst='true'">
				<xsl:text>Constant</xsl:text>
			</xsl:if>
			<xsl:if test="$isConst='false'">
				<xsl:text>Property</xsl:text>
			</xsl:if>
		</xsl:variable>

		<xsl:variable name="tableId">
			<xsl:value-of select="concat('summaryTable',$fieldId)" />
		</xsl:variable>

		<xsl:if test="$hasFields or $hasInherited">
			
			<xsl:variable name="fieldTitle">
				<xsl:choose>
					<xsl:when test="$isGlobal">
						<xsl:text>Global </xsl:text>
					</xsl:when>
					<xsl:when test="$accessLevel='public'">
						<xsl:text>Public </xsl:text>
					</xsl:when>
					<xsl:when test="$accessLevel='protected'">
						<xsl:text>Protected </xsl:text>
					</xsl:when>
				</xsl:choose>
				<xsl:if test="$isConst='true'">
					<xsl:text>Constants</xsl:text>
				</xsl:if>
				<xsl:if test="$isConst='false'">
					<xsl:text>Properties</xsl:text>
				</xsl:if>
			</xsl:variable>
			
			<span class="graytitle">
				<xsl:value-of select="$fieldTitle" />
			</span>
			
			<ul class="pageitem class-list" id="{$tableId}">
				<xsl:if test="$hasInherited">
					<xsl:call-template name="showHideLinks">
						<xsl:with-param name="id" select="$fieldId" />
						<xsl:with-param name="title" select="$fieldTitle" />
						<xsl:with-param name="baseRef" select="$baseRef" />
					</xsl:call-template>
				</xsl:if>
				<xsl:for-each select="fields/field[@isConst=$isConst and (@accessLevel=$accessLevel or @accessLevel=$config/namespaces/namespace[@summaryDisplay=$accessLevel]/.)] | asAncestors/asAncestor/fields/field[@isConst=$isConst and (@accessLevel=$accessLevel or @accessLevel=$config/namespaces/namespace[@summaryDisplay=$accessLevel]/.)]">
					<xsl:sort select="translate(@name,'_','')" order="ascending" data-type="text"/>
					<xsl:variable name="rowStyle">
						<xsl:if test="ancestor::asAncestor">
							<xsl:text>hideInherited</xsl:text>
							<xsl:if test="$accessLevel='protected'">
								<xsl:text>Protected</xsl:text>
							</xsl:if>
							<xsl:if test="$isConst='true'">
								<xsl:text>Constant</xsl:text>
							</xsl:if>
							<xsl:if test="$isConst='false'">
								<xsl:text>Property</xsl:text>
							</xsl:if>
						</xsl:if>
					</xsl:variable>
					<xsl:call-template name="getTextBox">
						<xsl:with-param name="class">
							<xsl:text>textbox</xsl:text>
							<xsl:if test="ancestor::asAncestor">
								<xsl:text> hiddenBlockTarget</xsl:text>
							</xsl:if>
						</xsl:with-param>
						<xsl:with-param name="content">
							<p>
								<a class="signatureLink" href="{concat(ancestor::asAncestor/classRef/@relativePath,'#',@name)}">
									<xsl:if test="ancestor::asAncestor">
										<xsl:call-template name="getInheritedIcon">
											<xsl:with-param name="baseRef" select="$baseRef" />
										</xsl:call-template>
									</xsl:if>
									<span class="name"><xsl:value-of select="@name" /></span>
								</a>
								<xsl:if test="@type">
									<xsl:text>:</xsl:text>
									<span class="type">
										<xsl:choose>
											<xsl:when test="classRef">
												<a href="{classRef/@relativePath}">
													<xsl:call-template name="getSimpleClassName">
														<xsl:with-param name="fullClassName" select="@type"/>
													</xsl:call-template>
												</a>
											</xsl:when>
											<xsl:when test="@type='' or @type='*'">
												<xsl:call-template name="getSpecialTypeLink">
													<xsl:with-param name="type" select="'*'" />
												</xsl:call-template>
											</xsl:when>
											<xsl:otherwise>
												<xsl:call-template name="getSimpleClassName">
													<xsl:with-param name="fullClassName" select="@type"/>
												</xsl:call-template>
											</xsl:otherwise>
										</xsl:choose>
									</span>
								</xsl:if>
								<xsl:if test="(string-length(@defaultValue) or @type='String') and @defaultValue!='unknown'">
									<span class="defaultValue">
										<br />
										<xsl:text> = </xsl:text>
										<xsl:if test="@type='String'">
											<xsl:text>"</xsl:text>
										</xsl:if>
										<xsl:value-of select="@defaultValue" />
										<xsl:if test="@type='String'">
											<xsl:text>"</xsl:text>
										</xsl:if>
									</span>
								</xsl:if>
							</p>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="getTextBox">
						<xsl:with-param name="class">
							<xsl:text>textbox thintop</xsl:text>
							<xsl:if test="ancestor::asAncestor">
								<xsl:text> hiddenBlockTarget</xsl:text>
							</xsl:if>
						</xsl:with-param>
						<xsl:with-param name="content">
							<div class="summaryTableDescription">
								<xsl:apply-templates select="deprecated"/>
								<xsl:if test="not(deprecated)">
									<xsl:if test="@isStatic='true'">
										<span class="only">static</span>
									</xsl:if>
									<xsl:if test="string-length(@only) and not(@only='read-write')">
										<span class="only">
											<xsl:value-of select="@only"/>
											<xsl:text>-only</xsl:text>
										</span>
									</xsl:if>
									<xsl:call-template name="shortDescription">
										<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
									</xsl:call-template>
								</xsl:if>
							</div>
							<xsl:if test="not($config/options/@docversion='2')">
								<xsl:call-template name="definedByTable">
									<xsl:with-param name="td">
										<xsl:choose>
											<xsl:when test="ancestor::asAncestor">
												<a href="{ancestor::asAncestor/classRef/@relativePath}">
													<xsl:value-of select="ancestor::asAncestor/classRef/@name" />
												</a>
											</xsl:when>
											<xsl:when test="ancestor::asClass">
												<xsl:value-of select="ancestor::asClass/@name" />
											</xsl:when>
											<xsl:when test="ancestor::asPackage">
												<xsl:if test="ancestor::asPackage/@name='$$Global$$'">
													<xsl:value-of select="concat('Top',$nbsp,'Level')" />
												</xsl:if>
												<xsl:if test="ancestor::asPackage/@name!='$$Global$$'">
													<xsl:value-of select="ancestor::asPackage/@name" />
												</xsl:if>
											</xsl:when>
										</xsl:choose>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:if>
							<!-- AS2 INHERITED PROPERTIES -->
							<xsl:if test="$config/options/@docversion='2'">
								<xsl:for-each select="asAncestors/asAncestor">
								    <xsl:call-template name="inherited">
									    <xsl:with-param name="lowerType">properties</xsl:with-param>
									    <xsl:with-param name="upperType">Properties</xsl:with-param>
									    <xsl:with-param name="inheritedItems" select="@properties" />
									    <xsl:with-param name="staticItems" select="@staticProperties" />
									</xsl:call-template>
								</xsl:for-each>
	        			    </xsl:if>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
			</ul>
		</xsl:if>
	</xsl:template>

	<xsl:template match="fields" mode="detail">
		<xsl:param name="classDeprecated" select="'false'"/>
		<xsl:param name="isConst" select="'false'" />
		<xsl:param name="baseRef" />

		<xsl:if test="count(field[@isConst=$isConst]) &gt; 0">
			<span class="graytitle">
				<xsl:attribute name="id">
					<xsl:if test="$isConst='true'">
						<xsl:text>constantDetail</xsl:text>
					</xsl:if>
					<xsl:if test="not($isConst='true')">
						<xsl:text>propertyDetail</xsl:text>
					</xsl:if>
				</xsl:attribute>
				<xsl:if test="$isConst='true'">
					<xsl:text>Constant detail</xsl:text>
				</xsl:if>
				<xsl:if test="not($isConst='true')">
					<xsl:text>Property detail</xsl:text>
				</xsl:if>
			</span>
			<ul class="pageitem">
				<xsl:for-each select="field[@isConst=$isConst]">
					<xsl:sort select="translate(@name,'_','')" order="ascending"/>
					<xsl:call-template name="getTextBox">
						<xsl:with-param name="id" select="@name" />
						<xsl:with-param name="content">
							<span class="header">
								<span class="name">
									<xsl:value-of select="concat(@name,' ')" />
								</span>
								<span class="type">
									<xsl:if test="@isConst='true'">
										<xsl:text>constant</xsl:text>
									</xsl:if>
									<xsl:if test="@isConst!='true'">
										<xsl:text>property</xsl:text>	
									</xsl:if>
								</span>
							</span>
							<code class="sign">
								<xsl:if test="string-length(@only)">
									<xsl:value-of select="@name" />
								</xsl:if>
								<xsl:if test="not(string-length(@only))">
									<xsl:call-template name="getNamespaceLink">
										<xsl:with-param name="accessLevel" select="@accessLevel" />
										<xsl:with-param name="baseRef" select="$baseRef" />
									</xsl:call-template>
									<xsl:text> </xsl:text>
									<xsl:if test="@isStatic='true'">
										<xsl:text>static </xsl:text>
									</xsl:if>
									<xsl:choose>
										<xsl:when test="@isConst='true' and $config/options/@docversion='3'">
											<xsl:text>const </xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>var </xsl:text>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:value-of select="@name"/>
								</xsl:if>
								<xsl:if test="@type">
									<xsl:text>:</xsl:text>
									<xsl:choose>
										<xsl:when test="classRef">
											<a href="{classRef/@relativePath}">
												<xsl:call-template name="getSimpleClassName">
													<xsl:with-param name="fullClassName" select="@type"/>
												</xsl:call-template>
											</a>
										</xsl:when>
										<xsl:when test="@type='' or @type='*'">
											<xsl:call-template name="getSpecialTypeLink">
												<xsl:with-param name="type" select="'*'" />
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="getSimpleClassName">
												<xsl:with-param name="fullClassName" select="@type"/>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
								<xsl:if test="(string-length(@defaultValue) or @type='String') and @defaultValue!='unknown'">
									<xsl:text> = </xsl:text>
									<xsl:if test="@type='String'">
										<xsl:text>"</xsl:text>
									</xsl:if>
									<xsl:value-of select="@defaultValue" />
									<xsl:if test="@type='String'">
										<xsl:text>"</xsl:text>
									</xsl:if>
								</xsl:if>
							</code>
							<xsl:if test="string-length(@only)">
								<span class="only">
									<xsl:value-of select="@only"/>
									<xsl:if test="not(@only='read-write')">
										<xsl:text>-only</xsl:text>
									</xsl:if>
								</span>
							</xsl:if>
							<xsl:apply-templates select="deprecated"/>
							<xsl:if test="$classDeprecated='true'">
								<xsl:call-template name="description">
									<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
									<xsl:with-param name="addParagraphTags" select="true()" />
								</xsl:call-template>
							</xsl:if>
							<xsl:if test="$classDeprecated!='true'">
								<xsl:call-template name="description">
									<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
									<xsl:with-param name="addParagraphTags" select="true()" />
								</xsl:call-template>
							</xsl:if>
							<xsl:if test="customs/default">
								<p>
									<xsl:text>The default value is </xsl:text>
									<code>
										<xsl:value-of select="normalize-space(customs/default/.)" />
									</code>
									<xsl:text>.</xsl:text>
								</p>
							</xsl:if>
							<xsl:if test="@isBindable='true'">
								<p>
									<xsl:text>This property can be used as the source for data binding.</xsl:text>
								</p>
							</xsl:if>

							<xsl:call-template name="version"/>		
							<xsl:if test="string-length(@only)">
								<dl class="sees">
									<dt>Implementation</dt>
									<xsl:if test="contains(@only,'read')">
										<dd>
											<code>
												<xsl:call-template name="getNamespaceLink">
													<xsl:with-param name="accessLevel" select="@accessLevel" />
													<xsl:with-param name="baseRef" select="$baseRef" />
												</xsl:call-template>
												<xsl:text> </xsl:text>
												<xsl:if test="@isStatic='true'">
													<xsl:text>static </xsl:text>
												</xsl:if>
												<xsl:text>function get </xsl:text>
												<xsl:value-of select="@name" />
												<xsl:text>():</xsl:text>
												<xsl:choose>
													<xsl:when test="classRef">
														<a href="{classRef/@relativePath}">
															<xsl:call-template name="getSimpleClassName">
																<xsl:with-param name="fullClassName" select="@type"/>
															</xsl:call-template>
														</a>
													</xsl:when>
													<xsl:when test="@type='' or @type='*'">
														<xsl:call-template name="getSpecialTypeLink">
															<xsl:with-param name="type" select="'*'" />
														</xsl:call-template>
													</xsl:when>
													<xsl:otherwise>
														<xsl:call-template name="getSimpleClassName">
															<xsl:with-param name="fullClassName" select="@type"/>
														</xsl:call-template>
													</xsl:otherwise>
												</xsl:choose>
											</code>
										</dd>
									</xsl:if>
									<xsl:if test="contains(@only,'write')">
										<dd>
											<code>
												<xsl:call-template name="getNamespaceLink">
													<xsl:with-param name="accessLevel" select="@accessLevel" />
													<xsl:with-param name="baseRef" select="$baseRef" />
												</xsl:call-template>
												<xsl:text> </xsl:text>
												<xsl:text>function set </xsl:text>
												<xsl:value-of select="@name" />
												<xsl:text>(value:</xsl:text>
												<xsl:choose>
													<xsl:when test="classRef">
														<a href="{classRef/@relativePath}">
															<xsl:call-template name="getSimpleClassName">
																<xsl:with-param name="fullClassName" select="@type"/>
															</xsl:call-template>
														</a>
													</xsl:when>
													<xsl:when test="@type='' or @type='*'">
														<xsl:call-template name="getSpecialTypeLink">
															<xsl:with-param name="type" select="'*'" />
														</xsl:call-template>
													</xsl:when>
													<xsl:otherwise>
														<xsl:call-template name="getSimpleClassName">
															<xsl:with-param name="fullClassName" select="@type"/>
														</xsl:call-template>
													</xsl:otherwise>
												</xsl:choose>
												<xsl:text>):</xsl:text>
												<xsl:call-template name="getSpecialTypeLink">
													<xsl:with-param name="type" select="'void'" />
												</xsl:call-template>
											</code>
										</dd>
									</xsl:if>
								</dl>
							</xsl:if>
		
							<xsl:if test="canThrow">
								<dl class="sees">
									<dt>Throws</dt>
									<xsl:apply-templates select="canThrow"/>
								</dl>
							</xsl:if>
		
							<xsl:call-template name="sees" />
							<xsl:apply-templates select="example | includeExamples/includeExample[codepart]"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
			</ul>
		</xsl:if>
	</xsl:template>

	<!-- STYLES -->
	<xsl:template name="stylesSummary">
		<xsl:param name="classDeprecated" select="'false'" />
		<xsl:param name="baseRef" select="''" />

		<xsl:variable name="hasStyles" select="count(styles/style) &gt; 0" />
		<xsl:variable name="hasInherited" select="count(asAncestors/asAncestor/styles/style) &gt; 0" />
		<xsl:if test="$hasStyles or $hasInherited">
			<span class="graytitle" id="styleSummary">Styles</span>
			<ul class="pageitem" id="summaryTableStyle">
				<xsl:if test="$hasInherited">
					<xsl:call-template name="showHideLinks">
						<xsl:with-param name="id" select="'Style'" />
						<xsl:with-param name="title" select="'Styles'" />
						<xsl:with-param name="baseRef" select="$baseRef" />
					</xsl:call-template>
				</xsl:if>
				<xsl:for-each select="styles/style | asAncestors/asAncestor/styles/style">
					<xsl:sort select="@name" order="ascending" data-type="text"/>
					<xsl:call-template name="getTextBox">
						<xsl:with-param name="id" select="concat('style:',@name)" />
						<xsl:with-param name="class">
							<xsl:text>textbox</xsl:text>
							<xsl:if test="ancestor::asAncestor">
								<xsl:text> hiddenBlockTarget</xsl:text>
							</xsl:if>
						</xsl:with-param>
						<xsl:with-param name="content">
							<p>
								<xsl:choose>
									<xsl:when test="ancestor::asAncestor">
										<a href="{ancestor::asAncestor/classRef/@relativePath}#style:{@name}" class="signatureLink">
											<xsl:call-template name="getInheritedIcon">
												<xsl:with-param name="baseRef" select="$baseRef" />
											</xsl:call-template>
											<span class="name"><xsl:value-of select="@name" /></span>
										</a>
									</xsl:when>
									<xsl:when test="ancestor::asClass">
										<span class="signatureLink">
											<span class="name"><xsl:value-of select="@name" /></span>
										</span>
									</xsl:when>
								</xsl:choose>
							</p>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="getTextBox">
						<xsl:with-param name="class">
							<xsl:text>textbox thintop</xsl:text>
							<xsl:if test="ancestor::asAncestor">
								<xsl:text> hiddenBlockTarget</xsl:text>
							</xsl:if>
						</xsl:with-param>
						<xsl:with-param name="content">
							<xsl:if test="string-length(normalize-space(@type)) &gt; 0">
								<dl class="sees">
									<dt>Type</dt>
									<dd>
										<xsl:if test="string-length(@typeHref)">
											<xsl:variable name="baseRef">
												<xsl:call-template name="getBaseRef">
													<xsl:with-param name="packageName" select="../../@packageName" />
												</xsl:call-template>
												<xsl:if test="contains(@type,'.')">
													<xsl:variable name="package">
														<xsl:call-template name="substring-before-last">
															<xsl:with-param name="input" select="@type" />
															<xsl:with-param name="substr" select="'.'" />
														</xsl:call-template>
													</xsl:variable>
													<xsl:value-of select="translate($package,'.','/')" />
													<xsl:text>/</xsl:text>
												</xsl:if>
											</xsl:variable>
											<a href="{@typeHref}" onclick="loadClassListFrame('{$baseRef}class-list.html')">
												<xsl:value-of select="normalize-space(@type)"/>
											</a>
										</xsl:if>
										<xsl:if test="not(string-length(@typeHref))">
											<xsl:if test="@type='' or @type='*'">
												<xsl:call-template name="getSpecialTypeLink">
													<xsl:with-param name="type" select="'*'" />
												</xsl:call-template>
											</xsl:if>
											<xsl:if test="@type!='' and @type!='*'">
												<xsl:value-of select="normalize-space(@type)" />
											</xsl:if>
										</xsl:if>
									</dd>
								</dl>
							</xsl:if>
							<xsl:if test="string-length(normalize-space(@format)) &gt; 0">
								<dl class="sees">
									<dt>Format</dt>
									<dd>
										<xsl:value-of select="normalize-space(@format)"/>
										<xsl:if test="string-length(normalize-space(@inherit)) &gt; 0">
											<xsl:text disable-output-escaping="yes"> <![CDATA[&nbsp;]]> </xsl:text>
										</xsl:if>
									</dd>
								</dl>
							</xsl:if>
							<xsl:if test="string-length(normalize-space(@inherit)) &gt; 0">
								<dl class="sees">
									<dt>CSS Inheritance</dt>
									<dd>
										<xsl:value-of select="normalize-space(@inherit)"/>
									</dd>
								</dl>
							</xsl:if>
							<xsl:if test="not(ancestor::asAncestor)">
								<xsl:call-template name="shortDescriptionReview" />
								<xsl:call-template name="deTilda">
									<xsl:with-param name="inText" select="description/."/>
								</xsl:call-template>
								<xsl:if test="default">
										<xsl:text> The default value is </xsl:text>
										<code>
											<xsl:value-of select="normalize-space(default/.)" />
										</code>
										<xsl:text>.</xsl:text>
								</xsl:if>
							</xsl:if>
							<xsl:if test="ancestor::asAncestor and string-length(shortDescription/.)">
								<xsl:call-template name="deTilda">
									<xsl:with-param name="inText" select="shortDescription" />
								</xsl:call-template>
							</xsl:if>
							<xsl:call-template name="definedByTable">
								<xsl:with-param name="td">
									<xsl:choose>
										<xsl:when test="ancestor::asAncestor">
											<a href="{ancestor::asAncestor/classRef/@relativePath}">
												<xsl:value-of select="ancestor::asAncestor/classRef/@name" />
											</a>
										</xsl:when>
										<xsl:when test="ancestor::asClass">
											<xsl:value-of select="ancestor::asClass/@name" />
										</xsl:when>
									</xsl:choose>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
			</ul>
		</xsl:if>
	</xsl:template>

	<!-- EFFECTS -->
	<xsl:template name="effectsSummary">
		<xsl:param name="classDeprecated" select="'false'"/>
		<xsl:param name="baseRef" select="''" />

		<xsl:variable name="hasEffects" select="count(effects/effect) &gt; 0" />
		<xsl:variable name="hasInherited" select="count(asAncestors/asAncestor/effects/effect) &gt; 0" />
		<xsl:if test="$hasEffects or $hasInherited">
			<span id="effectSummary" class="graytitle">
				<xsl:text>Effects</xsl:text>
			</span>
			<ul class="pageitem" id="summaryTableEffect">
				<xsl:if test="$hasInherited">
					<xsl:call-template name="showHideLinks">
						<xsl:with-param name="id" select="'Effect'" />
						<xsl:with-param name="title" select="'Effects'" />
						<xsl:with-param name="baseRef" select="$baseRef" />
					</xsl:call-template>
				</xsl:if>
				<xsl:for-each select="effects/effect | asAncestors/asAncestor/effects/effect">
					<xsl:sort select="@name" order="ascending" data-type="text"/>
					<xsl:call-template name="getTextBox">
						<xsl:with-param name="id" select="concat('effect:',@name)" />
						<xsl:with-param name="class">
							<xsl:text>textbox</xsl:text>
							<xsl:if test="ancestor::asAncestor">
								<xsl:text> hiddenBlockTarget</xsl:text>
							</xsl:if>
						</xsl:with-param>
						<xsl:with-param name="id" select="concat('effect:',@name)" />
						<xsl:with-param name="content">
							<p>
								<xsl:choose>
									<xsl:when test="ancestor::asAncestor">
										<a href="{ancestor::asAncestor/classRef/@relativePath}#effect:{@name}" class="signatureLink">
											<xsl:call-template name="getInheritedIcon">
												<xsl:with-param name="baseRef" select="$baseRef" />
											</xsl:call-template>
											<span class="name"><xsl:value-of select="@name" /></span>
										</a>
									</xsl:when>
									<xsl:when test="ancestor::asClass">
										<span class="signatureLink">
											<span class="name"><xsl:value-of select="@name" /></span>
										</span>
									</xsl:when>
								</xsl:choose>
							</p>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="getTextBox">
						<xsl:with-param name="class">
							<xsl:text>textbox</xsl:text>
							<xsl:if test="ancestor::asAncestor">
								<xsl:text> hiddenBlockTarget</xsl:text>
							</xsl:if>
						</xsl:with-param>
						<xsl:with-param name="content">
							<xsl:if test="string-length(@event)">
								<span class="label">Triggering event: </span>
								<xsl:variable name="event" select="@event" />
								<xsl:choose>
									<xsl:when test="ancestor::asClass/eventsGenerated/event[@name=$event]">
										<a href="#event:{@event}">
											<xsl:value-of select="@event" />
										</a>
									</xsl:when>
									<xsl:when test="ancestor::asClass/asAncestors/asAncestor/eventsGenerated/event[@name=$event]">
										<a href="{ancestor::asClass/asAncestors/asAncestor[eventsGenerated/event/@name=$event]/classRef/@relativePath}#event:{@event}">
											<xsl:value-of select="@event" />
										</a>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="@event" />
									</xsl:otherwise>
								</xsl:choose>
								<br />
							</xsl:if>
							<xsl:if test="not(ancestor::asAncestor)">
								<xsl:call-template name="deTilda">
									<xsl:with-param name="inText" select="description/."/>
								</xsl:call-template>
							</xsl:if>
							<xsl:if test="ancestor::asAncestor">
								<xsl:call-template name="shortDescription" />
							</xsl:if>
							<xsl:call-template name="definedByTable">
								<xsl:with-param name="td">
									<xsl:choose>
										<xsl:when test="ancestor::asAncestor">
											<a href="{ancestor::asAncestor/classRef/@relativePath}">
												<xsl:value-of select="ancestor::asAncestor/classRef/@name" />
											</a>
										</xsl:when>
										<xsl:when test="ancestor::asClass">
											<xsl:value-of select="ancestor::asClass/@name" />
										</xsl:when>
									</xsl:choose>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
			</ul>
		</xsl:if>
	</xsl:template>

	<!-- EVENTS -->
	<xsl:template name="eventsGeneratedSummary">
		<xsl:param name="classDeprecated" select="'false'" />
		<xsl:param name="baseRef" select="''" />

		<xsl:variable name="hasEvents" select="count(eventsGenerated/event) &gt; 0" />
		<xsl:variable name="hasInherited" select="count(asAncestors/asAncestor/eventsGenerated/event) &gt; 0" />
		<xsl:if test="$hasEvents or $hasInherited">
			<span class="graytitle" id="eventSummary">Events</span>
			<ul class="pageitem" id="eventSummaryTable">
				<xsl:if test="$hasInherited">
					<xsl:call-template name="showHideLinks">
						<xsl:with-param name="id" select="'event'" />
						<xsl:with-param name="title" select="'Events'" />
						<xsl:with-param name="baseRef" select="$baseRef" />
					</xsl:call-template>
				</xsl:if>
				<xsl:for-each select="eventsGenerated/event | asAncestors/asAncestor/eventsGenerated/event">
					<xsl:sort select="@name" order="ascending" data-type="text"/>
					<xsl:call-template name="getTextBox">
						<xsl:with-param name="class">
							<xsl:text>textbox</xsl:text>
							<xsl:if test="ancestor::asAncestor">
								<xsl:text> hiddenBlockTarget</xsl:text>
							</xsl:if>
						</xsl:with-param>
						<xsl:with-param name="content">
							<p>
								<a class="signatureLink">
									<xsl:attribute name="href">
										<xsl:choose>
											<xsl:when test="ancestor::asAncestor">
												<xsl:value-of select="concat(ancestor::asAncestor/classRef/@relativePath,'#event:',@name)" />
											</xsl:when>
											<xsl:when test="ancestor::asClass">
												<xsl:value-of select="concat('#event:',@name)" />
											</xsl:when>
										</xsl:choose>
										<xsl:if test="ancestor::asAncestor">
											<xsl:call-template name="getInheritedIcon">
												<xsl:with-param name="baseRef" select="$baseRef" />
											</xsl:call-template>
										</xsl:if>
									</xsl:attribute>
									<xsl:value-of select="@name" />
								</a>
							</p>
							<xsl:if test="$config/options/@docversion='2'">
								<code class="sign">
									<xsl:text> = function(</xsl:text>
									<xsl:call-template name="params" />
									<xsl:text>) {}</xsl:text>
								</code>
							</xsl:if>
							<xsl:if test="$classDeprecated='true'">
								<xsl:copy-of select="$deprecatedLabel" />
								<xsl:text>. </xsl:text>
							</xsl:if>
							<xsl:if test="string-length(normalize-space(shortDescription/.))">
								<xsl:call-template name="deTilda">
									<xsl:with-param name="inText" select="shortDescription" />
								</xsl:call-template>
							</xsl:if>
							<xsl:call-template name="definedByTable">
								<xsl:with-param name="td">
									<xsl:choose>
										<xsl:when test="ancestor::asAncestor">
											<a href="{ancestor::asAncestor/classRef/@relativePath}">
												<xsl:value-of select="ancestor::asAncestor/classRef/@name" />
											</a>
										</xsl:when>
										<xsl:when test="ancestor::asClass">
											<xsl:value-of select="ancestor::asClass/@name" />
										</xsl:when>
									</xsl:choose>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
			</ul>
		</xsl:if>
	</xsl:template>

	<xsl:template match="eventsGenerated" mode="detail">
		<xsl:param name="classDeprecated" select="'false'"/>

		<xsl:if test="count(event) &gt; 0">
			<span class="graytitle" id="eventDetail">Event detail</span>
			<ul class="pageitem">
				<xsl:for-each select="event">
					<xsl:sort select="@name" order="ascending"/>
					<xsl:call-template name="getTextBox">
						<xsl:with-param name="id" select="concat('event:',@name)" />
						<xsl:with-param name="content">
								<span class="header">
									<span class="name">
										<xsl:value-of select="concat(@name,' ')" />
									</span>
									<span class="type">
										<xsl:text>event </xsl:text>
										<xsl:if test="@type='listener'">
											<xsl:text>listener</xsl:text>
										</xsl:if>
										<xsl:if test="@type!='listener'">
											<xsl:text>handler</xsl:text>
										</xsl:if>
									</span>
								</span>
								<xsl:if test="eventObject">
									<table class="class-info">
										<tr class="event-object">
											<th>Event object type</th>
											<td>
												<xsl:if test="string-length(eventObject/@href)&gt;0">
													<a href="{eventObject/@href}">
														<code>
															<xsl:value-of select="eventObject/@label"/>
														</code>
													</a>
												</xsl:if>
												<xsl:if test="not(string-length(eventObject/@href)&gt;0)">
													<span>
														<code>
															<xsl:value-of select="eventObject/@label"/>
														</code>
													</span>
												</xsl:if>
											</td>
										</tr>
										<xsl:if test="eventType">
											<tr class="event-type">
												<th>
													<xsl:call-template name="substring-after-last">
														<xsl:with-param name="input" select="eventObject/@label" />
														<xsl:with-param name="substr" select="'.'" />
													</xsl:call-template>
													<xsl:text>.type property = </xsl:text>
												</th>
												<td>
													<xsl:if test="string-length(eventType/@href)&gt;0">
														<a href="{eventType/@href}">
															<code>
																<xsl:value-of select="eventType/@label"/>
															</code>
														</a>
													</xsl:if>
													<xsl:if test="not(string-length(eventType/@href)&gt;0)">
														<span>
															<code>
																<xsl:value-of select="eventType/@label"/>
															</code>
														</span>
													</xsl:if>
												</td>
											</tr>
										</xsl:if>
									</table>
								</xsl:if>
								<xsl:if test="$config/options/@docversion='2'">
									<p>
										<code>
												<xsl:text>public </xsl:text>
												<xsl:value-of select="@name" />
												<xsl:text> = function(</xsl:text>
												<xsl:call-template name="params" />
												<xsl:text>) {}</xsl:text>
										</code>
									</p>
								</xsl:if>
							<xsl:if test="$classDeprecated='true'">
								<xsl:call-template name="description">
									<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
									<xsl:with-param name="addParagraphTags" select="true()" />
								</xsl:call-template>
							</xsl:if>
							<xsl:call-template name="version"/>
							<xsl:if test="$classDeprecated!='true'">
								<xsl:call-template name="description">
									<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
								<xsl:with-param name="addParagraphTags" select="true()" />
								</xsl:call-template>
							</xsl:if>
							<xsl:if test="string-length(eventDescription/.)">
								<xsl:variable name="desc">
									<xsl:if test="contains(eventDescription/.,'&lt;p>')">
										<xsl:value-of select="concat('&lt;p>',substring-before(eventDescription/.,'&lt;p>'),'&lt;/p>&lt;p>',substring-after(eventDescription/.,'&lt;p>'))" />
									</xsl:if>
									<xsl:if test="not(contains(eventDescription/.,'&lt;p>'))">
										<xsl:value-of select="concat('&lt;p>',eventDescription/.,'&lt;/p>')" />
									</xsl:if>
								</xsl:variable>
								<xsl:call-template name="deTilda">
									<xsl:with-param name="inText" select="$desc" />
								</xsl:call-template>
							</xsl:if>
							<xsl:apply-templates select="params"/>
							<xsl:apply-templates select="example | includeExamples/includeExample[codepart]"/>
							<xsl:call-template name="sees" />
						</xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
			</ul>
		</xsl:if>
	</xsl:template>

	<xsl:template name="event">
		<xsl:if test="count(event)">
			<dl class="sees">
				<dt>Events</dt>
				<xsl:for-each select="event">
					<dd>
						<code>
							<b>
								<xsl:if test="$config/options/@docversion='2'">
									<a href="#event:{@name}">
										<xsl:value-of select="@name"/>
									</a>
								</xsl:if>
								<xsl:if test="$config/options/@docversion!='2'">
									<xsl:value-of select="@name"/>
								</xsl:if>
							</b>
							<xsl:if test="classRef">:<a href="{classRef/@relativePath}"><xsl:value-of select="classRef/@name"/></a></xsl:if>
						</code>
						<xsl:if test="string-length(description/.)">
							<br />
							<xsl:value-of select="$emdash"/>
							<xsl:call-template name="description"/>
						</xsl:if>
					</dd>
				</xsl:for-each>
				
			</dl>
		</xsl:if>
	</xsl:template>

	<!-- METHODS -->
	<xsl:template name="methodSummary">
		<xsl:param name="className" />
		<xsl:param name="title" select="'Methods'" />
		<xsl:param name="classDeprecated" select="'false'" />
		<xsl:param name="accessLevel" select="'public'" />
		<xsl:param name="baseRef" select="''" />
		<xsl:param name="isGlobal" select="false()" />
		<xsl:param name="showAnchor" select="true()" />

		<xsl:variable name="hasMethods" select="count(methods/method[@accessLevel=$accessLevel or @accessLevel=$config/namespaces/namespace[@summaryDisplay=$accessLevel]/.]) &gt; 0 or count(constructors/constructor[@accessLevel=$accessLevel or @accessLevel=$config/namespaces/namespace[@summaryDisplay=$accessLevel]/.]) &gt; 0" />
		<xsl:variable name="hasInherited" select="count(asAncestors/asAncestor/methods/method[@accessLevel=$accessLevel or @accessLevel=$config/namespaces/namespace[@summaryDisplay=$accessLevel]/.]) &gt; 0" />

		<xsl:variable name="fieldId">
			<xsl:if test="$accessLevel='protected'">
				<xsl:text>Protected</xsl:text>
			</xsl:if>
			<xsl:text>Method</xsl:text>
		</xsl:variable>

		<xsl:variable name="tableId">
			<xsl:value-of select="concat('summaryTable',$fieldId)" />
		</xsl:variable>

		<xsl:variable name="fieldTitle">
			<xsl:choose>
				<xsl:when test="$isGlobal">
					<xsl:text>Global </xsl:text>
				</xsl:when>
				<xsl:when test="$accessLevel='public'">
					<xsl:text>Public </xsl:text>
				</xsl:when>
				<xsl:when test="$accessLevel='protected'">
					<xsl:text>Protected </xsl:text>
				</xsl:when>
			</xsl:choose>
			<xsl:value-of select="$title" />
		</xsl:variable>

		<xsl:if test="$hasMethods or $hasInherited">
			
			<span class="graytitle">
				<xsl:value-of select="$fieldTitle" />
			</span>

			<ul class="pageitem" id="{$tableId}">
				<xsl:if test="$hasInherited">
					<xsl:call-template name="showHideLinks">
						<xsl:with-param name="id" select="$fieldId" />
						<xsl:with-param name="title" select="$fieldTitle" />
						<xsl:with-param name="baseRef" select="$baseRef" />
					</xsl:call-template>
				</xsl:if>
				<xsl:apply-templates select="methods/method[@accessLevel=$accessLevel or @accessLevel=$config/namespaces/namespace[@summaryDisplay=$accessLevel]/.] | constructors/constructor[@accessLevel=$accessLevel or @accessLevel=$config/namespaces/namespace[@summaryDisplay=$accessLevel]/.] | asAncestors/asAncestor/methods/method[@accessLevel=$accessLevel or @accessLevel=$config/namespaces/namespace[@summaryDisplay=$accessLevel]/.]" mode="summary">
					<xsl:sort select="local-name()" />
					<xsl:sort select="@name" order="ascending" />
					<xsl:with-param name="classDeprecated" select="$classDeprecated" />
					<xsl:with-param name="baseRef" select="$baseRef" />
					<xsl:with-param name="accessLevel" select="$accessLevel" />
				</xsl:apply-templates>
			</ul>
		</xsl:if>
	</xsl:template>

	<xsl:template match="methods" mode="detail">
		<xsl:param name="className" />
		<xsl:param name="title" select="'Method detail'" />
		<xsl:param name="classDeprecated" select="'false'" />
		<xsl:param name="baseRef" />
		<xsl:if test="count(method) &gt; 0">
			<span class="graytitle" id="methodDetail"><xsl:value-of select="$title"/></span>
			<ul class="pageitem">
				<xsl:apply-templates select="method" mode="detail">
					<xsl:sort select="@name" order="ascending"/>
					<xsl:with-param name="classDeprecated" select="$classDeprecated" />
					<xsl:with-param name="isMethod" select="$className!='package'" />
					<xsl:with-param name="className" select="$className" />
					<xsl:with-param name="baseRef" select="$baseRef" />
				</xsl:apply-templates>
			</ul>
		</xsl:if>
	</xsl:template>

	<xsl:template match="method | constructor" mode="summary">
		<xsl:param name="classDeprecated" select="'false'" />
		<xsl:param name="baseRef" select="''" />
		<xsl:param name="accessLevel" select="'public'" />
		<xsl:call-template name="getTextBox">
			<xsl:with-param name="class">
				<xsl:text>textbox</xsl:text>
				<xsl:if test="ancestor::asAncestor">
					<xsl:text> hiddenBlockTarget</xsl:text>
				</xsl:if>
			</xsl:with-param>
			<xsl:with-param name="content">
				<p>
					<a class="signatureLink">
						<xsl:attribute name="href">
							<xsl:choose>
								<xsl:when test="ancestor::asAncestor">
									<xsl:value-of select="concat(ancestor::asAncestor/classRef/@relativePath,'#',@name,'()')" />
								</xsl:when>
								<xsl:when test="self::constructor">
									<xsl:if test="position()&gt;1">
										<xsl:value-of select="concat('#',@name,position(),'()')" />
									</xsl:if>
									<xsl:if test="position()=1">
										<xsl:value-of select="concat('#',@name,'()')" />
									</xsl:if>
								</xsl:when>
								<xsl:when test="ancestor::asClass or ancestor::asPackage">
									<xsl:value-of select="concat('#',@name,'()')" />
								</xsl:when>
							</xsl:choose>
						</xsl:attribute>
						<xsl:if test="ancestor::asAncestor">
							<xsl:call-template name="getInheritedIcon">
								<xsl:with-param name="baseRef" select="$baseRef" />
							</xsl:call-template>
						</xsl:if>
						<span class="name">
							<xsl:value-of select="@name"/>
						</span>
					</a>
					<xsl:if test="(not(@type) or @type='method')">
						<span class="params">
							<xsl:text>(</xsl:text>
							<xsl:call-template name="params"/>
							<xsl:text>) </xsl:text>
						</span>
						<xsl:if test="self::method">
							<xsl:text>:</xsl:text>
							<span class="type">
								<xsl:choose>
									<xsl:when test="@result_type='' or @result_type='*'">
										<xsl:call-template name="getSpecialTypeLink">
											<xsl:with-param name="type" select="'*'" />
										</xsl:call-template>
									</xsl:when>
									<xsl:when test="@result_type='void'">
										<xsl:call-template name="getSpecialTypeLink">
											<xsl:with-param name="type" select="'void'" />
										</xsl:call-template>
									</xsl:when>
									<xsl:when test="@result_type='Void' and $config/options/@docversion='2'">
										<xsl:value-of select="@result_type" />
									</xsl:when>
									<xsl:when test="result/classRef">
										<a href="{result/classRef/@relativePath}">
											<xsl:call-template name="getSimpleClassName">
												<xsl:with-param name="fullClassName" select="result/@type"/>
											</xsl:call-template>
										</a>
									</xsl:when>
									<xsl:when test="not(result/classRef) and result/@type">
											<xsl:call-template name="getSimpleClassName">
											<xsl:with-param name="fullClassName" select="result/@type"/>
										</xsl:call-template>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="getSimpleClassName">
											<xsl:with-param name="fullClassName" select="@result_type" />
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
							</span>
						</xsl:if>
					</xsl:if>
				</p>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="getTextBox">
			<xsl:with-param name="class">
				<xsl:text>textbox thintop</xsl:text>
				<xsl:if test="ancestor::asAncestor">
					<xsl:text> hiddenBlockTarget</xsl:text>
				</xsl:if>
			</xsl:with-param>
			<xsl:with-param name="content">
				<xsl:apply-templates select="deprecated"/>
				<xsl:if test="not(deprecated)">
					<xsl:if test="@isStatic='true'">
						<span class="only">static</span>
					</xsl:if>
					<xsl:call-template name="shortDescription">
						<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="not($config/options/@docversion='2')">
					<xsl:choose>
						<xsl:when test="ancestor::asAncestor">
							<a href="{ancestor::asAncestor/classRef/@relativePath}">
								<xsl:value-of select="ancestor::asAncestor/classRef/@name" />
							</a>
						</xsl:when>
						<xsl:when test="ancestor::asClass">
							<xsl:value-of select="ancestor::asClass/@name" />
						</xsl:when>
						<xsl:when test="ancestor::asPackage">
							<xsl:if test="ancestor::asPackage/@name='$$Global$$'">
								<xsl:value-of select="concat('Top',$nbsp,'Level')" />
							</xsl:if>
							<xsl:if test="ancestor::asPackage/@name!='$$Global$$'">
								<xsl:value-of select="ancestor::asPackage/@name" />
							</xsl:if>
						</xsl:when>
					</xsl:choose>
				</xsl:if>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="getNamespaceLink">
		<xsl:param name="accessLevel" />
		<xsl:param name="baseRef" />
		<xsl:choose>
			<xsl:when test="$config/languageElements[@show='true' and @statements='true']">		
				<xsl:if test="$accessLevel='public' or $accessLevel='protected'">
					<xsl:value-of select="$accessLevel"/>
				</xsl:if>
				<xsl:if test="not($accessLevel='public' or $accessLevel='protected')">
					<a href="{$baseRef}statements.html#{$accessLevel}">
						<xsl:value-of select="$accessLevel" />
					</a>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$accessLevel" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="getSpecialTypeLink">
		<xsl:param name="type" />
		<xsl:param name="baseRef">
			<xsl:call-template name="getBaseRef">
				<xsl:with-param name="packageName">
					<xsl:if test="ancestor::asClass">
						<xsl:value-of select="ancestor::asClass/@packageName" />
					</xsl:if>
					<xsl:if test="not(ancestor::asClass)">
						<xsl:value-of select="ancestor::asPackage/@name" />
					</xsl:if>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:param>
		<xsl:choose>
			<xsl:when test="$config/languageElements[@show='true' and @specialTypes='true']">
				<a href="{concat($baseRef,'specialTypes.html#',$type)}"><xsl:value-of select="$type" /></a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$type" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="processCodepart">
		<xsl:param name="codepart" />
		<div class="listing"><pre>
			<xsl:call-template name="search-and-replace">
				<xsl:with-param name="input" select="$codepart" />
				<xsl:with-param name="search-string" select="'~~'" />
				<xsl:with-param name="replace-string" select="'*'" />
			</xsl:call-template>
		</pre></div>
	</xsl:template>

	<xsl:template match="codepart">
		<xsl:variable name="deTabbed">
			<xsl:call-template name="search-and-replace">
				<xsl:with-param name="input" select="." />
				<xsl:with-param name="search-string" select="$tab" />
				<xsl:with-param name="replace-string" select="$tabSpaces" />
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="initialComment" select="starts-with($deTabbed,'/*')" />
		<xsl:if test="$initialComment">
			<xsl:variable name="comment" select="substring-before($deTabbed,'*/')" />
			<xsl:if test="contains($comment,'@exampleText ')">
				<xsl:call-template name="deTilda">
					<xsl:with-param name="inText" select="substring-after(translate($comment,'*',''),'@exampleText ')" />
				</xsl:call-template>
			</xsl:if>
		</xsl:if>	
		<xsl:if test="$initialComment">
			<xsl:variable name="rest" select="substring-after($deTabbed,'*/')" />
			<xsl:variable name="finalComment" select="contains($rest,'/*')" />
			<xsl:if test="$finalComment">
				<xsl:call-template name="processCodepart">
					<xsl:with-param name="codepart" select="substring-before($rest,'/*')" />
				</xsl:call-template>
				<xsl:if test="contains($rest,'@exampleText ')">
					<xsl:call-template name="deTilda">
						<xsl:with-param name="inText" select="substring-after(translate(substring-before($rest,'*/'),'*',''),'@exampleText ')" />
					</xsl:call-template>
					<br />
					<br />
				</xsl:if>
			</xsl:if>
			<xsl:if test="not($finalComment)">
				<xsl:call-template name="processCodepart">
					<xsl:with-param name="codepart" select="substring-after($deTabbed,'*/')" />
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
		<xsl:if test="not($initialComment)">
			<xsl:variable name="finalComment" select="contains($deTabbed,'/*')" />
			<xsl:if test="$finalComment">
				<xsl:call-template name="processCodepart">
					<xsl:with-param name="codepart" select="substring-before($deTabbed,'/*')" />
				</xsl:call-template>
				<xsl:if test="contains($deTabbed,'@exampleText ')">
					<xsl:call-template name="deTilda">
						<xsl:with-param name="inText" select="substring-after(translate(substring-before($deTabbed,'*/'),'*',''),'@exampleText ')" />
					</xsl:call-template>
					<br />
					<br />
				</xsl:if>
			</xsl:if>
			<xsl:if test="not($finalComment)">
				<xsl:call-template name="processCodepart">
					<xsl:with-param name="codepart" select="$deTabbed" />
				</xsl:call-template>
			</xsl:if>
		</xsl:if>	
	</xsl:template>
   
	<xsl:template name="includeExamples">        
		<xsl:param name="showIncludeExamples" select="$showIncludeExamples"/>
		<xsl:if test="$showIncludeExamples = 'true'">
			<xsl:if test="includeExamples/includeExample/codepart">
				<div class="detailSectionHeader" id="includeExamplesSummary">
					<xsl:text>Examples</xsl:text>
				</div>
			
				<xsl:for-each select="includeExamples/includeExample">
					<xsl:if test="contains(@examplefilename,'.mxml')">
						<div class="exampleHeader">
							<xsl:value-of select="substring-before(@examplefilename,'.mxml')" />
						</div>
					</xsl:if>
					<xsl:if test="contains(@examplefilename,'.as')">
						<br />
					</xsl:if>
					<div class="detailBody">
						<xsl:apply-templates select="codepart" />
					</div>
				</xsl:for-each>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="method" mode="detail">
		<xsl:param name="classDeprecated" select="'false'"/>
		<xsl:param name="isMethod" select="true()" />
		<xsl:param name="className" select="''" />
		<xsl:param name="baseRef" />
		<xsl:call-template name="getTextBox">
			<xsl:with-param name="id" select="concat(@name,'()')" />
			<xsl:with-param name="content">
				<span class="header">
					<span class="name"><xsl:value-of select="@name" /></span>
					<span class="params"><xsl:text>() </xsl:text></span>
					<span class="type">
						<xsl:if test="$isMethod">
							<xsl:text>method</xsl:text>
						</xsl:if>
						<xsl:if test="not($isMethod)">
							<xsl:text>function</xsl:text>
						</xsl:if>
					</span>
				</span>
				<xsl:if test="(not(@type) or @type='method')">
					<code class="sign">
						<xsl:call-template name="getNamespaceLink">
							<xsl:with-param name="accessLevel" select="@accessLevel" />
							<xsl:with-param name="baseRef" select="$baseRef" />
						</xsl:call-template>
						<xsl:text> </xsl:text>
						<xsl:if test="@isFinal='true'">
							<xsl:text>final </xsl:text>
						</xsl:if>
						<xsl:if test="@isStatic='true'">
							<xsl:text>static </xsl:text>
						</xsl:if>
						<xsl:if test="@isOverride='true'">
							<xsl:text>override </xsl:text>
						</xsl:if>
						<xsl:text>function </xsl:text>
						<xsl:value-of select="@name"/>
						<xsl:text>(</xsl:text>
						<xsl:call-template name="params"/>
						<xsl:text>):</xsl:text>
						<xsl:choose>
							<xsl:when test="result/@type='' or result/@type='*'">
								<xsl:call-template name="getSpecialTypeLink">
									<xsl:with-param name="type" select="'*'" />
								</xsl:call-template>
							</xsl:when>
							<xsl:when test="result/@type='void'">
								<xsl:call-template name="getSpecialTypeLink">
									<xsl:with-param name="type" select="'void'" />
								</xsl:call-template>
							</xsl:when>
	                        <xsl:when test="result/@type='Void' and $config/options/@docversion='2'">
	                            <xsl:value-of select="@result_type" />
	                        </xsl:when>
							<xsl:when test="result/classRef">
								<a href="{result/classRef/@relativePath}">
									<xsl:call-template name="getSimpleClassName">
										<xsl:with-param name="fullClassName" select="result/@type"/>
									</xsl:call-template>
								</a>
							</xsl:when>
							<xsl:when test="not(result/classRef)">
								<xsl:call-template name="getSimpleClassName">
									<xsl:with-param name="fullClassName" select="result/@type"/>
								</xsl:call-template>
							</xsl:when>
						</xsl:choose>
					</code>
				</xsl:if>
				<xsl:apply-templates select="deprecated"/>
				<xsl:if test="$classDeprecated='true'">
					<xsl:call-template name="description">
						<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
						<xsl:with-param name="addParagraphTags" select="true()" />
					</xsl:call-template>
				</xsl:if>
				<xsl:call-template name="version"/>
				<xsl:if test="$classDeprecated!='true'">
					<xsl:call-template name="description">
						<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
						<xsl:with-param name="addParagraphTags" select="true()" />
					</xsl:call-template>
				</xsl:if>
				<xsl:apply-templates select="params"/>
				<xsl:call-template name="result"/>
				<xsl:call-template name="event"/>
				<xsl:if test="canThrow">
					<dl class="sees">
						<dt>Throws</dt>
						<xsl:apply-templates select="canThrow"/>
					</dl>
				</xsl:if>
	
				<xsl:call-template name="sees" />
				<xsl:apply-templates select="example | includeExamples/includeExample[codepart]"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="constructor" mode="detail">
		<xsl:param name="classDeprecated" select="'false'"/>		
		<xsl:param name="baseRef" />
		<xsl:call-template name="getTextBox">
			<xsl:with-param name="id">
				<xsl:value-of select="@name" />
				<xsl:if test="position()&gt;1">
					<xsl:value-of select="position()" />
				</xsl:if>
				<xsl:text>()</xsl:text>
			</xsl:with-param>
			<xsl:with-param name="content">
				<span class="header">
					<span class="name">
						<xsl:value-of select="@name" />
					</span>
					<span class="params"><xsl:text>() </xsl:text></span>
					<span class="type">constructor</span>
				</span>
				<xsl:if test="(not(@type) or @type='method')">
					<code class="sign">
						<xsl:call-template name="getNamespaceLink">
							<xsl:with-param name="accessLevel" select="@accessLevel" />
							<xsl:with-param name="baseRef" select="$baseRef" />
						</xsl:call-template>
						<xsl:text> function </xsl:text>
						<xsl:value-of select="@name"/>
						<xsl:text>(</xsl:text>
						<xsl:call-template name="params"/>
						<xsl:text>)</xsl:text>
					</code>
					<br />
				</xsl:if>
				<xsl:call-template name="description">
					<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
								<xsl:with-param name="addParagraphTags" select="true()" />
				</xsl:call-template>

				<xsl:call-template name="version"/>
				<xsl:apply-templates select="params"/>
				<xsl:call-template name="event" />
	
				<xsl:if test="canThrow">
					<dl class="sees">
						<dt>Throws</dt>
						<xsl:apply-templates select="canThrow"/>
					</dl>
				</xsl:if>
	
				<xsl:call-template name="sees"/>
				<xsl:apply-templates select="example | includeExamples/includeExample[codepart]"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- PARAMS -->
	<xsl:template name="params">
		<xsl:for-each select="params/param">
			<xsl:if test="position()>1">
				<xsl:text>, </xsl:text>
			</xsl:if>
			<xsl:if test="$config/options/@docversion='2' and @optional='true'">
				<xsl:text>[</xsl:text>
			</xsl:if>     
			<xsl:if test="@type">
				<xsl:if test="@type = 'restParam'">
					<xsl:variable name="baseRef">
						<xsl:if test="ancestor::asPackage">
							<xsl:call-template name="getBaseRef">
								<xsl:with-param name="packageName" select="ancestor::asPackage/@name" />
							</xsl:call-template>
						</xsl:if>
					</xsl:variable>
					<xsl:if test="$config/languageElements[@show='true' and @statements='true']">
						<a href="{$baseRef}statements.html#..._(rest)_parameter">...</a>
					</xsl:if>
					<xsl:if test="not($config/languageElements[@show='true' and @statements='true'])">
						<xsl:text>...</xsl:text>
					</xsl:if>
					<xsl:text> </xsl:text>
					<xsl:value-of select="@name"/>
				</xsl:if>
				<xsl:if test="@type != 'restParam'">
<!-- 					<b> -->
						<xsl:value-of select="@name"/>
<!-- 					</b> -->
					<xsl:text>:</xsl:text>
					<xsl:choose>
						<xsl:when test="classRef">
							<a href="{classRef/@relativePath}">
								<xsl:call-template name="getSimpleClassName">
									<xsl:with-param name="fullClassName" select="@type"/>
								</xsl:call-template>
							</a>
						</xsl:when>
						<xsl:when test="@type='' or @type='*'">
							<xsl:call-template name="getSpecialTypeLink">
								<xsl:with-param name="type" select="'*'" />
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="not(classRef)">
							<xsl:call-template name="getSimpleClassName">
								<xsl:with-param name="fullClassName" select="@type"/>
							</xsl:call-template>
						</xsl:when>
					</xsl:choose>
				</xsl:if>
			</xsl:if>
			<xsl:if test="(string-length(@default) or @type='String') and @default!='unknown'">
				<xsl:text> = </xsl:text>
				<xsl:if test="@type='String' and @default!='null'">
					<xsl:text>"</xsl:text>
				</xsl:if>
				<xsl:value-of select="@default"/>
				<xsl:if test="@type='String' and @default!='null'">
					<xsl:text>"</xsl:text>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$config/options/@docversion='2' and @optional='true'">
				<xsl:text>]</xsl:text>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="params">
		<dl class="sees">
			<dt>Parameters</dt>
			<xsl:for-each select="param">
				<dd>
					<code>
						<xsl:if test="@type='restParam'">
							<xsl:variable name="baseRef">
								<xsl:if test="ancestor::asPackage">
									<xsl:call-template name="getBaseRef">
										<xsl:with-param name="packageName" select="ancestor::asPackage/@name" />
									</xsl:call-template>
								</xsl:if>
							</xsl:variable>
							<xsl:if test="$config/languageElements[@show='true' and @statements='true']">
								<a href="{$baseRef}statements.html#..._(rest)_parameter">...</a>
							</xsl:if>
							<xsl:if test="not($config/languageElements[@show='true' and @statements='true'])">
								<xsl:text>...</xsl:text>
							</xsl:if>
							<xsl:text> </xsl:text>
							<span class="label">
								<xsl:value-of select="@name"/>
							</span>
						</xsl:if>
						<xsl:if test="@type!='restParam'">
							<span class="label">
								<xsl:value-of select="@name"/>
							</span>
							<xsl:choose>
								<xsl:when test="classRef">
									<xsl:text>:</xsl:text>
									<a href="{classRef/@relativePath}">
										<xsl:call-template name="getSimpleClassName">
											<xsl:with-param name="fullClassName" select="@type"/>
										</xsl:call-template>
									</a>
								</xsl:when>
								<xsl:when test="@type='' or @type='*'">
									<xsl:text>:</xsl:text>
									<xsl:call-template name="getSpecialTypeLink">
										<xsl:with-param name="type" select="'*'" />
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="not(classRef) and string-length(@type)">										
									<xsl:text>:</xsl:text>
									<xsl:call-template name="getSimpleClassName">
										<xsl:with-param name="fullClassName" select="@type"/>
									</xsl:call-template>
								</xsl:when>
							</xsl:choose>
						</xsl:if>
						<xsl:if test="(string-length(@default) or @type='String') and @default!='unknown'">
							<xsl:text disable-output-escaping="yes">&lt;/code&gt; (default = </xsl:text>
							<xsl:if test="@type='String' and @default!='null'">
								<xsl:text>"</xsl:text>
							</xsl:if>
							<xsl:text disable-output-escaping="yes">&lt;code&gt;</xsl:text>
							<xsl:value-of select="@default" />
							<xsl:text disable-output-escaping="yes">&lt;/code&gt;</xsl:text>
							<xsl:if test="@type='String' and @default!='null'">
								<xsl:text>"</xsl:text>
							</xsl:if>
							<xsl:text>)</xsl:text>
							<xsl:text disable-output-escaping="yes">&lt;code&gt;</xsl:text>
						</xsl:if>
					</code>
					<br />
					<xsl:if test="@optional='true'">
						<xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]>[optional]</xsl:text>
					</xsl:if>
					<xsl:if test="normalize-space(description/.)">
						<xsl:value-of select="$emdash"/>
						<xsl:call-template name="description"/>
					</xsl:if>
				</dd>
			</xsl:for-each>
		</dl>
	</xsl:template>

	<!-- RESULT -->
	<xsl:template name="result">
		<xsl:if test="result[@type != 'void'] and not($config/options/@docversion='2' and result/@type='Void')">
			<dl class="sees">
				<dt>Returns</dt>
				<dd>
					<code>
						<xsl:choose>
							<xsl:when test="result/@type='' or result/@type='*'">
								<xsl:call-template name="getSpecialTypeLink">
									<xsl:with-param name="type" select="'*'" />
								</xsl:call-template>
							</xsl:when>
                            <xsl:when test="result/@type='Void' and $config/options/@docversion='2'">
                                   <xsl:value-of select="@result_type" />
                            </xsl:when>
							<xsl:when test="result/classRef">
								<a href="{result/classRef/@relativePath}">
									<xsl:call-template name="getSimpleClassName">
										<xsl:with-param name="fullClassName" select="result/@type"/>
									</xsl:call-template>
								</a>
							</xsl:when>
							<xsl:when test="not(result/classRef)">
								<xsl:call-template name="getSimpleClassName">
									<xsl:with-param name="fullClassName" select="result/@type"/>
								</xsl:call-template>
							</xsl:when>
						</xsl:choose>
					</code>
					<br />
					<xsl:if test="string-length(normalize-space(result/.))">
						<xsl:value-of select="$emdash"/>
						<xsl:call-template name="deTilda">
							<xsl:with-param name="inText" select="result/."/>
						</xsl:call-template>
					</xsl:if>
				</dd>
			</dl>
		</xsl:if>
	</xsl:template>

	<!-- THROWS -->
	<xsl:template match="canThrow">
		<dd>
			<code>
				<xsl:if test="classRef/@relativePath">
					<a href="{classRef/@relativePath}">
						<xsl:value-of select="classRef/@name"/>
					</a>
					<xsl:text> </xsl:text>
				</xsl:if>
				<xsl:if test="not(classRef/@relativePath)">
					<xsl:value-of select="classRef/@name"/>
				</xsl:if>
			</code>
			<br />
			<xsl:if test="string-length(description/.)">
				<xsl:value-of select="$emdash"/>
			</xsl:if>
			<xsl:call-template name="description"/>
		</dd>
	</xsl:template>

	<!-- EXAMPLES -->
	<xsl:template match="example | includeExample">
		<!-- TODO: pre領域からソースコードがはみ出す -->
		<xsl:param name="show" select="$showExamples"/>
		<xsl:if test="$show = 'true'">
			<xsl:call-template name="getTextBox">
				<xsl:with-param name="class" select="'example textbox thintop'" />
				<xsl:with-param name="content">
					<xsl:if test="position()=1">
						<span class="header">Example</span>
					</xsl:if>
					<blockquote>
						<xsl:if test="self::example">
							<xsl:call-template name="deTilda">
								<xsl:with-param name="inText">
									<xsl:apply-templates mode="deTab" />
								</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
						<xsl:if test="self::includeExample">
							<xsl:variable name="deTabbed">
								<xsl:call-template name="search-and-replace">
									<xsl:with-param name="input" select="codepart/." />
									<xsl:with-param name="search-string" select="$tab" />
									<xsl:with-param name="replace-string" select="$tabSpaces" />
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="initialComment" select="starts-with($deTabbed,'/*')" />
							<xsl:if test="$initialComment">
								<xsl:variable name="comment" select="substring-before($deTabbed,'*/')" />
								<xsl:if test="contains($comment,'@exampleText ')">
									<xsl:call-template name="deTilda">
										<xsl:with-param name="inText" select="substring-after(translate($comment,'*',''),'@exampleText ')" />
									</xsl:call-template>
								</xsl:if>
							</xsl:if>	
							<xsl:if test="$initialComment">
								<xsl:variable name="rest" select="substring-after($deTabbed,'*/')" />
								<xsl:variable name="finalComment" select="contains($rest,'/*')" />
								<xsl:if test="$finalComment">
									<div class='listing'><pre>
										<xsl:value-of select="substring-before($rest,'/*')" />
									</pre></div>
									<xsl:if test="contains($rest,'@exampleText ')">
										<xsl:call-template name="deTilda">
											<xsl:with-param name="inText" select="substring-after(translate(substring-before($rest,'*/'),'*',''),'@exampleText ')" />
										</xsl:call-template>
										<br />
										<br />
									</xsl:if>
								</xsl:if>
								<xsl:if test="not($finalComment)">
									<div class='listing'><pre>
										<xsl:value-of select="substring-after($deTabbed,'*/')" />
									</pre></div>
								</xsl:if>
							</xsl:if>
							<xsl:if test="not($initialComment)">
								<xsl:variable name="finalComment" select="contains($deTabbed,'/*')" />
								<xsl:if test="$finalComment">
									<div class='listing'><pre>
										<xsl:value-of select="substring-before($deTabbed,'/*')" />
									</pre></div>
									<xsl:if test="contains($deTabbed,'@exampleText ')">
										<xsl:call-template name="deTilda">
											<xsl:with-param name="inText" select="substring-after(translate(substring-before($deTabbed,'*/'),'*',''),'@exampleText ')" />
										</xsl:call-template>
										<br />
										<br />
									</xsl:if>
								</xsl:if>
								<xsl:if test="not($finalComment)">
									<div class='listing'><pre>
										<xsl:value-of select="$deTabbed" />
									</pre></div>
								</xsl:if>
							</xsl:if>
						</xsl:if>
					</blockquote>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="text()" mode="deTab">
		<xsl:call-template name="search-and-replace">
			<xsl:with-param name="input" select="." />
			<xsl:with-param name="search-string" select="'&#09;'" />
			<xsl:with-param name="replace-string" select="'    '" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="includeExampleLink">
		<xsl:param name="showIncludeExamples" select="$showIncludeExamples"/>
		<xsl:if test="$showIncludeExamples = 'true'">
			<xsl:if test="includeExamples/includeExample/codepart">
			<p>
				<a href="#includeExamplesSummary">View the examples.</a>
			</p>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template name="inherited">
		<xsl:param name="lowerType" />
		<xsl:param name="upperType" />
		<xsl:param name="prefix" />
		<xsl:param name="postfix" />
		<xsl:param name="inheritedItems" />
		<xsl:param name="staticItems" />

		<xsl:if test="string-length($inheritedItems) &gt; 0">
			<xsl:call-template name="doInherited">
				<xsl:with-param name="lowerType" select="$lowerType" />
				<xsl:with-param name="upperType" select="$upperType" />
				<xsl:with-param name="prefix" select="$prefix" />
				<xsl:with-param name="postfix" select="$postfix" />
				<xsl:with-param name="items" select="$inheritedItems" />
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="string-length($staticItems) &gt; 0">
			<xsl:call-template name="doInherited">
				<xsl:with-param name="lowerType" select="$lowerType" />
				<xsl:with-param name="upperType" select="$upperType" />
				<xsl:with-param name="prefix" select="$prefix" />
				<xsl:with-param name="postfix" select="$postfix" />
				<xsl:with-param name="items" select="$staticItems" />
				<xsl:with-param name="isStatic" select="true()" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="doInherited">
		<xsl:param name="lowerType" />
		<xsl:param name="upperType" />
		<xsl:param name="prefix" />
		<xsl:param name="postfix" />
		<xsl:param name="items" />
		<xsl:param name="innerClass" select="false()" />
		<xsl:param name="isStatic" select="false()" />

		<xsl:variable name="classRef" select="classRef"/>
		<xsl:variable name="bgColor">
			<xsl:if test="not($isStatic)">
				<xsl:text>#EEEEEE</xsl:text>
			</xsl:if>
			<xsl:if test="$isStatic">
				<xsl:text>#EEDDDD</xsl:text>
			</xsl:if>
		</xsl:variable>
		<a name="{$lowerType}InheritedFrom{$classRef/@name}"/>
		<table cellspacing="0" cellpadding="3" class="summaryTable">
        	<tr>
            	<th>
                   <xsl:value-of select="$nbsp" />
                </th>
                <th>
                   <xsl:if test="$isStatic">
                        <xsl:text>Static </xsl:text>
                        <xsl:value-of select="$lowerType" />
                       <xsl:text> defined in class </xsl:text>
                    </xsl:if>
                    <xsl:if test="not($isStatic)">
                        <xsl:value-of select="$upperType"/>
                        <xsl:text> inherited from class </xsl:text>
                    </xsl:if>
                    <a href="{$classRef/@relativePath}">
                       <xsl:value-of select="$classRef/@name"/>
                   </a>
                 </th>
            </tr>
            <tr>
                <td class="summaryTablePaddingCol">
                   <xsl:value-of select="$nbsp" />
                </td>
			</tr>
			<tr>
				<td class="inheritanceList">
					<code>
						<xsl:for-each select="str:tokenize($items,';')">
							<xsl:sort select="." order="ascending" data-type="text"/>

							<xsl:if test="$innerClass">
								<xsl:variable name="href">
									<xsl:if test="contains($classRef/@relativePath,':')">
										<xsl:call-template name="substring-before-last">
											<xsl:with-param name="input" select="$classRef/@relativePath"/>
											<xsl:with-param name="substr" select="':'"/>
										</xsl:call-template>
										<xsl:text>/</xsl:text>
									</xsl:if>
									<xsl:value-of select="."/>
								</xsl:variable>
								<a href="{$href}.html">
									<xsl:value-of select="."/>
								</a>
							</xsl:if>
							<xsl:if test="not($innerClass)">
								<xsl:if test="$prefix">
									<a href="{$classRef/@relativePath}#{$prefix}:{.}{$postfix}">
										<xsl:value-of select="."/>
									</a>
								</xsl:if>
								<xsl:if test="not($prefix)">
									<a href="{$classRef/@relativePath}#{.}{$postfix}">
										<xsl:value-of select="."/>
									</a>
								</xsl:if>
							</xsl:if>
							<xsl:if test="position() != last()">
								<xsl:text>, </xsl:text>
							</xsl:if>
						</xsl:for-each>
					</code>
					<br />
				</td>
			</tr>
		</table>
	</xsl:template>

	<xsl:template name="description">
		<xsl:param name="classDeprecated" select="'false'" />
		<xsl:param name="addParagraphTags" select="false()" />

		<xsl:if test="$classDeprecated='true'">
			<xsl:copy-of select="$deprecatedLabel"/>
			<xsl:text>.</xsl:text>
<!-- 			<em> -->
				<xsl:text> The </xsl:text>
				<xsl:value-of select="../../@name"/>
				<xsl:text> class is </xsl:text>
				<a href="#deprecated">deprecated</a>
				<xsl:if test="string-length(../../deprecated/@as-of)">
					<xsl:text> since </xsl:text>
					<xsl:value-of select="../../deprecated/@as-of"/>
				</xsl:if>
				<xsl:text>.</xsl:text>
<!-- 			</em> -->
			<br/>
			<br/>
		</xsl:if>
		<xsl:if test="customs/review and $config/options/@showReview='true'">
			<h2><font color="red">Review Needed</font></h2>
		</xsl:if>
		<xsl:if test="description">
			<xsl:variable name="desc">
				<xsl:if test="$addParagraphTags">
					<xsl:if test="not(contains(description/.,'&lt;p>'))">
						<xsl:value-of select="concat('&lt;p>',description/.,'&lt;/p>')" />
					</xsl:if>
					<xsl:if test="contains(description/.,'&lt;p>')">
						<xsl:value-of select="concat('&lt;p>',substring-before(description/.,'&lt;p>'),'&lt;/p>&lt;p>',substring-after(description/.,'&lt;p>'))" />
					</xsl:if>
				</xsl:if>
				<xsl:if test="not($addParagraphTags)">
					<xsl:value-of select="description/." />
				</xsl:if>
			</xsl:variable>
			<xsl:call-template name="deTilda">
				<xsl:with-param name="inText" select="$desc" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="shortDescription">
		<xsl:param name="classDeprecated" select="'false'"/>

		<xsl:if test="shortDescription or $classDeprecated='true'">
			<xsl:call-template name="shortDescriptionReview" />
			<xsl:if test="$classDeprecated='true'">
				<xsl:copy-of select="$deprecatedLabel"/>
				<xsl:text>. </xsl:text>
			</xsl:if>
			<xsl:call-template name="deTilda">
				<xsl:with-param name="inText" select="shortDescription"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="hasInnerClasses">
		<xsl:value-of select="count(./*[asClass or asAncestor[classes/asClass]])"/>
	</xsl:template>

	<xsl:template name="hasConstants">
		<xsl:value-of select="count(.//*[field[@isConst='true']])"/>
	</xsl:template>

	<xsl:template name="hasFields">
		<xsl:value-of select="count(.//*[field[not(@isConst='true')]])"/>
	</xsl:template>

	<xsl:template name="hasConstructor">
		<xsl:value-of select="count(./*[constructor])"/>
	</xsl:template>

	<xsl:template name="hasMethods">
		<xsl:value-of select="count(.//*[method])"/>
	</xsl:template>

	<xsl:template name="hasEvents">
		<xsl:value-of select="count(.//*[event[../../eventsGenerated and not(ancestor::asImplements)]])"/>
	</xsl:template>

	<xsl:template name="hasStyles">
		<xsl:value-of select="count(.//*[style])"/>
	</xsl:template>

	<xsl:template name="hasEffects">
		<xsl:value-of select="count(.//*[effect])"/>
	</xsl:template>

	<xsl:template name="hasIncludeExamples">
		<xsl:param name="showIncludeExamples" select="$showIncludeExamples"/>
		<xsl:if test="$showIncludeExamples = 'true'">
			<xsl:value-of select="count(./*[includeExample/codepart])"/>
		</xsl:if>
	</xsl:template>


</xsl:stylesheet>