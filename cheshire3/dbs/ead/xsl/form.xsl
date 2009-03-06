<?xml version="1.0" encoding="utf-8"?>

<!-- 
	This file was produced, and released as part of Cheshire for Archives v3.x.
	Copyright &#169; 2005-2009 the University of Liverpool
-->

<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:exsl="http://exslt.org/common"
    extension-element-prefixes="exsl"
    version="1.0">
  
    <xsl:import href="contents-editing.xsl"/>

  <xsl:output method="xml" omit-xml-declaration="yes" encoding="UTF-8"/>
	 <xsl:preserve-space elements="*"/>


  <xsl:variable name="eadidstring">
  	<xsl:value-of select="/ead/eadheader/eadid/text()"/>
  </xsl:variable>
  
  <xsl:variable name="leveltype">
  	<xsl:choose>
  		<xsl:when test="/ead/eadheader">
  			<xsl:text>collection</xsl:text>
  		</xsl:when>
  		<xsl:otherwise>
  			<xsl:text>component</xsl:text>
  		</xsl:otherwise>
  	</xsl:choose>
  </xsl:variable>
  
  <xsl:variable name="level">
  	<xsl:choose>
  		<xsl:when test="/*/@level">
  			<xsl:value-of select="/*/@level"/>
  		</xsl:when>
  		<xsl:otherwise>
  			<xsl:text></xsl:text>
  		</xsl:otherwise>
  	</xsl:choose>
  </xsl:variable>
  
 
      
  <xsl:template match="/">
  <div id="formDiv" name="form" class="formDiv">
    <form id="eadForm" name="eadForm"  action="#" >
    <div class="float"> <input type="button" class="formbutton" id="addC" onclick="javascript: addComponent()" value="Add Component" title="Add a component to this level of the record"></input></div>
 <!--   <div class="float"> <input type="button" class="formbutton" id="reset" onclick="javascript: resetForm()" value="Reset"></input> </div> -->  
    	<div class="pui">
    		<strong><xsl:text>Persistent Unique Identifier</xsl:text><a href="http://www.archiveshub.ac.uk/arch/glossary.shtml#identifier" title="PUI help - opens in new window" target="_new"><img class="whatsthis" src="/ead/img/whatisthissmall.gif" alt="[What is this?]"/></a></strong>				
    		%PUI%
    	</div>
    
    <br/>
       <div class="section">
    	<xsl:choose>
    		<xsl:when test="/ead/eadheader">	
    			<h3>Collection Level Description</h3>
    			%RECID%   			
    			<xsl:apply-templates select="/c|/c01|/c02|/c03|/c04|/c05|/c06|/c07|/c08|/c09|/c10|/c11|/c12|/ead/archdesc"/>
    		</xsl:when>
    		<xsl:otherwise>
    			<h3>Component Level Description</h3>
    			<xsl:apply-templates select="/c|/c01|/c02|/c03|/c04|/c05|/c06|/c07|/c08|/c09|/c10|/c11|/c12|/ead/archdesc"/>
    		</xsl:otherwise>
    	</xsl:choose>	
     </div> 	  
	</form>
  </div>
  </xsl:template>
    
  
  <xsl:template match="/c|/c01|/c02|/c03|/c04|/c05|/c06|/c07|/c08|/c09|/c10|/c11|/c12|/ead/archdesc">
  <xsl:if test="not(name() = 'archdesc')">
  	<p>
   		<input type="hidden" name="ctype" id="ctype" maxlength="3" size="4">
   			<xsl:attribute name="value">
   				<xsl:value-of select="name()"/>   					
 			</xsl:attribute>
   		</input>
    </p>
  </xsl:if>
  	<div id="sec-3-1" class="section">
      <span class="isadg"><h3>3.1: Identity Statement Area</h3></span>
      <p id="unitidparent">
	  <strong><span class="isadg">3.1.1: </span>Reference Code<a href="http://www.archiveshub.ac.uk/arch/refcode.shtml" title="Reference Code help - opens in new window" target="_new"><img class="whatsthis" src="/ead/img/whatisthissmall.gif" alt="[What is this?]"/></a></strong> 
	  Comprising <a href="http://www.iso.org/iso/en/prods-services/iso3166ma/02iso-3166-code-lists/list-en1.html" target="_new" title="Further information on ISO Country Codes">ISO Country Code</a>, 
	  <a href="http://www.nationalarchives.gov.uk/archon/" target="_new" title="ARCHON Service">Archon Code</a>,
	  and a unique identifier for this record or component.
	  <xsl:if test="$leveltype = 'collection'">
	  [<strong>all fields required</strong>]
	  </xsl:if>
	  <br/>
	  <xsl:choose>
	  	<xsl:when test="did/unitid[1]">
	  	   <xsl:apply-templates select="did/unitid[1]"/>
	  	</xsl:when>
	  	<xsl:otherwise>
	  		<input type="text" onfocus="setCurrent(this);" name="did/unitid/@countrycode" id="countrycode" maxlength="2" size="3" value="GB" onblur="checkId(true)"></input>
			<input type="text" onfocus="setCurrent(this);" name="did/unitid/@repositorycode" id="archoncode" maxlength="4" size="5" onblur="checkId(true)"></input>
			<input type="text" onfocus="setCurrent(this);" name="did/unitid" id="unitid" size="50" onblur="checkId(true)"></input>	
	  	</xsl:otherwise>
	  </xsl:choose>  		
  	</p>
   	<p>
		<strong><span class="isadg">3.1.2: </span>Title<a href="http://www.archiveshub.ac.uk/arch/title.shtml" title="Title help - opens in new window" target="_new"><img class="whatsthis" src="/ead/img/whatisthissmall.gif" alt="[What is this?]"/></a></strong><br/>
		<xsl:choose>
			<xsl:when test="did/unittitle">
				<xsl:apply-templates select="did/unittitle"/>
			</xsl:when>
			<xsl:otherwise>
				<input class="menuField" type="text" onfocus="setCurrent(this);" name="did/unittitle" id="did/unittitle" size="80" onchange="updateTitle(this)" onkeypress="validateFieldDelay(this, 'true');"></input>
			</xsl:otherwise>
		</xsl:choose>		
    </p>
   <div class="float">
    	<p><strong><span class="isadg">3.1.3: </span>Dates of Creation<a href="http://www.archiveshub.ac.uk/arch/dates.shtml" title="Dates of Creation help - opens in new window" target="_new"><img class="whatsthis" src="/ead/img/whatisthissmall.gif" alt="[What is this?]"/></a></strong><br/>
		<xsl:choose>
			<xsl:when test="did/unitdate">
				<xsl:apply-templates select="did/unitdate"/>
			</xsl:when>
			<xsl:when test="did/unittitle/unitdate">
				<xsl:apply-templates select="did/unittitle/unitdate"/>
			</xsl:when>
			<xsl:otherwise>
				<input class="menuField" type="text" onfocus="setCurrent(this);" onkeypress="validateFieldDelay(this, 'true');" onchange="validateField(this, 'true');" name="did/unitdate" id="did/unitdate" size="39"></input>
			</xsl:otherwise>
		</xsl:choose>      
		</p>
	</div>
	<div class="float">
		<p>
		<strong>Normalised Date<a href="http://www.archiveshub.ac.uk/arch/dates.shtml" title="Normalised Date help - opens in new window" target="_new"><img class="whatsthis" src="/ead/img/whatisthissmall.gif" alt="[What is this?]"/></a></strong><br/>
	    	<xsl:choose>
	    		<xsl:when test="did/unitdate/@normal">
	    			<xsl:apply-templates select="did/unitdate/@normal"/>
	    		</xsl:when>
	    		<xsl:when test="did/unittitle/unitdate/@normal">
	    			<xsl:apply-templates select="did/unittitle/unitdate/@normal"/>
	    		</xsl:when>
	    		<xsl:otherwise>
	    			<input type="text" onfocus="setCurrent(this);" name="did/unitdate/@normal" id="did/unitdate/@normal" size="39" maxlength="21"></input>
	    		</xsl:otherwise>
	    	</xsl:choose>      	            
		</p>
	</div> 
  	<br/>
  	<p>
  		<xsl:if test="$leveltype = 'component'">
  			<strong><span class="isadg">3.1.4: </span>Level of Description</strong><br/>
  			<select name="@level" id="@level">
	  			<xsl:call-template name="option">
	  				<xsl:with-param name="value" select="''"/>
	  				<xsl:with-param name="label" select="'none'"/>
	  				<xsl:with-param name="select" select="$level"/>
	  			</xsl:call-template>
	  			<xsl:call-template name="option">
	  				<xsl:with-param name="value" select="'fonds'"/>
	  				<xsl:with-param name="label" select="'fonds'"/>
	  				<xsl:with-param name="select" select="$level"/>
	  			</xsl:call-template>
	  			<xsl:call-template name="option">
	  				<xsl:with-param name="value" select="'class'"/>
	  				<xsl:with-param name="label" select="'class'"/>
	  				<xsl:with-param name="select" select="$level"/>
	  			</xsl:call-template>
	  			<xsl:call-template name="option">
	  				<xsl:with-param name="value" select="'series'"/>
	  				<xsl:with-param name="label" select="'series'"/>
	  				<xsl:with-param name="select" select="$level"/>
	  			</xsl:call-template>
	  			<xsl:call-template name="option">
	  				<xsl:with-param name="value" select="'subfonds'"/>
	  				<xsl:with-param name="label" select="'subfonds'"/>
	  				<xsl:with-param name="select" select="$level"/>
	  			</xsl:call-template>
	  			<xsl:call-template name="option">
	  				<xsl:with-param name="value" select="'subseries'"/>
	  				<xsl:with-param name="label" select="'subseries'"/>
	  				<xsl:with-param name="select" select="$level"/>
	  			</xsl:call-template>
	  			<xsl:call-template name="option">
	  				<xsl:with-param name="value" select="'file'"/>
	  				<xsl:with-param name="label" select="'file'"/>
	  				<xsl:with-param name="select" select="$level"/>
	  			</xsl:call-template>
	  			<xsl:call-template name="option">
	  				<xsl:with-param name="value" select="'item'"/>
	  				<xsl:with-param name="label" select="'item'"/>
	  				<xsl:with-param name="select" select="$level"/>
	  			</xsl:call-template>
	  			<xsl:call-template name="option">
	  				<xsl:with-param name="value" select="'otherlevel'"/>
	  				<xsl:with-param name="label" select="'otherlevel'"/>
	  				<xsl:with-param name="select" select="$level"/>
	  			</xsl:call-template>
  			</select>
		</xsl:if>
  	</p>
 	<p>
		<strong><span class="isadg">3.1.5: </span>Extent of Unit of Description<a href="http://www.archiveshub.ac.uk/arch/extent.shtml" title="Extent help - opens in new window" target="_new"><img class="whatsthis" src="/ead/img/whatisthissmall.gif" alt="[What is this?]"/></a></strong><br/>
		<xsl:choose>
			<xsl:when test="did/physdesc/extent">
				<xsl:apply-templates select="did/physdesc/extent"/>
			</xsl:when>
			<xsl:otherwise>
				<input class="menuField" type="text" onfocus="setCurrent(this);" onkeypress="validateFieldDelay(this, 'true');" onchange="validateField(this, 'true');" name="did/physdesc/extent" id="did/physdesc/extent" size="80"></input>
			</xsl:otherwise>
		</xsl:choose>		
    </p>
    <xsl:if test="$leveltype = 'collection'">
	    <p>
	  		<strong>Repository</strong><a id="repositoryhelp" name="repositoryhelp" target="_new" href="http://www.archiveshub.ac.uk/arch/repository.shtml">
		<img class="whatsthis" src="/ead/img/whatisthissmall.gif" alt="[What is this?]"/>
		</a><br/>
	  		<xsl:choose>
				<xsl:when test="did/repository">
					<xsl:apply-templates select="did/repository"/>
				</xsl:when>
				<xsl:otherwise>
					<input class="menuField" type="text" onfocus="setCurrent(this);" onkeypress="validateFieldDelay(this, 'true');" onchange="validateField(this, 'true');" name="did/repository" id="did/repository" size="80"></input>
				</xsl:otherwise>
			</xsl:choose>
	  	</p>
	  	<p>  		
	  		<xsl:choose>
			 	<xsl:when test="../eadheader/filedesc/titlestmt/sponsor">				
					<xsl:apply-templates select="../eadheader/filedesc/titlestmt/sponsor"/>
				</xsl:when> 
				<xsl:otherwise>
					<strong>Sponsor</strong><a id="sponsorhelp" name="sponsorhelp" target="_new" href="http://www.archiveshub.ac.uk/arch/sponsor.shtml ">
		<img class="whatsthis" src="/ead/img/whatisthissmall.gif" alt="[What is this?]"/>
		</a><a class="smalllink" id="linkfiledesc/titlestmt/sponsor" title="add sponsor" onclick="addElement('filedesc/titlestmt/sponsor')">add content</a> [optional]<br/>
					<input class="menuField" type="text" onkeypress="validateFieldDelay(this, 'true');" onchange="validateField(this, 'true');" onfocus="setCurrent(this);" name="filedesc/titlestmt/sponsor" id="filedesc/titlestmt/sponsor" size="80" style="display:none"></input>
				</xsl:otherwise>
			</xsl:choose>
	  	</p>  
  	</xsl:if>
   </div>
<!--  -->
<!-- CONTEXT -->  
<!--  --> 
   <div class="section">
		<span class="isadg"><h3>3.2: Context Area</h3></span> 
		<p>
		<strong><span class="isadg">3.2.1: </span>Name of Creator<a href="http://www.archiveshub.ac.uk/arch/name.shtml" title="Name of Creator help - opens in new window" target="_new"><img class="whatsthis" src="/ead/img/whatisthissmall.gif" alt="[What is this?]"/></a></strong>  [<strong>also add manually as <a href="#accesspoints" title="Add Access Point manually">Access Point</a></strong>]<br/>
		<xsl:choose>
			<xsl:when test="did/origination">
				<xsl:apply-templates select="did/origination"/>
			</xsl:when>
			<xsl:otherwise>
				<input class="menuField" type="text" onfocus="setCurrent(this);" onkeypress="validateFieldDelay(this, 'true');" onchange="validateField(this, 'true');" name="did/origination" id="did/origination" size="80"></input>
			</xsl:otherwise>
		</xsl:choose>		
    	</p>
<!-- bioghist -->
    <p>	  	
    	<xsl:variable name="content">
		<xsl:choose>
			<xsl:when test="bioghist">
				<xsl:text>true</xsl:text>			
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>false</xsl:text>
			</xsl:otherwise>			
		</xsl:choose>  
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$content = 'true'">
				<xsl:for-each select="bioghist">
					<xsl:call-template name="textarea">
						<xsl:with-param name="name" select="concat('bioghist[', position(), ']')"/>
						<xsl:with-param name="class" select="'menuField'"/>
						<xsl:with-param name="optional" select="'false'"/>
						<xsl:with-param name="content" select="$content"/>
						<xsl:with-param name="isadg" select="'3.2.2: '"/>
						<xsl:with-param name="title" select="'Administrative/Biographical History'"/>
						<xsl:with-param name="help" select="'http://www.archiveshub.ac.uk/arch/bioghist.shtml'"/>
					</xsl:call-template>
			   </xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="textarea">
					<xsl:with-param name="name" select="concat('bioghist[', position(), ']')"/>
					<xsl:with-param name="class" select="'menuField'"/>
					<xsl:with-param name="optional" select="'false'"/>
					<xsl:with-param name="content" select="$content"/>
					<xsl:with-param name="isadg" select="'3.2.2: '"/>
					<xsl:with-param name="title" select="'Administrative/Biographical History'"/>
					<xsl:with-param name="help" select="'http://www.archiveshub.ac.uk/arch/bioghist.shtml'"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	   </p>
	   
<!-- custodhist -->
	   <p>
	   <xsl:variable name="content">
			<xsl:choose>
				<xsl:when test="custodhist">
					<xsl:text>true</xsl:text>				
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>false</xsl:text>
				</xsl:otherwise>			
			</xsl:choose>
		</xsl:variable>  
		<xsl:choose>
			<xsl:when test="$content = 'true'">
				<xsl:for-each select="custodhist">
					<xsl:call-template name="textarea">
						<xsl:with-param name="name" select="concat('custodhist[', position(), ']')"/>
						<xsl:with-param name="class" select="'menuField'"/>
						<xsl:with-param name="optional" select="'true'"/>
						<xsl:with-param name="content" select="$content"/>
						<xsl:with-param name="isadg" select="'3.2.3: '"/>
						<xsl:with-param name="title" select="'Archival History'"/>
						<xsl:with-param name="help" select="'http://www.archiveshub.ac.uk/arch/custodhist.html'"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="textarea">
					<xsl:with-param name="name" select="concat('custodhist[', position(), ']')"/>
					<xsl:with-param name="class" select="'menuField'"/>
					<xsl:with-param name="optional" select="'true'"/>
					<xsl:with-param name="content" select="$content"/>
					<xsl:with-param name="isadg" select="'3.2.3: '"/>
					<xsl:with-param name="title" select="'Archival History'"/>
					<xsl:with-param name="help" select="'http://www.archiveshub.ac.uk/arch/custodhist.html'"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	   </p>
<!-- acqinfo -->
	   <p>
	   <xsl:variable name="content">
			<xsl:choose>
				<xsl:when test="acqinfo">
					<xsl:text>true</xsl:text>				
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>false</xsl:text>
				</xsl:otherwise>			
			</xsl:choose>
		</xsl:variable>  
		<xsl:choose>
			<xsl:when test="$content = 'true'">
				<xsl:for-each select="acqinfo">
			      	<xsl:call-template name="textarea">
						<xsl:with-param name="name" select="concat('acqinfo[', position(), ']')"/>
						<xsl:with-param name="class" select="'menuField'"/>
						<xsl:with-param name="optional" select="'true'"/>
						<xsl:with-param name="content" select="$content"/>
						<xsl:with-param name="isadg" select="'3.2.4: '"/>
						<xsl:with-param name="title" select="'Immediate Source of Acquisition'"/>
						<xsl:with-param name="help" select="'http://www.archiveshub.ac.uk/arch/acqinfo.html'"/>
					</xsl:call-template>	
				</xsl:for-each>	
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="textarea">
					<xsl:with-param name="name" select="concat('acqinfo[', position(), ']')"/>
					<xsl:with-param name="class" select="'menuField'"/>
					<xsl:with-param name="optional" select="'true'"/>
					<xsl:with-param name="content" select="$content"/>
					<xsl:with-param name="isadg" select="'3.2.4: '"/>
					<xsl:with-param name="title" select="'Immediate Source of Acquisition'"/>
					<xsl:with-param name="help" select="'http://www.archiveshub.ac.uk/arch/acqinfo.html'"/>
				</xsl:call-template>	
			</xsl:otherwise>
		</xsl:choose>
      	</p>       
    </div>	    
 <!--  -->   
 <!-- CONTENT AND STRUCTURE -->   
 <!--  -->
    <div class="section">
	<span class="isadg"><h3>3.3: Content and Structure Area</h3></span> 
 <!-- scopecontent -->
	 <p>
	 <xsl:variable name="content">
			<xsl:choose>
				<xsl:when test="scopecontent">
					<xsl:text>true</xsl:text>				
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>false</xsl:text>
				</xsl:otherwise>			
			</xsl:choose>
		</xsl:variable>  
		<xsl:choose>
			<xsl:when test="$content = 'true'">
				<xsl:for-each select="scopecontent">
			      	<xsl:call-template name="textarea">
						<xsl:with-param name="name" select="concat('scopecontent[', position(), ']')"/>
						<xsl:with-param name="class" select="'menuField'"/>
						<xsl:with-param name="optional" select="'false'"/>
						<xsl:with-param name="content" select="$content"/>
						<xsl:with-param name="isadg" select="'3.3.1: '"/>
						<xsl:with-param name="title" select="'Scope and Content'"/>
						<xsl:with-param name="help" select="'http://www.archiveshub.ac.uk/arch/scope.shtml'"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="textarea">
					<xsl:with-param name="name" select="concat('scopecontent[', position(), ']')"/>
					<xsl:with-param name="class" select="'menuField'"/>
					<xsl:with-param name="optional" select="'false'"/>
					<xsl:with-param name="content" select="$content"/>
					<xsl:with-param name="isadg" select="'3.3.1: '"/>
					<xsl:with-param name="title" select="'Scope and Content'"/>
					<xsl:with-param name="help" select="'http://www.archiveshub.ac.uk/arch/scope.shtml'"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
      </p> 
<!-- appraisal -->     
      <p>
      <xsl:variable name="content">
			<xsl:choose>
				<xsl:when test="appraisal">
					<xsl:text>true</xsl:text>				
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>false</xsl:text>
				</xsl:otherwise>			
			</xsl:choose>
		</xsl:variable>  
		<xsl:choose>
			<xsl:when test="$content = 'true'">
				<xsl:for-each select="appraisal">
			      	<xsl:call-template name="textarea">
						<xsl:with-param name="name" select="concat('appraisal[', position(), ']')"/>
						<xsl:with-param name="class" select="'menuField'"/>
						<xsl:with-param name="optional" select="'true'"/>
						<xsl:with-param name="content" select="$content"/>
						<xsl:with-param name="isadg" select="'3.3.2: '"/>
						<xsl:with-param name="title" select="'Appraisal'"/>
						<xsl:with-param name="help" select="'http://www.archiveshub.ac.uk/arch/appraisal.html'"/>
					</xsl:call-template>	
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="textarea">
					<xsl:with-param name="name" select="concat('appraisal[', position(), ']')"/>
					<xsl:with-param name="class" select="'menuField'"/>
					<xsl:with-param name="optional" select="'true'"/>
					<xsl:with-param name="content" select="$content"/>
					<xsl:with-param name="isadg" select="'3.3.2: '"/>
					<xsl:with-param name="title" select="'Appraisal'"/>
					<xsl:with-param name="help" select="'http://www.archiveshub.ac.uk/arch/appraisal.html'"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
      </p>
<!-- accruals -->
      <p>
      <xsl:variable name="content">
			<xsl:choose>
				<xsl:when test="accruals">
					<xsl:text>true</xsl:text>				
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>false</xsl:text>
				</xsl:otherwise>			
			</xsl:choose>
		</xsl:variable>  
		<xsl:choose>
			<xsl:when test="$content = 'true'">
				<xsl:for-each select="accruals">
			      	<xsl:call-template name="textarea">
						<xsl:with-param name="name" select="concat('accruals[', position(), ']')"/>
						<xsl:with-param name="class" select="'menuField'"/>
						<xsl:with-param name="optional" select="'true'"/>
						<xsl:with-param name="content" select="$content"/>
						<xsl:with-param name="isadg" select="'3.3.3: '"/>
						<xsl:with-param name="title" select="'Accruals'"/>
						<xsl:with-param name="help" select="'http://www.archiveshub.ac.uk/arch/accruals.html'"/>
					</xsl:call-template>
				</xsl:for-each>	
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="textarea">
					<xsl:with-param name="name" select="concat('accruals[', position(), ']')"/>
					<xsl:with-param name="class" select="'menuField'"/>
					<xsl:with-param name="optional" select="'true'"/>
					<xsl:with-param name="content" select="$content"/>
					<xsl:with-param name="isadg" select="'3.3.3: '"/>
					<xsl:with-param name="title" select="'Accruals'"/>
					<xsl:with-param name="help" select="'http://www.archiveshub.ac.uk/arch/accruals.html'"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
      </p>
<!-- arrangement -->
      <p>
      <xsl:variable name="content">
			<xsl:choose>
				<xsl:when test="arrangement">
					<xsl:text>true</xsl:text>				
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>false</xsl:text>
				</xsl:otherwise>			
			</xsl:choose>
		</xsl:variable>  
		<xsl:choose>
			<xsl:when test="$content = 'true'">
				<xsl:for-each select="arrangement">
			      	<xsl:call-template name="textarea">
						<xsl:with-param name="name" select="concat('arrangement[', position(), ']')"/>
						<xsl:with-param name="class" select="'menuField'"/>
						<xsl:with-param name="optional" select="'true'"/>
						<xsl:with-param name="content" select="$content"/>
						<xsl:with-param name="isadg" select="'3.3.4: '"/>
						<xsl:with-param name="title" select="'System of Arrangement'"/>
						<xsl:with-param name="help" select="'http://www.archiveshub.ac.uk/arch/arrangement.html'"/>
					</xsl:call-template>	
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="textarea">
					<xsl:with-param name="name" select="concat('arrangement[', position(), ']')"/>
					<xsl:with-param name="class" select="'menuField'"/>
					<xsl:with-param name="optional" select="'true'"/>
					<xsl:with-param name="content" select="$content"/>
					<xsl:with-param name="isadg" select="'3.3.4: '"/>
					<xsl:with-param name="title" select="'System of Arrangement'"/>
					<xsl:with-param name="help" select="'http://www.archiveshub.ac.uk/arch/arrangement.html'"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
      </p>
    </div>
<!--  -->
<!-- ACCESS -->
<!--  -->
    <div class="section">
	<span class="isadg"><h3>3.4: Conditions of Access and Use Area</h3></span>
<!-- accessrestrict -->  
	<p>
	<xsl:variable name="content">
		<xsl:choose>
			<xsl:when test="accessrestrict">
				<xsl:text>true</xsl:text>				
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>false</xsl:text>
			</xsl:otherwise>			
		</xsl:choose>
	</xsl:variable>  
	<xsl:choose>
		<xsl:when test="$content = 'true'">
			<xsl:for-each select="accessrestrict">
			    <xsl:call-template name="textarea">
					<xsl:with-param name="name" select="concat('accessrestrict[', position(), ']')"/>
					<xsl:with-param name="class" select="'menuField'"/>
					<xsl:with-param name="optional" select="'false'"/>
					<xsl:with-param name="content" select="$content"/>
					<xsl:with-param name="isadg" select="'3.4.1: '"/>
					<xsl:with-param name="title" select="'Conditions Governing Access'"/>
					<xsl:with-param name="help" select="'http://www.archiveshub.ac.uk/arch/restrict.shtml'"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="textarea">
				<xsl:with-param name="name" select="concat('accessrestrict[', position(), ']')"/>
				<xsl:with-param name="class" select="'menuField'"/>
				<xsl:with-param name="optional" select="'false'"/>
				<xsl:with-param name="content" select="$content"/>
				<xsl:with-param name="isadg" select="'3.4.1: '"/>
				<xsl:with-param name="title" select="'Conditions Governing Access'"/>
				<xsl:with-param name="help" select="'http://www.archiveshub.ac.uk/arch/restrict.shtml'"/>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
	</p>  
<!-- userestrict --> 
 	<p>
	<xsl:variable name="content">
		<xsl:choose>
			<xsl:when test="userestrict">
				<xsl:text>true</xsl:text>				
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>false</xsl:text>
			</xsl:otherwise>			
		</xsl:choose>
	</xsl:variable>  
	<xsl:choose>
		<xsl:when test="$content = 'true'">
			<xsl:for-each select="userestrict">
			    <xsl:call-template name="textarea">
					<xsl:with-param name="name" select="concat('userestrict[', position(), ']')"/>
					<xsl:with-param name="class" select="'menuField'"/>
					<xsl:with-param name="optional" select="'true'"/>
					<xsl:with-param name="content" select="$content"/>
					<xsl:with-param name="isadg" select="'3.4.2: '"/>
					<xsl:with-param name="title" select="'Conditions Governing Reproduction'"/>
					<xsl:with-param name="help" select="'http://www.archiveshub.ac.uk/arch/userestrict.html'"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="textarea">
				<xsl:with-param name="name" select="concat('userestrict[', position(), ']')"/>
				<xsl:with-param name="class" select="'menuField'"/>
				<xsl:with-param name="optional" select="'true'"/>
				<xsl:with-param name="content" select="$content"/>
				<xsl:with-param name="isadg" select="'3.4.2: '"/>
				<xsl:with-param name="title" select="'Conditions Governing Reproduction'"/>
				<xsl:with-param name="help" select="'http://www.archiveshub.ac.uk/arch/userestrict.html'"/>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
	</p> 
<!-- langmaterial -->
     <p>
     	<strong><span class="isadg">3.4.3: </span>Language of Material</strong><a href="http://www.archiveshub.ac.uk/arch/lang.shtml" title="Language of Material help - opens in new window" target="_new"><img class="whatsthis" src="/ead/img/whatisthissmall.gif" alt="[What is this?]"/></a> [Must include <a href="http://www.loc.gov/standards/iso639-2/php/English_list.php" title="ISO 639-2 codes - opens new window" target="_new">ISO 639-2 3-letter code</a>]
     	<xsl:for-each select="did/langmaterial/@*">
     		<input type="hidden">
     			<xsl:attribute name="name">
     				<xsl:text>did/langmaterial/@</xsl:text><xsl:value-of select="name()"/>
     			</xsl:attribute>
     			<xsl:attribute name="value">
     				<xsl:value-of select="."/>
     			</xsl:attribute>
     		</input>
		</xsl:for-each>    	
     	<div id="language" class="langcontainer">
     	<xsl:choose>
     		<xsl:when test="did/langmaterial/language">
     			<xsl:apply-templates select="did/langmaterial"/>
     		</xsl:when>
     		<xsl:otherwise>		     			
				<div id="addedlanguages" style="display:none" class="added"><xsl:text> </xsl:text></div>		
     		</xsl:otherwise>
     	</xsl:choose>
     		<div id="languagetable" class="tablecontainer">
  				<table>
  					<tbody>
      					<tr><td> 3-letter ISO code:</td><td> <input type="text" id="lang_code" onfocus="setCurrent(this);" maxlength="3" size="5"></input></td></tr>
						<tr><td> Language:</td><td> <input type="text" id="lang_name" onfocus="setCurrent(this);" size="30"></input></td></tr>
  					</tbody>
  				</table>
			</div>
  			<div id="languagebuttons" class="buttoncontainer">
      			<input class="apbutton" type="button" onclick="addLanguage();" value="Add to Record" ></input><br/>
  				<input class="apbutton" type="button" onclick="resetAccessPoint('language');" value="Reset" ></input>
  			</div>
    	</div>
    	<br/>		     	
     </p>
<!-- phystech -->
	<p>
	<xsl:variable name="content">
		<xsl:choose>
			<xsl:when test="phystech">
				<xsl:text>true</xsl:text>				
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>false</xsl:text>
			</xsl:otherwise>			
		</xsl:choose>
	</xsl:variable>  
	<xsl:choose>
		<xsl:when test="$content = 'true'">
			<xsl:for-each select="phystech">
			    <xsl:call-template name="textarea">
					<xsl:with-param name="name" select="concat('phystech[', position(), ']')"/>
					<xsl:with-param name="class" select="'menuField'"/>
					<xsl:with-param name="optional" select="'true'"/>
					<xsl:with-param name="content" select="$content"/>
					<xsl:with-param name="isadg" select="'3.4.4: '"/>
					<xsl:with-param name="title" select="'Physical Characteristics'"/>
					<xsl:with-param name="help" select="'http://www.archiveshub.ac.uk/arch/phystech.html'"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:when>
		<xsl:otherwise>
			 <xsl:call-template name="textarea">
					<xsl:with-param name="name" select="concat('phystech[', position(), ']')"/>
					<xsl:with-param name="class" select="'menuField'"/>
					<xsl:with-param name="optional" select="'true'"/>
					<xsl:with-param name="content" select="$content"/>
					<xsl:with-param name="isadg" select="'3.4.4: '"/>
					<xsl:with-param name="title" select="'Physical Characteristics'"/>
					<xsl:with-param name="help" select="'http://www.archiveshub.ac.uk/arch/phystech.html'"/>
				</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
	</p>
<!-- otherfindaid -->	
	<xsl:if test="$leveltype = 'collection'">
	<p>
	<xsl:variable name="content">
		<xsl:choose>
			<xsl:when test="otherfindaid">
				<xsl:text>true</xsl:text>				
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>false</xsl:text>
			</xsl:otherwise>			
		</xsl:choose>
	</xsl:variable>  
	<xsl:choose>
		<xsl:when test="$content = 'true'">
			<xsl:for-each select="otherfindaid">
			    <xsl:call-template name="textarea">
					<xsl:with-param name="name" select="concat('otherfindaid[', position(), ']')"/>
					<xsl:with-param name="class" select="'menuField'"/>
					<xsl:with-param name="optional" select="'false'"/>
					<xsl:with-param name="content" select="$content"/>
					<xsl:with-param name="isadg" select="'3.4.5: '"/>
					<xsl:with-param name="title" select="'Finding Aids'"/>
					<xsl:with-param name="help" select="'http://www.archiveshub.ac.uk/arch/other.shtml'"/>					
				</xsl:call-template>	
			</xsl:for-each>		
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="textarea">
				<xsl:with-param name="name" select="concat('otherfindaid[', position(), ']')"/>
				<xsl:with-param name="class" select="'menuField'"/>
				<xsl:with-param name="optional" select="'false'"/>
				<xsl:with-param name="content" select="$content"/>
				<xsl:with-param name="isadg" select="'3.4.5: '"/>
				<xsl:with-param name="title" select="'Finding Aids'"/>
				<xsl:with-param name="help" select="'http://www.archiveshub.ac.uk/arch/other.shtml'"/>
			</xsl:call-template>	
		</xsl:otherwise>
	</xsl:choose>
	</p>	
	</xsl:if>	     					
	</div>
<!--  -->
<!-- ALLIED MATERIALS -->
<!--  -->
	<div class="section">
    <span class="isadg"><h3>3.5: Allied Materials Area</h3></span>
<!-- originalsloc -->  
    <p>
    <xsl:variable name="content">
		<xsl:choose>
			<xsl:when test="originalsloc">
				<xsl:text>true</xsl:text>				
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>false</xsl:text>
			</xsl:otherwise>			
		</xsl:choose>
	</xsl:variable>  
	<xsl:choose>
		<xsl:when test="$content = 'true'">
			<xsl:for-each select="originalsloc">
		     	<xsl:call-template name="textarea">
					<xsl:with-param name="name" select="concat('originalsloc[', position(), ']')"/>
					<xsl:with-param name="class" select="'menuField'"/>
					<xsl:with-param name="optional" select="'true'"/>
					<xsl:with-param name="content" select="$content"/>
					<xsl:with-param name="isadg" select="'3.5.1: '"/>
					<xsl:with-param name="title" select="'Existence/Location of Originals'"/>
					<xsl:with-param name="help" select="'http://www.archiveshub.ac.uk/arch/originalsloc.html'"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="textarea">
				<xsl:with-param name="name" select="concat('originalsloc[', position(), ']')"/>
				<xsl:with-param name="class" select="'menuField'"/>
				<xsl:with-param name="optional" select="'true'"/>
				<xsl:with-param name="content" select="$content"/>
				<xsl:with-param name="isadg" select="'3.5.1: '"/>
				<xsl:with-param name="title" select="'Existence/Location of Originals'"/>
				<xsl:with-param name="help" select="'http://www.archiveshub.ac.uk/arch/originalsloc.html'"/>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
    </p> 
<!-- altformavail -->
	<p>
	 <xsl:variable name="content">
		<xsl:choose>
			<xsl:when test="altformavail">
				<xsl:text>true</xsl:text>				
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>false</xsl:text>
			</xsl:otherwise>			
		</xsl:choose>
	</xsl:variable>  
	<xsl:choose>
		<xsl:when test="$content = 'true'">
			<xsl:for-each select="altformavail">
			    <xsl:call-template name="textarea">
					<xsl:with-param name="name" select="concat('altformavail[', position(), ']')"/>
					<xsl:with-param name="class" select="'menuField'"/>
					<xsl:with-param name="optional" select="'true'"/>
					<xsl:with-param name="content" select="$content"/>
					<xsl:with-param name="isadg" select="'3.5.2: '"/>
					<xsl:with-param name="title" select="'Existence/Location of Copies'"/>
					<xsl:with-param name="help" select="'http://www.archiveshub.ac.uk/arch/altformavail.html'"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="textarea">
				<xsl:with-param name="name" select="concat('altformavail[', position(), ']')"/>
				<xsl:with-param name="class" select="'menuField'"/>
				<xsl:with-param name="optional" select="'true'"/>
				<xsl:with-param name="content" select="$content"/>
				<xsl:with-param name="isadg" select="'3.5.2: '"/>
				<xsl:with-param name="title" select="'Existence/Location of Copies'"/>
				<xsl:with-param name="help" select="'http://www.archiveshub.ac.uk/arch/altformavail.html'"/>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
	</p>
<!-- relatedmaterial -->
	<p>
	<xsl:variable name="content">
		<xsl:choose>
			<xsl:when test="relatedmaterial">
				<xsl:text>true</xsl:text>				
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>false</xsl:text>
			</xsl:otherwise>			
		</xsl:choose>
	</xsl:variable>  
	<xsl:choose>
		<xsl:when test="$content = 'true'">
			<xsl:for-each select="relatedmaterial">
		     	<xsl:call-template name="textarea">
					<xsl:with-param name="name" select="concat('relatedmaterial[', position(), ']')"/>
					<xsl:with-param name="class" select="'menuField'"/>
					<xsl:with-param name="optional" select="'true'"/>
					<xsl:with-param name="content" select="$content"/>
					<xsl:with-param name="isadg" select="'3.5.3: '"/>
					<xsl:with-param name="title" select="'Related Units of Description'"/>
					<xsl:with-param name="help" select="'http://www.archiveshub.ac.uk/arch/relatedmaterial.html'"/>
				</xsl:call-template>
			</xsl:for-each>		
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="textarea">
				<xsl:with-param name="name" select="concat('relatedmaterial[', position(), ']')"/>
				<xsl:with-param name="class" select="'menuField'"/>
				<xsl:with-param name="optional" select="'true'"/>
				<xsl:with-param name="content" select="$content"/>
				<xsl:with-param name="isadg" select="'3.5.3: '"/>
				<xsl:with-param name="title" select="'Related Units of Description'"/>
				<xsl:with-param name="help" select="'http://www.archiveshub.ac.uk/arch/relatedmaterial.html'"/>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
    </p>
<!-- bibliography -->
	<p>
	<xsl:variable name="content">
		<xsl:choose>
			<xsl:when test="bibliography">
				<xsl:text>true</xsl:text>				
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>false</xsl:text>
			</xsl:otherwise>			
		</xsl:choose>
	</xsl:variable>  
	<xsl:choose>
		<xsl:when test="$content = 'true'">
			<xsl:for-each select="bibliography">
		     	<xsl:call-template name="textarea">
					<xsl:with-param name="name" select="concat('bibliography[', position(), ']')"/>
					<xsl:with-param name="class" select="'menuField'"/>
					<xsl:with-param name="optional" select="'true'"/>
					<xsl:with-param name="content" select="$content"/>
					<xsl:with-param name="isadg" select="'3.5.4: '"/>
					<xsl:with-param name="title" select="'Publication Note'"/>
					<xsl:with-param name="help" select="'http://www.archiveshub.ac.uk/arch/bibliography.html'"/>
					<xsl:with-param name="additional" select="'[Works based on or about the collection]'"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="textarea">
				<xsl:with-param name="name" select="concat('bibliography[', position(), ']')"/>
				<xsl:with-param name="class" select="'menuField'"/>
				<xsl:with-param name="optional" select="'true'"/>
				<xsl:with-param name="content" select="$content"/>
				<xsl:with-param name="isadg" select="'3.5.4: '"/>
				<xsl:with-param name="title" select="'Publication Note'"/>
				<xsl:with-param name="help" select="'http://www.archiveshub.ac.uk/arch/bibliography.html'"/>
				<xsl:with-param name="additional" select="'[Works based on or about the collection]'"/>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
	</p>
	</div>
<!--  -->
<!-- NOTE AREA -->	
<!--  -->
	<div class="section">
	<span class="isadg"><h3>3.6: Note Area</h3></span> 
<!-- note -->
	<p>
	<xsl:variable name="content">
		<xsl:choose>
			<xsl:when test="note">
				<xsl:text>true</xsl:text>				
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>false</xsl:text>
			</xsl:otherwise>			
		</xsl:choose>
	</xsl:variable>  
	<xsl:choose>
		<xsl:when test="$content = 'true'">
			<xsl:for-each select="note">
		     	<xsl:call-template name="textarea">
					<xsl:with-param name="name" select="concat('note[', position(), ']')"/>
					<xsl:with-param name="class" select="'menuField'"/>
					<xsl:with-param name="optional" select="'true'"/>
					<xsl:with-param name="content" select="$content"/>
					<xsl:with-param name="isadg" select="'3.6.1: '"/>
					<xsl:with-param name="title" select="'Note'"/>
					<xsl:with-param name="help" select="'http://www.archiveshub.ac.uk/arch/note.html'"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="textarea">
					<xsl:with-param name="name" select="concat('note[', position(), ']')"/>
					<xsl:with-param name="class" select="'menuField'"/>
					<xsl:with-param name="optional" select="'true'"/>
					<xsl:with-param name="content" select="$content"/>
					<xsl:with-param name="isadg" select="'3.6.1: '"/>
					<xsl:with-param name="title" select="'Note'"/>
					<xsl:with-param name="help" select="'http://www.archiveshub.ac.uk/arch/note.html'"/>
				</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
	</p>
	</div>
<!--  -->
<!-- DESCRIPTION AREA -->
<!--  -->
	<xsl:if test="$leveltype = 'collection'">
	<div class="section">
	<span class="isadg"><h3>3.7: Description Area</h3></span> 
<!-- processinfo -->
	<p>
	<xsl:variable name="content">
		<xsl:choose>
			<xsl:when test="processinfo">
				<xsl:text>true</xsl:text>				
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>false</xsl:text>
			</xsl:otherwise>			
		</xsl:choose>
	</xsl:variable> 
	<xsl:choose>
		<xsl:when test="$content = 'true'">
			<xsl:for-each select="processinfo"> 
		     	<xsl:call-template name="textarea">
					<xsl:with-param name="name" select="concat('processinfo[', position(), ']')"/>
					<xsl:with-param name="class" select="'menuField'"/>
					<xsl:with-param name="optional" select="'false'"/>
					<xsl:with-param name="content" select="$content"/>
					<xsl:with-param name="isadg" select="'3.7.1: '"/>
					<xsl:with-param name="title" select='"Archivist&apos;s Note"'/>
					<xsl:with-param name="help" select="'http://www.archiveshub.ac.uk/arch/archnote.shtml'"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="textarea">
				<xsl:with-param name="name" select="concat('processinfo[', position(), ']')"/>
				<xsl:with-param name="class" select="'menuField'"/>
				<xsl:with-param name="optional" select="'false'"/>
				<xsl:with-param name="content" select="$content"/>
				<xsl:with-param name="isadg" select="'3.7.1: '"/>
				<xsl:with-param name="title" select='"Archivist&apos;s Note"'/>
				<xsl:with-param name="help" select="'http://www.archiveshub.ac.uk/arch/archnote.shtml'"/>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
	</p>
	</div>
	</xsl:if>
<!--  -->
<!--  -->
<!--  -->
<!-- DIGITAL OBJECTS -->
	<div id="digitalobjectssection" class="section">
		<h3>Digital Objects<a id="daohelp" name="daohelp" target="_new" href="http://www.archiveshub.ac.uk/arch/dao.shtml">
		<img class="whatsthis" src="/ead/img/whatisthissmall.gif" alt="[What is this?]"/>
		</a></h3>
		<div id="daocontainer">
			<!-- Digital Object not in did -->							
			<xsl:if test="dao">				
				<xsl:for-each select="dao">
					<xsl:choose>
						<xsl:when test="@show='embed'">
							<div class="embed">
								<xsl:attribute name="id">
									<xsl:text>daoformxdao</xsl:text><xsl:value-of select="position()"/>
								</xsl:attribute>
								<b>Display image</b>
								<xsl:call-template name="dao">
									<xsl:with-param name="type" select="'embed'"/>
									<xsl:with-param name="number" select="position()"/>
								</xsl:call-template>
								<input type="button" value="Delete">
									<xsl:attribute name="onclick">
										<xsl:text>deleteDao('daoformxdao</xsl:text><xsl:value-of select="position()"/><xsl:text>')</xsl:text>
									</xsl:attribute>					
								</input>
							</div>						
						</xsl:when>
						<xsl:otherwise>
							<div class="new">
								<xsl:attribute name="id">
									<xsl:text>daoformxdao</xsl:text><xsl:value-of select="position()"/>
								</xsl:attribute>
								<b>Link to file</b>
								<xsl:call-template name="dao">
									<xsl:with-param name="type" select="'new'"/>
									<xsl:with-param name="number" select="position()"/>
								</xsl:call-template>
								<input type="button" value="Delete">
									<xsl:attribute name="onclick">
										<xsl:text>deleteDao('daoformxdao</xsl:text><xsl:value-of select="position()"/><xsl:text>')</xsl:text>
									</xsl:attribute>					
								</input>
							</div>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:if>
			<xsl:if test="daogrp">
				<xsl:for-each select="daogrp">
					<xsl:choose>
						<xsl:when test="daoloc/@role='thumb'">
							<div class="thumb">
								<xsl:attribute name="id">
									<xsl:text>daoformxgrp</xsl:text><xsl:value-of select="position()"/>
								</xsl:attribute>
								<b>Thumbnail link to file</b>
								<xsl:call-template name="thumb">
									<xsl:with-param name="number" select="position()"/>									
								</xsl:call-template>
								<input type="button" value="Delete">
									<xsl:attribute name="onclick">
										<xsl:text>deleteDao('daoformxgrp</xsl:text><xsl:value-of select="position()"/><xsl:text>')</xsl:text>
									</xsl:attribute>					
								</input>
							</div>
						</xsl:when>
						<xsl:otherwise>
							<div class="multiple">
								<xsl:attribute name="id">
									<xsl:text>daoformxgrp</xsl:text><xsl:value-of select="position()"/>
								</xsl:attribute>
								<b>Link to multiple files</b>
								<xsl:call-template name="multiple">
									<xsl:with-param name="number" select="position()"/>	
									<xsl:with-param name="form" select="'daogrp'"/>		
									<xsl:with-param name="path" select="''"/>						
								</xsl:call-template>
								<input type="button" value="Delete">
									<xsl:attribute name="onclick">
										<xsl:text>deleteDao('daoformxgrp</xsl:text><xsl:value-of select="position()"/><xsl:text>')</xsl:text>
									</xsl:attribute>					
								</input>
							</div>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:if>
	<!-- DAO in did -->			
			<xsl:if test="did/dao">
				<xsl:for-each select="did/dao">
					<xsl:choose>
						<xsl:when test="@show='embed'">
							<div class="embed">
								<xsl:attribute name="id">
									<xsl:text>daoformxdiddao</xsl:text><xsl:value-of select="position()"/>
								</xsl:attribute>
								<b>Display image</b>
								<xsl:call-template name="dao">
									<xsl:with-param name="type" select="'embed'"/>
									<xsl:with-param name="number" select="position()"/>
									<xsl:with-param name="path" select="'did'"/>
								</xsl:call-template>
								<input type="button" value="Delete">
									<xsl:attribute name="onclick">
										<xsl:text>deleteDao('daoformxdiddao</xsl:text><xsl:value-of select="position()"/><xsl:text>')</xsl:text>
									</xsl:attribute>					
								</input>
							</div>						
						</xsl:when>
						<xsl:otherwise>
							<div class="new">
								<xsl:attribute name="id">
									<xsl:text>daoformxdiddao</xsl:text><xsl:value-of select="position()"/>
								</xsl:attribute>
								<b>Link to file</b>
								<xsl:call-template name="dao">
									<xsl:with-param name="type" select="'new'"/>
									<xsl:with-param name="number" select="position()"/>
									<xsl:with-param name="form" select="'dao'"/>
									<xsl:with-param name="path" select="'did'"/>
								</xsl:call-template>
								<input type="button" value="Delete">
									<xsl:attribute name="onclick">
										<xsl:text>deleteDao('daoformxdiddao</xsl:text><xsl:value-of select="position()"/><xsl:text>')</xsl:text>
									</xsl:attribute>					
								</input>
							</div>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:if>

		 	<xsl:if test="did/daogrp">
				<xsl:for-each select="did/daogrp">
					<xsl:choose>
						<xsl:when test="daoloc/@role='thumb'">
							<div class="thumb">
								<xsl:attribute name="id">
									<xsl:text>daoformxdidgrp</xsl:text><xsl:value-of select="position()"/>
								</xsl:attribute>
								<b>Thumbnail link to file</b>
								<xsl:call-template name="thumb">
									<xsl:with-param name="number" select="position()"/>	
									<xsl:with-param name="path" select="'did'"/>								
								</xsl:call-template>
								<input type="button" value="Delete">
									<xsl:attribute name="onclick">
										<xsl:text>deleteDao('daoformxdidgrp</xsl:text><xsl:value-of select="position()"/><xsl:text>')</xsl:text>
									</xsl:attribute>					
								</input>	
							</div>
						</xsl:when>
						<xsl:otherwise>
							<div class="multiple">
								<xsl:attribute name="id">
									<xsl:text>daoformxdidgrp</xsl:text><xsl:value-of select="position()"/>
								</xsl:attribute>
								<b>Link to multiple files</b>
								<xsl:call-template name="multiple">
									<xsl:with-param name="number" select="position()"/>	
									<xsl:with-param name="form" select="'daogrp'"/>
									<xsl:with-param name="path" select="'did'"/>									
								</xsl:call-template>
								<input type="button" value="Delete">
									<xsl:attribute name="onclick">
										<xsl:text>deleteDao('daoformxdidgrp</xsl:text><xsl:value-of select="position()"/><xsl:text>')</xsl:text>
									</xsl:attribute>					
								</input>	
							</div>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:if> 
		
		
			<div id="createnewdao">		
				<span>Add new DAO  </span>
				<select name="daoselect" id="daoselect">
					<option value="null">Select...</option>
					<option value="new">Link to file</option>
					<option value="embed">Display image</option>
					<option value="thumb">Display thumbnail link to file</option>
					<option value="multiple">Link to multiple files</option>
				</select>	
				<input type="button" value="Create" onclick="javascript: createDaoForm()"/>
			</div>
		</div>
	</div>
<!--  -->
<!--  -->
<!-- ACCESSPOINTS -->
<!--  -->
	<div id="accesspointssection" class="section">
		<h3>Access Points<a id="accesspoints" name="accesspoints" target="_new" href="http://www.archiveshub.ac.uk/arch/access.shtml">
		<img class="whatsthis" src="/ead/img/whatisthissmall.gif" alt="[What is this?]"/>
		</a></h3>
		
<!-- subject -->
		<div id="subject" class="apcontainer">
			<p><strong>Subject</strong><a id="subjecthelp" name="subjecthelp" target="_new" href="http://www.archiveshub.ac.uk/arch/subject.shtml">
		<img class="whatsthis" src="/ead/img/whatisthissmall.gif" alt="[What is this?]"/>
		</a><br /><a class="extSearch" onclick="window.open('http://databases.unesco.org/thesaurus/', 'new');">[Search UNESCO]</a><xsl:text>  </xsl:text><a class="extSearch" onclick="window.open('http://authorities.loc.gov/cgi-bin/Pwebrecon.cgi?DB=local&amp;PAGE=First', 'new');">[Search LCSH]</a></p>
			<xsl:choose>
				<xsl:when test="controlaccess/subject">
					<xsl:call-template name="accesspoint">
						<xsl:with-param name="aptype" select="'subject'"/>
					</xsl:call-template>	
				</xsl:when>
				<xsl:otherwise>
					<div id="addedsubjects" style="display:none" class="added"><xsl:text> </xsl:text></div>
				</xsl:otherwise>
			</xsl:choose>	
			<div id="subjecttable" class="tablecontainer">
				<table id="table_subject">
				<tbody>
			    	<tr NoDrop="true" NoDrag="true"><td class="label">Subject:</td><td><input type="text" onfocus="setCurrent(this);" id="subject_subject" size="40"></input></td></tr>
			    	<tr NoDrop="true" NoDrag="true"><td class="label">Thesaurus:</td><td><input type="text" onfocus="setCurrent(this);" id="subject_source" size="40"></input></td></tr>
			    	<tr NoDrop="true" NoDrag="true"><td><select onfocus="setCurrent(this);" id="subjectdropdown">
			    		<option value="subject_dates">Dates</option>
			    		<option value="subject_loc">Location</option>
			    		<option value="subject_other">Other</option>
			    	</select></td>
			    	<td><a class="addfield" onclick="addField('subject');">Add Selected Field</a><!-- <input type="text" onfocus="addField('subject')" size="40" value="Click to Add Selected Field" style="background:#F2F2F2; color: grey;"></input> --></td></tr>
			    </tbody>
				</table>
			</div>
			<div id="subjectbuttons" class="buttoncontainer">			     
		  	    <input class="apbutton" type="button" onclick="addAccessPoint('subject');" value="Add to Record" ></input><br/>
		  	    <input class="apbutton" type="button" onclick="resetAccessPoint('subject');" value="Reset" ></input>
			</div>
			<br/>
		</div>
		<br/>	
<!--persname -->
        <div id="persname" class="apcontainer">				
			<p><strong>Personal Name</strong><a id="persnamehelp" name="persnamehelp" target="_new" href="http://www.archiveshub.ac.uk/arch/persname.shtml">
		<img class="whatsthis" src="/ead/img/whatisthissmall.gif" alt="[What is this?]"/>
		</a><br /><a class="extSearch" onclick="window.open('http://www.nationalarchives.gov.uk/nra/searches/simpleSearch.asp?subjectType=P', 'new');">[Search NRA]</a></p>
			
			<xsl:choose>
				<xsl:when test="controlaccess/persname">
					<xsl:call-template name="accesspoint">
						<xsl:with-param name="aptype" select="'persname'"/>
					</xsl:call-template>	
				</xsl:when>
				<xsl:otherwise>
					<div id="addedpersnames" style="display:none" class="added"><xsl:text> </xsl:text></div>
				</xsl:otherwise>
			</xsl:choose>	
			<div id="persnametable" class="tablecontainer">					
				<table id="table_persname"><tbody>					
				  	<tr NoDrop="true" NoDrag="true"><td class="label"> Surname:</td><td> <input type="text" onfocus="setCurrent(this);" id="persname_surname" size="40"></input></td></tr>
				  	<tr NoDrop="true" NoDrag="true"><td class="label"> Source:</td><td> <input type="text" onfocus="setCurrent(this);" id="persname_source" size="40"></input></td></tr>
				  	<tr NoDrop="true" NoDrag="true"><td><select onfocus="setCurrent(this);" id="persnamedropdown">
				  		<option value="persname_forename">Forename</option>
			    		<option value="persname_dates">Dates</option>
			    		<option value="persname_title">Title</option>
			    		<option value="persname_epithet">Epithet</option>
			    		<option value="persname_other">Other</option>		    		
			    	</select></td>
			    	<td><a class="addfield" onclick="addField('persname');">Add Selected Field</a><!-- <input type="text" onfocus="addField('persname')" size="40" value="Click to Add Selected Field" style="background:#F2F2F2; color: grey;"></input> --></td></tr>
				</tbody></table>
			</div>
			<div id="persnamebuttons" class="buttoncontainer">
				<p class="apbutton">Rules:
					<select id="persname_rules" onchange="checkRules('persname')">
						<option value="none">None</option>
						<option value="ncarules">NCA Rules</option>
						<option value="aacr2">AACR2</option>
					</select>
				</p>
				<input class="apbutton" type="button" onclick="addAccessPoint('persname');" value="Add To Record" ></input><br />
				<input class="apbutton" type="button" onclick="resetAccessPoint('persname');" value="Reset" ></input>				
			</div>
			<br/>
		</div>
		<br/>
<!--famname -->
		<div id="famname" class="apcontainer">
			<p><strong>Family Name</strong><a id="famnamehelp" name="famnamehelp" target="_new" href="http://www.archiveshub.ac.uk/arch/famname.shtml">
		<img class="whatsthis" src="/ead/img/whatisthissmall.gif" alt="[What is this?]"/>
		</a><br /><a class="extSearch" onclick="window.open('http://www.nationalarchives.gov.uk/nra/searches/simpleSearch.asp?subjectType=F', 'new');">[Search NRA]</a></p>
			<xsl:choose>
				<xsl:when test="controlaccess/famname">
					<xsl:call-template name="accesspoint">
						<xsl:with-param name="aptype" select="'famname'"/>
					</xsl:call-template>	
				</xsl:when>
				<xsl:otherwise>
					<div id="addedfamnames" style="display:none" class="added"><xsl:text> </xsl:text></div>
				</xsl:otherwise>
			</xsl:choose>
			<div id="famnametable" class="tablecontainer">
			      <table id="table_famname"><tbody>
					  <tr NoDrop="true" NoDrag="true"><td class="label">Surname:</td><td> <input type="text" onfocus="setCurrent(this);" id="famname_surname" size="40"></input></td></tr>
					  <tr NoDrop="true" NoDrag="true"><td class="label">Source:</td><td> <input type="text" onfocus="setCurrent(this);" id="famname_source" size="40"></input></td></tr>
				  	  <tr NoDrop="true" NoDrag="true"><td><select onfocus="setCurrent(this);" id="famnamedropdown">
				  	  	<option value="famname_other">Other</option>		  		
			    		<option value="famname_dates">Dates</option>
			    		<option value="famname_title">Title</option>
			    		<option value="famname_epithet">Epithet</option>
			    		<option value="famname_loc">Location</option>		    		
			    	</select></td>
			    	<td><a class="addfield" onclick="addField('famname');">Add Selected Field</a><!-- <input type="text" onfocus="addField('famname')" size="40" value="Click to Add Selected Field" style="background:#F2F2F2; color: grey;"></input> --></td></tr>
			      </tbody></table>
			</div>
			<div id="famnamebuttons" class="buttoncontainer">
				<p class="apbutton">Rules: 
				<select id="famname_rules" onchange="checkRules('famname')">
					<option value="none">None</option>
					<option value="ncarules">NCA Rules</option>
					<option value="aacr2">AACR2</option>
				</select>
				</p>
				<input class="apbutton" type="button" onclick="addAccessPoint('famname');" value="Add To Record"></input><br />
				<input class="apbutton" type="button" onclick="resetAccessPoint('famname');" value="Reset" ></input>
			</div>
			<br/>
		</div>
		<br/>		
<!-- corpname -->
		<div id="corpname" class="apcontainer">
			<p><strong>Corporate Name</strong><a id="corpnamehelp" name="corpnamehelp" target="_new" href="http://www.archiveshub.ac.uk/arch/corpname.shtml">
		<img class="whatsthis" src="/ead/img/whatisthissmall.gif" alt="[What is this?]"/>
		</a><br /><a class="extSearch" onclick="window.open('http://www.nationalarchives.gov.uk/nra/searches/simpleSearch.asp?subjectType=O', 'new');">[Search NRA]</a></p>
			<xsl:choose>
				<xsl:when test="controlaccess/corpname">
					<xsl:call-template name="accesspoint">
						<xsl:with-param name="aptype" select="'corpname'"/>
					</xsl:call-template>	
				</xsl:when>
				<xsl:otherwise>
					<div id="addedcorpnames" style="display:none" class="added"><xsl:text> </xsl:text></div>
				</xsl:otherwise>
			</xsl:choose>	
			<div id="corpnametable" class="tablecontainer">
				<table id="table_corpname"><tbody>
			    	<tr NoDrop="true" NoDrag="true"><td class="label">Organisation:</td><td><input type="text" onfocus="setCurrent(this);" id="corpname_organisation" size="40"></input></td></tr>
			    	<tr NoDrop="true" NoDrag="true"><td class="label">Source:</td><td><input type="text" onfocus="setCurrent(this);" id="corpname_source" size="40"></input></td></tr>
			    	<tr NoDrop="true" NoDrag="true"><td><select onfocus="setCurrent(this);" id="corpnamedropdown">				  	  			  		
			    		<option value="corpname_dates">Dates</option>
			    		<option value="corpname_loc">Location</option>
			    		<option value="corpname_other">Other</option>		    		
			    	</select></td>
			    	<td><a class="addfield" onclick="addField('corpname');">Add Selected Field</a><!-- <input type="text" onfocus="addField('corpname')" size="40" value="Click to Add Selected Field" style="background:#F2F2F2; color: grey;"></input> --></td></tr>
				</tbody></table>
			</div>
			<div id="corpnamebuttons" class="buttoncontainer">
				<p class="apbutton">Rules:
				    <select id="corpname_rules" onchange="checkRules('corpname')">
				    	<option value="none">None</option>
						<option value="ncarules">NCA Rules</option>
						<option value="aacr2">AACR2</option>
				    </select>
				</p>
				<input class="apbutton" type="button" onclick="addAccessPoint('corpname');" value="Add To Record"></input><br />
				<input class="apbutton" type="button" onclick="resetAccessPoint('corpname');" value="Reset" ></input>
			</div>
			<br/>
		</div>
		<br/>	
<!-- placename -->
		<div id="geogname" class="apcontainer">
			<p><strong>Place Name</strong><a id="geognamehelp" name="geognamehelp" target="_new" href="http://www.archiveshub.ac.uk/arch/geogname.shtml">
		<img class="whatsthis" src="/ead/img/whatisthissmall.gif" alt="[What is this?]"/>
		</a><br /><a class="extSearch" onclick="window.open('http://www.nationalarchives.gov.uk/nra/searches/simpleSearch.asp?subjectType=PL', 'new');">[Search NRA]</a></p>
			<xsl:choose>
				<xsl:when test="controlaccess/geogname">
					<xsl:call-template name="accesspoint">
						<xsl:with-param name="aptype" select="'geogname'"/>
					</xsl:call-template>	
				</xsl:when>
				<xsl:otherwise>
					<div id="addedgeognames" style="display:none" class="added"><xsl:text> </xsl:text></div>
				</xsl:otherwise>
			</xsl:choose>	
				<div id="geognametable" class="tablecontainer">
				    <table id="table_geogname"><tbody>
						<tr NoDrop="true" NoDrag="true"><td class="label">Place Name:</td><td> <input type="text" onfocus="setCurrent(this);" id="geogname_location" size="40"></input></td></tr>
						<tr NoDrop="true" NoDrag="true"><td class="label">Source:</td><td> <input type="text" onfocus="setCurrent(this);" id="geogname_source" size="40"></input></td></tr>
						<tr NoDrop="true" NoDrag="true"><td><select onfocus="setCurrent(this);" id="geognamedropdown">				  	  			  			
				    		<option value="geogname_dates">Dates</option>		    		
				    		<option value="geogname_loc">Location</option>
				    		<option value="geogname_other">Other</option>
				    	</select></td>
				    	<td><a class="addfield" onclick="addField('geogname');">Add Selected Field</a><!-- <input type="text" onfocus="addField('geogname')" size="40" value="Click to Add Selected Field" style="background:#F2F2F2; color: grey;"></input> --></td></tr>
				    </tbody></table>
				</div>
				<div id="geognamebuttons" class="buttoncontainer">
					<p class="apbutton">Rules:
			    			<select id="geogname_rules" onchange="checkRules('geogname')">
			    				<option value="none">None</option>
			      				<option value="ncarules">NCA Rules</option>
			      				<option value="aacr2">AACR2</option>
			    			</select></p>
					<input class="apbutton" type="button" onclick="addAccessPoint('geogname');" value="Add To Record"></input><br />
					<input class="apbutton" type="button" onclick="resetAccessPoint('geogname');" value="Reset" ></input>
				</div>
				<br/>
		</div>
		<br/>
<!--title -->
		<div id="title" class="apcontainer">
			<p><strong>Book Title</strong><a id="booktitlehelp" name="booktitlehelp" target="_new" href="http://www.archiveshub.ac.uk/arch/booktitle.shtml">
		<img class="whatsthis" src="/ead/img/whatisthissmall.gif" alt="[What is this?]"/>
		</a></p>
			<xsl:choose>
				<xsl:when test="controlaccess/title">
					<xsl:call-template name="accesspoint">
						<xsl:with-param name="aptype" select="'title'"/>
					</xsl:call-template>	
				</xsl:when>
				<xsl:otherwise>
					<div id="addedtitles" style="display:none" class="added"><xsl:text> </xsl:text></div>
				</xsl:otherwise>
			</xsl:choose>	
				<div id="titletable" class="tablecontainer">
					<table id="table_title"><tbody>
						<tr NoDrop="true" NoDrag="true"><td class="label">Title:</td><td> <input type="text" onfocus="setCurrent(this);" id="title_title" size="40"></input></td></tr>
						<tr NoDrop="true" NoDrag="true"><td class="label">Source:</td><td> <input type="text" onfocus="setCurrent(this);" id="title_source" size="40"></input></td></tr>
						<tr NoDrop="true" NoDrag="true"><td><select onfocus="setCurrent(this);" id="titledropdown">				  	  			  		
				    		<option value="title_dates">Dates</option>			    		
				    	</select></td>
				    	<td><a class="addfield" onclick="addField('title');">Add Selected Field</a><!-- <input type="text" onfocus="addField('title')" size="40" value="Click to Add Selected Field" style="background:#F2F2F2; color: grey;"></input> --></td></tr>
					</tbody></table>
				</div>
				<div id="titlebuttons" class="buttoncontainer">
					<p class="apbutton">Rules:
					    <select id="title_rules" onchange="checkRules('title')">
					      <option value="none">None</option>
					      <option value="aacr2">AACR2</option>
					    </select></p>
						<input class="apbutton" type="button" onclick="addAccessPoint('title');" value="Add To Record"></input><br />
						<input class="apbutton" type="button" onclick="resetAccessPoint('title');" value="Reset" ></input>
				</div>
				<br/>
			</div>
			<br/>	
<!-- genreform -->
		<div id="genreform" class="apcontainer">
			<p><strong>Genre Form</strong><a id="genreformhelp" name="genreformhelp" target="_new" href="http://www.archiveshub.ac.uk/arch/genreform.shtml">
		<img class="whatsthis" src="/ead/img/whatisthissmall.gif" alt="[What is this?]"/>
		</a><br/><a class="extSearch" onclick="window.open('http://www.getty.edu/research/conducting_research/vocabularies/aat/', 'new');">[Search AAT]</a><xsl:text> </xsl:text><a class="extSearch" onclick="window.open('http://www.loc.gov/rr/print/tgm2/', 'new');">[Search TGM]</a></p>
			<xsl:choose>
				<xsl:when test="controlaccess/genreform">
					<xsl:call-template name="accesspoint">
						<xsl:with-param name="aptype" select="'genreform'"/>
					</xsl:call-template>	
				</xsl:when>
				<xsl:otherwise>
					<div id="addedgenreforms" style="display:none" class="added"><xsl:text> </xsl:text></div>
				</xsl:otherwise>
			</xsl:choose>	
				<div id="genreformtable" class="tablecontainer">
					<table id="table_genreform"><tbody>
						<tr NoDrop="true" NoDrag="true"><td class="label">Genre:</td><td> <input type="text" onfocus="setCurrent(this);" id="genreform_genre" size="40"></input></td></tr>
						<tr NoDrop="true" NoDrag="true"><td class="label">Source:</td><td> <input type="text" onfocus="setCurrent(this);" id="genreform_source" size="40"></input></td></tr>
					</tbody></table>
				</div>
				<div id="genreformbuttons" class="buttoncontainer">
						<input class="apbutton" type="button" onclick="addAccessPoint('genreform');" value="Add To Record"></input><br />
						<input class="apbutton" type="button" onclick="resetAccessPoint('genreform');" value="Reset" ></input>
				</div>
				<br/>
			</div>
			<br/>				
			
<!-- function -->
		<div id="function" class="apcontainer">
			<p><strong>Function</strong><a id="functionhelp" name="functionhelp" target="_new" href="http://www.archiveshub.ac.uk/arch/function.shtml">
		<img class="whatsthis" src="/ead/img/whatisthissmall.gif" alt="[What is this?]"/>
		</a><br/><a class="extSearch" onclick="window.open('http://www.getty.edu/research/conducting_research/vocabularies/aat/', 'new');">[Search AAT]</a><xsl:text> </xsl:text><a class="extSearch" onclick="window.open('http://www.naa.gov.au/records-management/create-capture-describe/describe/agift/index.aspx', 'new');">[Search AGIFT]</a></p>
			<xsl:choose>
				<xsl:when test="controlaccess/function">
					<xsl:call-template name="accesspoint">
						<xsl:with-param name="aptype" select="'function'"/>
					</xsl:call-template>	
				</xsl:when>
				<xsl:otherwise>
					<div id="addedfunctions" style="display:none" class="added"><xsl:text> </xsl:text></div>
				</xsl:otherwise>
			</xsl:choose>	
				<div id="functiontable" class="tablecontainer">
					<table id="table_function"><tbody>
						<tr NoDrop="true" NoDrag="true"><td class="label">Function:</td><td> <input type="text" onfocus="setCurrent(this);" id="function_function" size="40"></input></td></tr>
						<tr NoDrop="true" NoDrag="true"><td class="label">Source:</td><td> <input type="text" onfocus="setCurrent(this);" id="function_source" size="40"></input></td></tr>
					</tbody></table>
				</div>
				<div id="functionbuttons" class="buttoncontainer">
						<input class="apbutton" type="button" onclick="addAccessPoint('function');" value="Add To Record"></input><br />
						<input class="apbutton" type="button" onclick="resetAccessPoint('function');" value="Reset" ></input>
				</div>
				<br/>
			</div>
			<br/>													
		</div>	
  </xsl:template>
  
  
  
  <xsl:template name="accesspoint">
  	<xsl:param name="aptype"/>
  	<div style="display:block" class="added"> 
  	<xsl:attribute name="id">
  		<xsl:text>added</xsl:text><xsl:value-of select="$aptype"/><xsl:text>s</xsl:text>
  	</xsl:attribute>
		<xsl:for-each select="controlaccess/*[name() = $aptype]">
		 	<input type="hidden">
		 		<xsl:attribute name="name">
		 			<xsl:text>controlaccess/</xsl:text><xsl:value-of select="$aptype"/>
		 		</xsl:attribute>
				<xsl:attribute name="id">
					<xsl:value-of select="$aptype"/><xsl:text>_formgen</xsl:text><xsl:number level="single" count="controlaccess/*[name() = $aptype]" format="1"/><xsl:text>xml</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="value">
					<div class="accesspoint">					 
						<xsl:call-template name="accesspointstring">					
							<xsl:with-param name="aptype" select="$aptype"/>
							<xsl:with-param name="separater" select="' ||| '"/>
						</xsl:call-template>
					</div>
				</xsl:attribute>
			</input>
	  	 	<div>
				<xsl:attribute name="id">
					<xsl:value-of select="$aptype"/><xsl:text>_formgen</xsl:text><xsl:number level="single" count="controlaccess/*[name() = $aptype]" format="1"/>				
				</xsl:attribute>			
				<div class="icons">
					<a>
						<xsl:attribute name="onclick">
							<xsl:text>deleteAccessPoint('</xsl:text><xsl:value-of select="$aptype"/><xsl:text>_formgen</xsl:text><xsl:number level="single" count="controlaccess/*[name() = $aptype]" format="1"/><xsl:text>');</xsl:text>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:text>delete entry</xsl:text>
						</xsl:attribute>
						<img src="/ead/img/delete.png" class="deletelogo">
                            <xsl:attribute name="onmouseover">
                                <xsl:text>this.src='/ead/img/delete-hover.png';</xsl:text>
                            </xsl:attribute>
                            <xsl:attribute name="onmouseout">
                                <xsl:text>this.src='/ead/img/delete.png';</xsl:text>
                            </xsl:attribute>
    						<xsl:attribute name="id">
    							<xsl:text>delete</xsl:text><xsl:number level="single" count="controlaccess/*[name() = $aptype]" format="1"/>
    						</xsl:attribute>
						</img>
					</a>										
				</div>
				<div class="accesspoint">	
					<a>
					<xsl:attribute name="onclick">
						<xsl:text>editAccessPoint('</xsl:text><xsl:value-of select="$aptype"/><xsl:text>_formgen', </xsl:text><xsl:number level="single" count="controlaccess/*[name() = $aptype]" format="1"/><xsl:text>);</xsl:text>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:text>Click to edit</xsl:text>
					</xsl:attribute>		 
					<xsl:call-template name="accesspointstring">					
						<xsl:with-param name="aptype" select="$aptype"/>
						<xsl:with-param name="separater" select="' '"/>
					</xsl:call-template>
					</a>
				</div>
			</div>
			<br>
				<xsl:attribute name="id">
					<xsl:value-of select="$aptype"/><xsl:text>_formgen</xsl:text><xsl:number level="single" count="controlaccess/*[name() = $aptype]" format="1"/><xsl:text>br</xsl:text>
				</xsl:attribute>
			</br>			
	 	</xsl:for-each>	 												
	</div>	  	
  </xsl:template>
  
  
  
  
  <xsl:template name="accesspointstring">
  	 <xsl:param name="aptype"/>
  	 <xsl:param name="separater"/>
  	 <xsl:choose>
  	 	<xsl:when test="emph">
		  	 <xsl:choose>
		  	 	<xsl:when test="$separater = ' '">
		  	 		<xsl:for-each select="emph">
		  	 			<xsl:value-of select="."/>
		  	 			<xsl:value-of select="$separater"/>
		  	 		</xsl:for-each>
		  	 	</xsl:when>
		  	 	<xsl:when test="$separater = ' ||| '">
		  	 		<xsl:for-each select="emph">
		  	 			<xsl:value-of select="$aptype"/>
		  	 			<xsl:text>_</xsl:text>
		  	 			<xsl:value-of select="@altrender"/>
		  	 			<xsl:text> | </xsl:text>
		  	 			<xsl:value-of select="."/>
		  	 			<xsl:value-of select="$separater"/>
		  	 		</xsl:for-each>
		  	 		<xsl:if test="@source">
			  	  		<xsl:value-of select="$aptype"/>
		  	 			<xsl:text>_source | </xsl:text>
			  	  		<xsl:apply-templates select="@source"/>  	 
			  	  		<xsl:value-of select="$separater"/> 				
			  	  	</xsl:if>
					<xsl:if test="@rules">
						<xsl:value-of select="$aptype"/>
		  	 			<xsl:text>_rules | </xsl:text>
			  	  		<xsl:apply-templates select="@rules"/>  	 
			  	  		<xsl:value-of select="$separater"/> 				
			  	  	</xsl:if>
		  	 		<xsl:for-each select="@*">
		  	 			<xsl:if test="not(name() = 'rules') and not(name() = 'source')">
		  	 				<xsl:text>att_</xsl:text>
		  	 				<xsl:value-of select="name()"/>
		  	 				<xsl:text> | </xsl:text>
		  	 				<xsl:value-of select="."/>
		  	 				<xsl:value-of select="$separater"/>
		  	 			</xsl:if>
		  	 		</xsl:for-each>	 
		  	 	</xsl:when>
		  	 </xsl:choose>
	  	 </xsl:when>
	  	 <xsl:otherwise>
	  	 	<xsl:choose>
	  	 		<xsl:when test="$separater = ' '">
	  	 			<xsl:value-of select="./text()"/>
	  	 			<xsl:value-of select="$separater"/>
	  	 		</xsl:when>
	  	 		<xsl:when test="$separater = ' ||| '">
	  	 			<xsl:value-of select="$aptype"/>
		  	 		<xsl:text>_a | </xsl:text>
		  	 		<xsl:value-of select="."/>
		  	 		<xsl:value-of select="$separater"/>
		  	 		<xsl:if test="@source">
			  	  		<xsl:value-of select="$aptype"/>
		  	 			<xsl:text>_source | </xsl:text>
			  	  		<xsl:apply-templates select="@source"/>  	 
			  	  		<xsl:value-of select="$separater"/> 				
			  	  	</xsl:if>
					<xsl:if test="@rules">
						<xsl:value-of select="$aptype"/>
		  	 			<xsl:text>_rules | </xsl:text>
			  	  		<xsl:apply-templates select="@rules"/>  	 
			  	  		<xsl:value-of select="$separater"/> 				
			  	  	</xsl:if>
		  	 		<xsl:for-each select="@*">
		  	 			<xsl:if test="not(name() = 'rules') and not(name() = 'source')">
		  	 				<xsl:text>att_</xsl:text>
		  	 				<xsl:value-of select="name()"/>
		  	 				<xsl:text> | </xsl:text>
		  	 				<xsl:value-of select="."/>
		  	 				<xsl:value-of select="$separater"/>
		  	 			</xsl:if>
		  	 		</xsl:for-each>
	  	 		</xsl:when>
	  	 	</xsl:choose>
	  	 </xsl:otherwise>
	  </xsl:choose>
  </xsl:template>

  
  
  <xsl:template match="did/unitid[1]">
	<input type="text" onfocus="setCurrent(this);" name="did/unitid/@countrycode" id="countrycode" maxlength="2" size="3" onblur="checkId(true)">	
		<xsl:choose>	
		<xsl:when test="@countrycode">
			<xsl:attribute name="value">
				<xsl:value-of select="@countrycode"/>
			</xsl:attribute>
		</xsl:when>	
		<xsl:when test="$leveltype='collection' and current()/ancestor::ead/eadheader/eadid/@countrycode">
			<xsl:attribute name="value">
				<xsl:value-of select="current()/ancestor::ead/eadheader/eadid/@countrycode"/>
			</xsl:attribute>
		</xsl:when>
		</xsl:choose>	
	</input>
	<input type="text" onfocus="setCurrent(this);" name="did/unitid/@repositorycode" id="archoncode"  maxlength="4" size="5" onblur="checkId(true)">
		<xsl:choose>
		<xsl:when test="@repositorycode">
			<xsl:attribute name="value">
				<xsl:value-of select="@repositorycode"/>
			</xsl:attribute>
		</xsl:when>
		<xsl:when test="$leveltype='collection' and current()/ancestor::ead/eadheader/eadid/@mainagencycode">
			<xsl:attribute name="value">
				<xsl:value-of select="current()/ancestor::ead/eadheader/eadid/@mainagencycode"/>
			</xsl:attribute>
		</xsl:when>
		</xsl:choose>
	</input>
	<input type="text" onfocus="setCurrent(this);" name="did/unitid" id="unitid" size="50" onblur="checkId(true)">
		<xsl:attribute name="value">
			<xsl:value-of select="." />
		</xsl:attribute>
	</input> 
  </xsl:template>
  
  <xsl:template match="did/unittitle">
  	<input class="menuField" type="text" onfocus="setCurrent(this);" name="did/unittitle" id="did/unittitle" size="80" onchange="updateTitle(this)" onkeypress="validateFieldDelay(this, 'true');">
  		<xsl:attribute name="value">
  			<xsl:apply-templates/>
  		</xsl:attribute>
  	</input>
  </xsl:template>
    
  <xsl:template match="unitdate">
  	<input class="menuField" type="text" onkeypress="validateFieldDelay(this, 'true');" onchange="validateField(this, 'true');" onfocus="setCurrent(this);" name="did/unitdate" id="did/unitdate" size="39">
  		<xsl:attribute name="value">
  		  <xsl:apply-templates/>
  		</xsl:attribute>	
  	</input>
  </xsl:template>
  
  <xsl:template match="unitdate/@normal">
  	<input type="text" onfocus="setCurrent(this);" name="did/unitdate/@normal" id="did/unitdate/@normal" size="39" maxlength="21">
  		<xsl:attribute name="value">
  			<xsl:value-of select="."/>
  		</xsl:attribute>
  	</input>
  </xsl:template>
  
  <xsl:template match="did/repository">
  	<input class="menuField" type="text" onkeypress="validateFieldDelay(this, 'true');" onchange="validateField(this, 'true');" onfocus="setCurrent(this);" name="did/repository" id="did/repository" size="80">
  		<xsl:attribute name="value">
  			<xsl:apply-templates/>
  		</xsl:attribute>
  	</input>
  </xsl:template>
  
  <xsl:template match="/ead/eadheader/filedesc/titlestmt/sponsor">
  	<strong>Sponsor</strong><a id="sponsorhelp" name="sponsorhelp" target="_new" href="http://www.archiveshub.ac.uk/arch/sponsor.shtml ">
		<img class="whatsthis" src="/ead/img/whatisthissmall.gif" alt="[What is this?]"/>
		</a><a class="smalllink" id="linkspo" title="add sponsor" onclick="addElement('filedesc/titlestmt/sponsor')">hide content</a> [optional]<br/>
  	<input class="menuField" type="text" onkeypress="validateFieldDelay(this, 'true');" onchange="validateField(this, 'true');" onfocus="setCurrent(this);" name="filedesc/titlestmt/sponsor" id="filedesc/titlestmt/sponsor" size="80">
  		<xsl:attribute name="value">
  			<xsl:apply-templates/>
  		</xsl:attribute>
  	</input>
  </xsl:template>
  
  
  <xsl:template match="did/physdesc/extent">
  	<input class="menuField" type="text" onkeypress="validateFieldDelay(this, 'true');" onchange="validateField(this, 'true');" onfocus="setCurrent(this);" name="did/physdesc/extent" id="did/physdesc/extent" size="80">
  		<xsl:attribute name="value">
  			<xsl:apply-templates/>
  		</xsl:attribute>
  	</input>
  </xsl:template>

  <xsl:template match="did/origination">
  	<input class="menuField" type="text" onkeypress="validateFieldDelay(this, 'true');" onchange="validateField(this, 'true');" onfocus="setCurrent(this);" name="did/origination" id="did/origination" size="80">
  		<xsl:attribute name="value">
  			<xsl:apply-templates/>
  		</xsl:attribute>
  	</input>
  </xsl:template>


  <xsl:template match="did/langmaterial">
	<div id="addedlanguages" style="display:block" class="added">
		<xsl:for-each select="language">
			<input type="hidden" name="did/langmaterial/language">
				<xsl:attribute name="id">
					<xsl:text>language_formgen</xsl:text><xsl:number level="single" count="language" format="1"/><xsl:text>xml</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="value">
					<xsl:text>lang_code | </xsl:text><xsl:value-of select="@langcode"/><xsl:text> ||| lang_name | </xsl:text><xsl:value-of select="."/><xsl:text> ||| </xsl:text>
					<xsl:for-each select="@*">
		  	 			<xsl:if test="not(name() = 'langcode')">
		  	 				<xsl:text>att_</xsl:text>
		  	 				<xsl:value-of select="name()"/>
		  	 				<xsl:text> | </xsl:text>
		  	 				<xsl:value-of select="."/>
		  	 				<xsl:text> ||| </xsl:text>
		  	 			</xsl:if>
		  	 		</xsl:for-each>	
				</xsl:attribute>
			</input>
			<div>
				<xsl:attribute name="id">
					<xsl:text>language_formgen</xsl:text><xsl:number level="single" count="language" format="1"/>				
				</xsl:attribute>			
				<div class="icons">
					<a>
						<xsl:attribute name="onclick">
							<xsl:text>deleteAccessPoint('language_formgen</xsl:text><xsl:number level="single" count="language" format="1"/><xsl:text>');</xsl:text>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:text>delete entry</xsl:text>
						</xsl:attribute>
						<img src="/ead/img/delete.png" class="deletelogo">
                        <xsl:attribute name="onmouseover">
                            <xsl:text>this.src='/ead/img/delete-hover.png';</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="onmouseout">
                            <xsl:text>this.src='/ead/img/delete.png';</xsl:text>
                        </xsl:attribute>
						<xsl:attribute name="id">
							<xsl:text>delete</xsl:text><xsl:number level="single" count="language" format="1"/>
						</xsl:attribute>
						</img>
					</a>									
				</div>
				<div class="accesspoint">
					<a>
					<xsl:attribute name="onclick">
						<xsl:text>editAccessPoint('language_formgen', </xsl:text><xsl:number level="single" count="language" format="1"/><xsl:text>);</xsl:text>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:text>Click to edit</xsl:text>
					</xsl:attribute>
					<xsl:value-of select="@langcode"/><xsl:text> </xsl:text><xsl:value-of select="."/>
					</a>
				</div>
			</div>
			<br>
				<xsl:attribute name="id">
					<xsl:text>language_formgen</xsl:text><xsl:number level="single" count="language" format="1"/><xsl:text>br</xsl:text>
				</xsl:attribute>
			</br>
			
		</xsl:for-each>													
	</div>	
  </xsl:template>

  
  
  <xsl:template name="option">
	<!-- Generates an option to go in the drop-down list -->
	<xsl:param name="value" />
	<xsl:param name="label" />
	<xsl:param name="select" />

	<xsl:element name="option">
	  <xsl:attribute name="value"><xsl:value-of select="$value" /></xsl:attribute>
	  <xsl:if test="$value = $select"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
	  <xsl:value-of select="$label" />
	</xsl:element>
  </xsl:template>
  
  
  
  <xsl:template name="textarea">
  	<xsl:param name="name" />
  	<xsl:param name="class" />
  	<xsl:param name="optional" />
  	<xsl:param name="content" />  
  	<xsl:param name="isadg" />
  	<xsl:param name="title" />
  	<xsl:param name="help" />
  	<xsl:param name="additional" />
  	<xsl:call-template name="label">
  		<xsl:with-param name="id" select="$name"/>
  		<xsl:with-param name="optional" select="$optional"/>
  		<xsl:with-param name="content" select="$content"/> 
  		<xsl:with-param name="isadg" select="$isadg"/>
  		<xsl:with-param name="title" select="$title"/>
  		<xsl:with-param name="help" select="$help"/>  	
  		<xsl:with-param name="additional" select="$additional"/>  		
  	</xsl:call-template>
  	<textarea onkeypress="validateFieldDelay(this, 'true');" onchange="validateField(this, 'true');" onfocus="setCurrent(this);" rows="5" cols="80">
  		<xsl:attribute name="name"><xsl:value-of select="$name"/></xsl:attribute>
  		<xsl:attribute name="id"><xsl:value-of select="$name"/></xsl:attribute>
  		<xsl:attribute name="class"><xsl:value-of select="$class"/></xsl:attribute>
  		<xsl:if test="$optional = 'true' and $content = 'false'">
  			<xsl:attribute name="style">display:none</xsl:attribute>	
  		</xsl:if>
  		<xsl:choose>
  			<xsl:when test="$content = 'false'">
  				<xsl:text>&lt;p&gt;&lt;/p&gt;</xsl:text>
  			</xsl:when>
  			<xsl:otherwise>
  				<xsl:apply-templates select="./node()"/>	
  			</xsl:otherwise>
  		</xsl:choose>
  	</textarea> 
  	
  </xsl:template>
   
  

   
  <xsl:template name="label">
  	<xsl:param name="id" />
  	<xsl:param name="optional" />
  	<xsl:param name="content" />
  	<xsl:param name="isadg" />
  	<xsl:param name="title" />
  	<xsl:param name="help" />
  	<xsl:param name="additional" />
  	<br/>
  	<strong><span class="isadg"><xsl:value-of select="$isadg"/></span> 	
		<xsl:value-of select="$title"/>
		</strong>
	<xsl:if test="not($help='')">
		<a>
		<xsl:attribute name="href">
			<xsl:value-of select="$help"/>
		</xsl:attribute>
		<xsl:attribute name="title">
			<xsl:value-of select="$title"/><xsl:text> help - opens in new window</xsl:text>
		</xsl:attribute>
		<xsl:attribute name="target">
			<xsl:text>_new</xsl:text>
		</xsl:attribute>
		<img class="whatsthis" src="/ead/img/whatisthissmall.gif" alt="[What is this?]"/>
		</a>
	</xsl:if>

  	<xsl:if test="not($additional = '')">
  		<xsl:text> </xsl:text>
  		<xsl:value-of select="$additional"/>
  	</xsl:if>
  	<xsl:if test="$optional = 'true'">
  		<xsl:text> </xsl:text>
  		<a class="smalllink">
  			<xsl:attribute name="title">
  				<xsl:text>add content </xsl:text>
  				<xsl:value-of select="$title"/>
  			</xsl:attribute>
  			<xsl:attribute name="id">
  				<xsl:text>link</xsl:text>
  				<xsl:value-of select="$id"/>
  			</xsl:attribute>
  			<xsl:attribute name="onclick">
  				<xsl:text>addElement('</xsl:text><xsl:value-of select="$id"/><xsl:text>')</xsl:text>
  			</xsl:attribute>
  		    <xsl:choose>
  				<xsl:when test="$content = 'true'">
  					<xsl:text>hide content</xsl:text>
  				</xsl:when>
  				<xsl:otherwise>
  					<xsl:text>add content</xsl:text>
  				</xsl:otherwise>
  			</xsl:choose>
  		</a>
  		<xsl:text> [optional]</xsl:text>
  	</xsl:if>
	<br/>  	
  </xsl:template>
  
  <xsl:template match="comment()">
  	<xsl:comment><xsl:value-of select="."/></xsl:comment>
  </xsl:template>
  
  <xsl:template match="*">
        <xsl:text>&lt;</xsl:text><xsl:value-of select="name()"/>
        <xsl:for-each select="@*">
			  <xsl:text> </xsl:text>
			  <xsl:value-of select="name()"/>
			  <xsl:text>="</xsl:text><xsl:value-of select="."/><xsl:text>"</xsl:text>
        </xsl:for-each>
 <xsl:text>&gt;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&lt;/</xsl:text><xsl:value-of select="name()"/><xsl:text>&gt;</xsl:text>
  </xsl:template> 
  
  
  <xsl:template name="dao">
  	<xsl:param name="type" />
  	<xsl:param name="number" />
  	<xsl:param name="path" />
  	<table><tbody>
  		<tr>
  			<td class="label">File URI: </td>
  			<td>
  				<input size="70" type="text" onfocus="setCurrent(this);">
  					<xsl:attribute name="value">
  						<xsl:value-of select="@href"/>
  					</xsl:attribute>
  					<xsl:attribute name="name">
  						<xsl:text>daox</xsl:text><xsl:value-of select="$path"/><text>dao</text><xsl:value-of select="$number"/><xsl:text>|href</xsl:text>
  					</xsl:attribute>
  					<xsl:attribute name="id">
  						<xsl:text>daox</xsl:text><xsl:value-of select="$path"/><text>dao</text><xsl:value-of select="$number"/><xsl:text>|href</xsl:text>
  					</xsl:attribute>				
  				</input>
  			</td>
  		</tr>
  		<tr><td class="label">Description: </td>
  			<td>
  				<input size="70" type="text" onfocus="setCurrent(this);" class="menuField" onkeypress="validateFieldDelay(this, 'true');" onchange="validateField(this, 'true');">
  					<xsl:attribute name="name">
  						<xsl:text>daox</xsl:text><xsl:value-of select="$path"/><text>dao</text><xsl:value-of select="$number"/><xsl:text>|desc</xsl:text>
  					</xsl:attribute>
  					<xsl:attribute name="id">
  						<xsl:text>daox</xsl:text><xsl:value-of select="$path"/><text>dao</text><xsl:value-of select="$number"/><xsl:text>|desc</xsl:text>
  					</xsl:attribute>						
  					<xsl:attribute name="value">
  					  	<xsl:choose>
  							<xsl:when test="daodesc">
  								<xsl:apply-templates select="daodesc"/>
  							</xsl:when>
  							<xsl:otherwise>
  								<xsl:text>&lt;p&gt;&lt;/p&gt;</xsl:text>
  							</xsl:otherwise>
  						</xsl:choose>
  					</xsl:attribute>
  				</input>    			
  			</td>
  		</tr>
  	</tbody></table>
  	<input type="hidden">
  		<xsl:attribute name="value">
  			<xsl:value-of select="$type"/>
  		</xsl:attribute>
  		<xsl:attribute name="name">
			<xsl:text>daox</xsl:text><xsl:value-of select="$path"/><text>dao</text><xsl:value-of select="$number"/><xsl:text>|</xsl:text><xsl:value-of select="$type"/>
		</xsl:attribute>
		<xsl:attribute name="id">
			<xsl:text>daox</xsl:text><xsl:value-of select="$path"/><text>dao</text><xsl:value-of select="$number"/><xsl:text>|</xsl:text><xsl:value-of select="$type"/>
		</xsl:attribute>	
  	</input>
  </xsl:template>
  
  <xsl:template name="thumb">
  	<xsl:param name="number" />
  	<xsl:param name="path" />
  	<table><tbody>		
  		<tr>
  			<td class="label">Thumbnail URI: </td>
  			<td>
  				<input size="70" type="text" onfocus="setCurrent(this);">
  					<xsl:attribute name="value">
  						<xsl:value-of select="daoloc[@role='thumb']/@href"/>
  					</xsl:attribute>
  					<xsl:attribute name="name">
						<xsl:text>daox</xsl:text><xsl:value-of select="$path"/><text>grp</text><xsl:value-of select="$number"/><xsl:text>|href1</xsl:text>
					</xsl:attribute>
					<xsl:attribute name="id">
						<xsl:text>daox</xsl:text><xsl:value-of select="$path"/><text>grp</text><xsl:value-of select="$number"/><xsl:text>|href1</xsl:text>
					</xsl:attribute>					
  				</input>
  			</td>
  		</tr>  	
  		<tr>
  			<td class="label">File URI: </td>
  			<td>
  				<input size="70" type="text" onfocus="setCurrent(this);">
  					<xsl:attribute name="value">
  						<xsl:value-of select="daoloc[@role='reference']/@href"/>
  					</xsl:attribute>
  					<xsl:attribute name="name">
						<xsl:text>daox</xsl:text><xsl:value-of select="$path"/><text>grp</text><xsl:value-of select="$number"/><xsl:text>|href2</xsl:text>
					</xsl:attribute>
					<xsl:attribute name="id">
						<xsl:text>daox</xsl:text><xsl:value-of select="$path"/><text>grp</text><xsl:value-of select="$number"/><xsl:text>|href2</xsl:text>
					</xsl:attribute>		
  				</input>
  			</td>
  		</tr>
  		<tr><td class="label">Description: </td>
  			<td>
  				<input size="70" type="text" onfocus="setCurrent(this);" class="menuField" onkeypress="validateFieldDelay(this, 'true');" onchange="validateField(this, 'true');">
  					<xsl:attribute name="name">
						<xsl:text>daox</xsl:text><xsl:value-of select="$path"/><text>grp</text><xsl:value-of select="$number"/><xsl:text>|desc</xsl:text>
					</xsl:attribute>
					<xsl:attribute name="id">
						<xsl:text>daox</xsl:text><xsl:value-of select="$path"/><text>grp</text><xsl:value-of select="$number"/><xsl:text>|desc</xsl:text>
					</xsl:attribute>			
  					<xsl:attribute name="value">
  						<xsl:choose>
  							<xsl:when test="daodesc">
  								<xsl:apply-templates select="daodesc"/>
  							</xsl:when>
  							<xsl:otherwise>
  								<xsl:text>&lt;p&gt;&lt;/p&gt;</xsl:text>
  							</xsl:otherwise>
  						</xsl:choose>
  					</xsl:attribute>  					
  				</input>    			
  			</td>
  		</tr>
  	</tbody></table>
	<input type="hidden" value="thumb">
		<xsl:attribute name="name">
			<xsl:text>daox</xsl:text><xsl:value-of select="$path"/><text>grp</text><xsl:value-of select="$number"/><xsl:text>|thumb</xsl:text>
		</xsl:attribute>
		<xsl:attribute name="id">
			<xsl:text>daox</xsl:text><xsl:value-of select="$path"/><text>grp</text><xsl:value-of select="$number"/><xsl:text>|thumb</xsl:text>
		</xsl:attribute>
	</input>
	<input type="hidden" value="reference">
		<xsl:attribute name="name">
			<xsl:text>daox</xsl:text><xsl:value-of select="$path"/><text>grp</text><xsl:value-of select="$number"/><xsl:text>|reference</xsl:text>
		</xsl:attribute>
		<xsl:attribute name="id">
			<xsl:text>daox</xsl:text><xsl:value-of select="$path"/><text>grp</text><xsl:value-of select="$number"/><xsl:text>|reference</xsl:text>
		</xsl:attribute>
	</input>
  </xsl:template>

  <xsl:template name="multiple">
  	<xsl:param name="number" />
  	<xsl:param name="form" />
  	<xsl:param name="path" />
  	<table class="daotable"><tbody>
  		<xsl:for-each select="daoloc">
  			<xsl:variable name="class">
  				<xsl:choose>
  					<xsl:when test="position() mod 2 = 1">even</xsl:when>
  					<xsl:otherwise>odd</xsl:otherwise>
  				</xsl:choose>
  			</xsl:variable>
  			<tr>
  			<xsl:attribute name="class">
  				<xsl:value-of select="$class"/>
  			</xsl:attribute>
  			<td class="label">
  				<xsl:text>File </xsl:text><xsl:value-of select="position()"/><xsl:text> URI: </xsl:text>
  			</td>
  			<td>
	  			<input type="text" size="70" onfocus="setCurrent(this);">
	  				<xsl:attribute name="name">
						<xsl:text>daox</xsl:text><xsl:value-of select="$path"/><text>grp</text><xsl:value-of select="$number"/><xsl:text>|href</xsl:text><xsl:value-of select="position()"/>
					</xsl:attribute>
					<xsl:attribute name="id">
						<xsl:text>daox</xsl:text><xsl:value-of select="$path"/><text>grp</text><xsl:value-of select="$number"/><xsl:text>|href</xsl:text><xsl:value-of select="position()"/>
					</xsl:attribute>		
	  				<xsl:attribute name="value">
	  					<xsl:value-of select="@href"/>
	  				</xsl:attribute>
	  			</input>
  			</td>
  			</tr>
  			<tr>
  			<xsl:attribute name="class">
  				<xsl:value-of select="$class"/>
  			</xsl:attribute>
  			<td class="label">
  				<xsl:text>File </xsl:text><xsl:value-of select="position()"/><xsl:text> Title: </xsl:text>
  			</td>
  			<td>
	  			<input type="text" size="70" onfocus="setCurrent(this);">
	  				<xsl:attribute name="name">
						<xsl:text>daox</xsl:text><xsl:value-of select="$path"/><text>grp</text><xsl:value-of select="$number"/><xsl:text>|title</xsl:text><xsl:value-of select="position()"/>
					</xsl:attribute>
					<xsl:attribute name="id">
						<xsl:text>daox</xsl:text><xsl:value-of select="$path"/><text>grp</text><xsl:value-of select="$number"/><xsl:text>|title</xsl:text><xsl:value-of select="position()"/>
					</xsl:attribute>	  				
	  				<xsl:attribute name="value">
	  					<xsl:value-of select="@title"/>
	  				</xsl:attribute>
	  			</input>
  			</td>
  			</tr>
  			<input type="hidden" value="reference">
				<xsl:attribute name="name">
					<xsl:text>daox</xsl:text><xsl:value-of select="$path"/><text>grp</text><xsl:value-of select="$number"/><xsl:text>|role</xsl:text><xsl:value-of select="position()"/>
				</xsl:attribute>
				<xsl:attribute name="id">
					<xsl:text>daox</xsl:text><xsl:value-of select="$path"/><text>grp</text><xsl:value-of select="$number"/><xsl:text>|role</xsl:text><xsl:value-of select="position()"/>
				</xsl:attribute>
			</input>
  		</xsl:for-each> 		
  		<tr><td></td><td><a class="smalllink">
  		<xsl:attribute name="onclick">
  			<xsl:text>addFile('daoformx</xsl:text><xsl:value-of select="$path"/><xsl:text>grp</xsl:text><xsl:value-of select="$number"/><xsl:text>');</xsl:text>
  		</xsl:attribute>		
  		add another file</a></td></tr>
  		<tr><td class="label">Description of group: </td>
  			<td>
  				<input size="70" type="text" onfocus="setCurrent(this);" class="menuField" onkeypress="validateFieldDelay(this, 'true');" onchange="validateField(this, 'true');">  					
  					<xsl:attribute name="name">
						<xsl:text>daox</xsl:text><xsl:value-of select="$path"/><text>grp</text><xsl:value-of select="$number"/><xsl:text>|desc</xsl:text>
					</xsl:attribute>
					<xsl:attribute name="id">
						<xsl:text>daox</xsl:text><xsl:value-of select="$path"/><text>grp</text><xsl:value-of select="$number"/><xsl:text>|desc</xsl:text>
					</xsl:attribute>  					
  					<xsl:attribute name="value">
  					  	<xsl:choose>
  							<xsl:when test="daodesc">
  								<xsl:apply-templates select="daodesc"/>
  							</xsl:when>
  							<xsl:otherwise>
  								<xsl:text>&lt;p&gt;&lt;/p&gt;</xsl:text>
  							</xsl:otherwise>
  						</xsl:choose>
  					</xsl:attribute>
  				</input>    			
  			</td>
  		</tr>
  	</tbody></table>
  </xsl:template>
  


   
   <xsl:template match="daodesc">
   		<xsl:apply-templates/>
   </xsl:template>
  
</xsl:stylesheet>

