<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
	<head>

	</head>
<body>

<c:set var="listaResultado"  value="${listaResultado}"/>
<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>Relaci&oacute;n de Consultas</legend>
		<form id="gridConsultas" name="gridConsultas" >
			<table  border="0" cellpadding="0" cellspacing="0" width="100%">
				<tbody>	
					<tr  id="encabezadoLista">
						<td style="text-align: center;">Relaci&oacute;n</td>
						<td style="text-align: center;">Nombre</td>
						<td style="text-align: center;">RFC</td>
						<td style="text-align: center;">Datos Consulta</td>
					</tr>
					<c:forEach items="${listaResultado}" var="listaConsulta" varStatus="status">
					<tr id="renglon${status.count}" name="renglon" class="" > 
						<td > 
							<label for="lblRelacion">${listaConsulta.relacion == 1 ? 'TITULAR' : listaConsulta.relacion == 2 ? 'AVAL' : 'OBLIGADO SOLIDARIO'}</label>
							<input type="hidden" id="relacion${status.count}"  	name="relacion"		value="${listaConsulta.relacion}" />
							<input type="hidden" id="registroID${status.count}" name="registroID" 	value="${listaConsulta.registroID}"/>
							<input type="hidden" id="avalID${status.count}" 	name="avalID" 		value="${listaConsulta.avalID}"/>
							<input type="hidden" id="prospectoID${status.count}"name="prospectoID"  value="${listaConsulta.prospectoID}" />
							<input type="hidden" id="calle${status.count}"  	name="calle"  		value="${listaConsulta.calle}"/>
							<input type="hidden" id="estadoID${status.count}"	name="estadoID"  	value="${listaConsulta.estadoID}"/>
							<input type="hidden" id="municipioID${status.count}"name="municipioID"  value="${listaConsulta.municipioID}"/>
							<input type="hidden" id="CP${status.count}"			name="CP"  			value="${listaConsulta.CP}"/>
							<input type="hidden" id="oficial${status.count}"	name="oficial"  	value="${listaConsulta.oficial}"/>
							<input type="hidden" id="tipoContratoCCID${status.count}"	name="tipoContratoCCID"  	value="${listaConsulta.tipoContratoCCID}"/>
					  	</td> 
						<td> 
							<input id="nombre${status.count}"  name="nombre" size="50"  
									value="${listaConsulta.nombreCompleto}" readonly="true" disabled="true"/> 
					  	</td> 
					  	<td> 
							<input type="text" id="RFC${status.count}"  name="RFC" size="20" value="${listaConsulta.RFC}" readonly="true" disabled="true"/>
							<input type="hidden" id="estadoCivil${status.count}"  name="estadoCivil" size="20" value="${listaConsulta.estadoCivil}" readonly="true" disabled="true"/> 
					  	</td>
					  	<td>	
					  			<table style="border: 1px;border-color: gray;border-style: solid;">
					  				<tr>
					  					<td class="label" colspan="4" > 
									   		<label for="lblConsultaBC">Buró de Crédito</label>
										</td>
					  					<td align="center">
									  		<input type="checkbox" id="checkBC${status.count}" name="checkBC" value="${listaConsulta.folioConsulta}" 
									  		${listaConsulta.folioConsulta!=null && listaConsulta.folioConsulta== '0'? 'checked': ''} onclick="validaCheck(this.id)"/>				  		
									  	</td>   
									  	<td> 
											<input id="folioConsulta${status.count}"  name="folioConsulta" size="15"  
													value="${listaConsulta.folioConsulta}" readonly="true" disabled="true"/> 
									  	</td> 
									  	<td> 
											<input id="fechaConsulta${status.count}"  name="fechaConsulta" size="22"  
													value="${listaConsulta.fechaConsulta}" readonly="true" disabled="true"/> 
									  	</td> 
									  	<td> 
											<input id="diasRestantesVig${status.count}"  name="diasRestantesVig" size="4"  
													value="${listaConsulta.folioConsulta!=null && listaConsulta.folioConsulta=='0' ? 0 :listaConsulta.diasVigencia}" readonly="true" disabled="true"/> 
									  	</td> 
									  	<td>
									  		<a id="ligaPDF${status.count}" name="ligaPDF${status.count}" href="ReporteBC.htm" target="_blank" >
									  			<button type="button" id="ver${status.count}" name="ver${status.count}" class="submit" onclick="generaPDF('${listaConsulta.fechaConsulta}', '${listaConsulta.fechaConsulta}', '${listaConsulta.folioConsulta}', 'ligaPDF${status.count}')">Ver Reporte</button>
							 				</a>
									  		
									  	</td>
					  				</tr>
					  				<tr>
					  					<td class="label" colspan="4"> 
									   		<label for="lblConsultaCC">C&iacute;rculo de Cr&eacute;dito</label>
										</td>
					  					<td align="center">
						  					<c:choose>
												<c:when test="${listaConsulta.realizaConsultasCC == 'S'}">
													<input type="checkbox" id="checkCC${status.count}"
										  				value="${listaConsulta.folioConsultaC}" ${listaConsulta.folioConsultaC!=null && listaConsulta.folioConsultaC== '0' ? 'checked' :''} 
										  				name="checkCC"  onclick="validaCheckC(this.id)"/>
												</c:when>
												<c:otherwise>
													<input type="checkbox" id="checkCC${status.count}" disabled="disabled" readonly="readonly"
										  				value="${listaConsulta.folioConsultaC}" 
										  				${ listaConsulta.folioConsultaC!=null && listaConsulta.folioConsultaC== '0'? 'checked' : ''} 
										  				name="checkCC"  onclick="validaCheckC(this.id)"/>
												</c:otherwise>
											</c:choose>	  		
									  	</td>   
									  	<td> 
											<input id="folioConsultaC${status.count}"  name="folioConsultaC" size="15"  
													value="${listaConsulta.folioConsultaC}"
													readonly="true" disabled="true"/> 
									  	</td> 
									  	<td> 
											<input id="fechaConsultaC${status.count}"  name="fechaConsultaC" size="22"
													value="${listaConsulta.fechaConsultaC}"  
													readonly="true" disabled="true"/> 
									  	</td> 
									  	<td> 
											<input id="diasVigenciaC${status.count}"  name="diasVigenciaC" size="4"
													value="${listaConsulta.diasVigenciaC}"  
													readonly="true" disabled="true"/> 
									  	</td> 
									  	<td>
								  			<a id="ligaPDFC${status.count}" name="ligaPDFC${status.count}" target="_blank" >
								  			<button type="button" id="verC${status.count}" name="verC${status.count}" class="submit" onclick="generaPDFC('${listaConsulta.fechaConsultaC}', '${listaConsulta.fechaConsultaC}', '${listaConsulta.folioConsultaC}', 'ligaPDFC${status.count}')">Ver Reporte</button>
						 					</a>
									  	</td>
					  				</tr>
					  			</table>
						</td>
					 </tr>
					<c:set var="cuotas" value="${status.count}"/>
					<c:set var="numTransaccion" value="${listaConsulta.numTransaccion}"/>
					</c:forEach>
				</tbody>
				
			</table>
			</form>
		</fieldset>
</body>
</html>