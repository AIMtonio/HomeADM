<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<c:set var="cuentasFirma"  value="${cuentasFirma}"/>

<div id="gridFirmantes" >
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Firmantes</legend>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td class="label">
					   	<label for="lblPersonaID">N&uacute;mero</label>
						</td>
						<td class="label">
							<label for="lblNombreCompleto">Nombre Completo</label>
				  		</td>

				  		<td class="label">
							<label for="lblTipoFirmante">Tipo Persona</label>
				  		</td>
				  		<td class="label">
							<label for="lblIzquierdo">Mano <br> Izquierda</label>
				  		</td>
				  		<td class="label">
							<label for="lblDerecho">Mano <br> Derecha</label>
				  		</td>
				  		<td class="label">
							<label for="lblDerecho">Estatus Huellas</label>
				  		</td>

					</tr>

					<c:forEach items="${cuentasFirma}" var="cuentasFirmas" varStatus="status">

						<tr>
							<td>
								<input id="cuentaFirmaID${status.count}"  name="cuentaFirmaID" size="15"
										value="${cuentasFirmas.cuentaFirmaID}" readOnly="true"  iniForma = "false"/>
						  	</td>
						  	<td>
								<input id="nombreCompleto${status.count}" name="nombreCompleto" size="50"
										value="${cuentasFirmas.nombreCompleto}" readOnly="true"  iniForma = "false"/>
						  	</td>
						  	<td>
						  	<c:choose>
								<c:when test="${cuentasFirmas.esFirmante =='F'}">
											<input id="esFirmante${status.count}" name="esFirmante"  size="13" readonly="true"  iniForma = "false"
											value="FIRMANTE"/>
								</c:when>

								<c:when test="${cuentasFirmas.esFirmante =='C'}" >
											<input id="esFirmante${status.count}" name="esFirmante"  size="13" readonly="true"  iniForma = "false"
											value="CLIENTE	"/>
								</c:when>
							</c:choose>
						  	</td>
						  	<td>
						  		<c:choose>
						  			<c:when test="${cuentasFirmas.dedoHuellaUno=='' }">
						  				<input id="dedoHuellaUno${status.count}" name="dedoHuellaUno"   readonly="true" size="7" iniForma = "false"  value="N/A"/>
						  			</c:when>
						  			<c:otherwise>
						  				<c:choose>
								  			<c:when test="${cuentasFirmas.dedoHuellaUno=='I' }">
								  				<input id="dedoHuellaUno${status.count}" name="dedoHuellaUno"   readonly="true" size="7"  iniForma = "false"  value="INDICE" />
								  			</c:when>
								  			<c:when test="${cuentasFirmas.dedoHuellaUno=='M' }">
									  			<input id="dedoHuellaUno${status.count}" name="dedoHuellaUno"   readonly="true" size="7" iniForma = "false" value="MEDIO" />

								  			</c:when>
								  			<c:when test="${cuentasFirmas.dedoHuellaUno=='A' }">
									  			<input id="dedoHuellaUno${status.count}" name="dedoHuellaUno"   readonly="true" size="7" iniForma = "false" value="ANULAR" />
								  			</c:when>
								  			<c:when test="${cuentasFirmas.dedoHuellaUno=='N' }">
									  			<input id="dedoHuellaUno${status.count}" name="dedoHuellaUno"   readonly="true" size="7" iniForma = "false" value="MENIQUE" />
								  			</c:when>
								  			<c:when test="${cuentasFirmas.dedoHuellaUno=='P' }">
									  			<input id="dedoHuellaUno${status.count}" name="dedoHuellaUno"   readonly="true" size="7" iniForma = "false" value="PULGAR" />
								  			</c:when>
							  			</c:choose>

						  			</c:otherwise>
						  		</c:choose>
						  	</td>
						  	<td>
						  		<c:choose>
						  			<c:when test="${cuentasFirmas.dedoHuellaDos=='' }">
						  				<input id="dedoHuellaDos${status.count}" name="dedoHuellaDos"   readonly="true" size="7" iniForma = "false"  value="N/A" />

						  			</c:when>
						  			<c:otherwise>
						  				<c:choose>
								  			<c:when test="${cuentasFirmas.dedoHuellaDos=='I' }">
								  					<input id="dedoHuellaDos${status.count}" name="dedoHuellaDos"   readonly="true" size="7" iniForma = "false"  value="INDICE" />
								  			</c:when>
								  			<c:when test="${cuentasFirmas.dedoHuellaDos=='M' }">
									  				<input id="dedoHuellaDos${status.count}" name="dedoHuellaDos"   readonly="true" size="7"  iniForma = "false"  value="MEDIO" />
								  			</c:when>
								  			<c:when test="${cuentasFirmas.dedoHuellaDos=='A' }">
													<input id="dedoHuellaDos${status.count}" name="dedoHuellaDos"   readonly="true" size="7" iniForma = "false"  value="ANULAR" />
								  			</c:when>
								  			<c:when test="${cuentasFirmas.dedoHuellaDos=='N' }">
									  				<input id="dedoHuellaDos${status.count}" name="dedoHuellaDos"   readonly="true" size="7" iniForma = "false"  value="MENIQUE" />
								  			</c:when>
								  			<c:when test="${cuentasFirmas.dedoHuellaDos=='P' }">
									  				<input id="dedoHuellaDos${status.count}" name="dedoHuellaDos"   readonly="true" size="7" iniForma = "false"  value="PULGAR" />
								  			</c:when>
							  			</c:choose>
						  			</c:otherwise>
						  		</c:choose>
						  	</td>
			     			<c:set var="contador"  value="${status.count}"/>
						</tr>
					</c:forEach>
					<tr>
						<td>
							<input type="hidden" id="numeroPersonasRegistradas"  name="numeroPersonasRegistradas" size="7"
										value="${contador}" />

						</td>
					</tr>
			</table>
		</fieldset>
	</div>
