<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="xml" omit-xml-declaration="yes" indent="yes" encoding="ISO-8859-1"/>
    <xsl:template match="/resource">
        <div class="container">
            <div class="row mosaico-contenedor">
                <div class="col-6 col-md-4">
                    <div class="mosaico radius-overflow">
                        <a href="#" data-toggle="modal" data-target="#modalExh">
                            <span class="ion-ios-plus rojo"></span>
                        </a>
                    </div>
                    <div class="mosaico-txt ">
                        <p><span class="ion-locked rojo"></span> Crear exhibici�n</p>
                        <p>Dentro de las exhibiciones se encuentran las colecciones de informaci�n altamente especializadas</p>
                    </div>
                </div>
                <xsl:if test = "count(father)&gt;0">
                    <xsl:for-each select="father">
                        <xsl:for-each select="son">
                            <div class="col-6 col-md-4">

				<xsl:choose>
				    <xsl:when test="@posters = '1'">
					<div class="mosaico mosaico1 radius-overflow">
					    <a href="{@sonref}" target="_self" title="{@sontitle}">
					        <img src="{@poster1}"/>
					    </a>
					</div>
				    </xsl:when>
				    <xsl:when test="@posters = '3'">
					<div class="mosaico mosaico3 radius-overflow">
					    <a href="{@sonref}" target="_self" title="{@sontitle}">
						<div class="mosaico3a">
						    <img src="{@poster1}"/>
						</div>
					        <div class="mosaico3b">
						    <div>
         					        <img src="{@poster2}"/>
						    </div>
						    <div>
						        <img src="{@poster3}"/>
						    </div>
						</div>
					    </a>
					</div>
				    </xsl:when>
				    <xsl:otherwise>
					<div class="mosaico mosaico1 radius-overflow">
					    <a href="{@sonref}" target="_self" title="{@sontitle}">
					        <img src="/work/models/repositorio/img/empty.jpg"/>
					    </a>
					</div>
				    </xsl:otherwise>
				</xsl:choose>

                                <div class="mosaico-txt">
                                    <p><xsl:value-of select="sontitle" /></p>
                                    <a href="#"><span class="ion-social-facebook"></span></a>
                                    <a href="#"><span class="ion-social-twitter"></span></a>
				    <a href="#" onclick="del('{@sonref}')">Eliminar</a>
                                    <a href="{@sonref}?act=vEdit"><span class="ion-edit"></span></a>
                                </div>
                            </div>
                        </xsl:for-each>
                    </xsl:for-each>
                </xsl:if>
            </div>
        </div>
    </xsl:template>
</xsl:stylesheet>