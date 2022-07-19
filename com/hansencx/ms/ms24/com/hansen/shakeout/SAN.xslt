<?xml version="1.0" encoding="UTF-8"?>
<!--
    generates an aseXML r38 SiteAccessNotification request
-->
<xsl:stylesheet
        version="2.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:ase="urn:aseXML:r38"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="urn:aseXML:r38 http://www.nemmco.com.au/asexml/schemas/r38/aseXML_r38.xsd">
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="/">
        <ase:aseXML>
            <xsl:attribute name="xsi:schemaLocation">
                <xsl:text>urn:aseXML:r38 http://www.nemmco.com.au/aseXML/schemas/r38/aseXML_r38.xsd</xsl:text>
            </xsl:attribute>
            <Header>
                <xsl:apply-templates select="Initiator"/>
                <!--                 <To><xsl:value-of select="Transactions/Transaction[1]/TransactionData/Recipient"/></To> -->
                <xsl:apply-templates select="ExternalMessageID"/>
                <xsl:apply-templates select="MessageDate"/>
                <TransactionGroup>SITE</TransactionGroup>
                <Priority>Medium</Priority>
                <SecurityContext><xsl:value-of select="SecurityContext"/></SecurityContext>
                <Market>NEM</Market>
            </Header>
            <Transactions>
                <xsl:for-each select="//Transaction">
                    <Transaction>
                        <xsl:attribute name="transactionID"><xsl:value-of select="TransactionData/ExternalTransactionID"/></xsl:attribute>
                        <xsl:attribute name="transactionDate"><xsl:value-of select="TransactionData/TransactionDate"/></xsl:attribute>
                        <xsl:attribute name="initiatingTransactionID"><xsl:value-of select="TransactionData/OriginalTransactionID"/></xsl:attribute>
                        <AmendMeterRouteDetails version="r19">
                            <AmendSiteAccessDetails xsi:type="ase:SiteAccessDetails"	version="r19">
                                <xsl:apply-templates select="TransactionData/UniqueServiceIdentifier" />
                                <NMI>
                                    <xsl:attribute name="checksum">
                                        <xsl:value-of select="TransactionData/checksum"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="TransactionData/nmi"/>
                                </NMI>
                                <AccessDetail>
                                    <xsl:value-of select="Premise/AccessInstructions" />
                                </AccessDetail>
                                <xsl:apply-templates select="Premise/Hazards" />
                                <LastModifiedDateTime>
                                    <xsl:value-of select="TransactionData/ActualModifiedDateTime" />
                                </LastModifiedDateTime>
                            </AmendSiteAccessDetails>
                        </AmendMeterRouteDetails>
                    </Transaction>
                </xsl:for-each>
            </Transactions>
        </ase:aseXML>
    </xsl:template>
    <xsl:template match="Hazards">
        <xsl:for-each select="Hazard">
            <Hazard>
                <Description><xsl:value-of select="." /></Description>
            </Hazard>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="Initiator">
        <From>
            <xsl:value-of select="."/>
        </From>
    </xsl:template>
    <xsl:template match="ExternalMessageID">
        <MessageID>
            <xsl:value-of select="."/>
        </MessageID>
    </xsl:template>
    <xsl:template match="MessageDate">
        <MessageDate>
            <xsl:value-of select="."/>
        </MessageDate>
    </xsl:template>

</xsl:stylesheet>
