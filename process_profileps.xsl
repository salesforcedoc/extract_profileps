<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:doc="http://soap.sforce.com/2006/04/metadata">
<xsl:output omit-xml-declaration="no" indent="yes" encoding="UTF-8" method="xml" />
<xsl:strip-space  elements="*"/>

  <!--Identity template,  provides default behavior that copies all content into the output -->
  <xsl:template match="node()|@*">      
      <xsl:copy>
          <xsl:apply-templates select="node()|@*" />
      </xsl:copy>
  </xsl:template>

  <!--add any section here that you want to exclude -->
  <xsl:template match="doc:applicationVisibilities">
  </xsl:template>

  <xsl:template match="doc:classAccesses">
  </xsl:template>

  <xsl:template match="doc:pageAccesses">
  </xsl:template>
  
  <xsl:template match="doc:tabSettings">
  </xsl:template>

  <xsl:template match="doc:tabVisibilities">
  </xsl:template>

  <xsl:template match="doc:recordTypeVisibilities">
  </xsl:template>

  <xsl:template match="doc:layoutAssignments">
  </xsl:template>

  <xsl:template match="doc:userPermissions">
  </xsl:template>

  <xsl:template match="doc:fieldPermissions">
  </xsl:template>

  <xsl:template match="doc:userLicense">
  </xsl:template>

  <!--add any section here that you want to include -->
  <xsl:template match="doc:objectPermissions">
      <xsl:copy>
          <xsl:apply-templates select="node()|@*" />
      </xsl:copy>
 </xsl:template>

</xsl:stylesheet>