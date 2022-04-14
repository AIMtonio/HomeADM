<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>


<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaResultado" value="${listaResultado[1]}"/>

<form id="gridIntegrantes" name="gridIntegrantes">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend>Integrantes</legend>	
		<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
			<c:choose>
				<c:when test="${tipoLista == '12'}">
					<tr>
						<td class="label" align="center">
							<label for="lblCargo">Seleccionar</label> 
				  		</td>
						<td class="label" align="center">
						   	<label for="lblconsecutivo"></label> 
						</td>
						<td class="label" align="center">
					   		<label for="lblSolicitudCre">Núm. <br> Solicitud</br></label> 
						</td>
						<td class="label" align="center">
							<label for="lblClienteID"><s:message code="safilocale.cliente"/></label> 
				  		</td>
						<td class="label" align="center">
							<label for="lblProspecto">Prospecto</label> 
				  		</td>
				  		<td class="label" align="center">
							<label for="lblNombre">Nombre</label> 
				  		</td>
				  		 <td class="label" align="center">
					   		<label for="lblPromotor">Promotor</label> 
						</td> 
						<td class="label" align="center">
							<label for="lblEstatus">Estatus</label> 
				  		</td>
				  		<td class="label" align="center">
							<label for="lblSucursal">Sucursal</label> 
				  		</td>
				  		<td class="label" align="center">
							<label for="lblPlazo">Plazo</label> 
				  		</td>
				  		<td class="label" align="center">
							<label for="lblFechaVen">Fecha <br>Vencimiento</label> 
				  		</td>
				  		<td class="label" align="center">
							<label for="lblMontoSol">Monto <br> Solicitado</br></label> 
				  		</td>
				  		<td class="label" align="center">
							<label for="lblMontoAu">Monto <br> Autorizado</br></label> 
				  		</td>
				  		<td class="label" align="center">
							<label for="lblAporte">Aporte <br> <s:message code="safilocale.cliente"/></br></label> 
				  		</td>
				  	
				 	</tr>
					<c:forEach items="${listaResultado}" var="Integrantes" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td align="center">
								<c:if test="${Integrantes.solEstatus == 'L'}">
								<input type="checkbox" id="checkSolicitud${status.count}" 
									name="checkSolicitud"  value="${Integrantes.solicitudCreditoID}" 
										 onclick="habilitaBotonSolicitud();" size="7"  />
	     					</c:if>	
	     						<c:if test="${Integrantes.solEstatus == 'I'}">
								<input type="checkbox" id="check${status.count}" 
									name="check"  value="${Integrantes.solicitudCreditoID}"
									 onclick="validaCheckInactiva(this.id);" size="7"  />
	     					</c:if>	
							</td>
							<td> 
								<input id="consecutivo${status.count}"  name="consecutivo" size="1"  
									value="${status.count}" readOnly="true" type="hidden"/> 
						  	</td> 
						  	<td> 
								<input type="text" id="solicitudCre${status.count}" name="solicitudCre" size="9" 
									value="${Integrantes.solicitudCreditoID}"  readOnly="true" style='text-align:right;' /> 
						  	</td>
							<td> 
								<input type="text" id="cliente${status.count}"  name="cliente" size="7"  
										  value="${Integrantes.clienteID}"  readOnly="true"  style='text-align:right;' /> 
							</td>  
							<td> 
								<input type="text" id="prospecto${status.count}"  name="prospecto" size="7"  
										  value="${Integrantes.prospectoID}"  readOnly="true" style='text-align:right;' /> 
							</td> 
						  	<td> 
						  		<input type="text" id="nombreCliente${status.count}" name="nombreCliente" size="50" 
										value="${Integrantes.nombre}"  readOnly="true"/> 
						  	</td> 
						  	 <td> 
								<input type="text" id="nombrePromotor${status.count}" name="nombrePromotor" size="50" 
									value="${Integrantes.nombrePromotor}" readOnly="true" /> 
						  	</td> 

						  	<td> 
								<input type="hidden" id="estatusSolicitud${status.count}"  name="estatusSolicitud"   value="${Integrantes.solEstatus}"  /> 
								<c:if test="${Integrantes.solEstatus == 'I'}"> 
									<input type="text" id="estatusSolici${status.count}"  name="estatusSolici" size="20"  
										  value="INACTIVA"  readOnly="true" /> 
								</c:if>
								<c:if test="${Integrantes.solEstatus == 'L'}"> 
									<input type="text" id="estatusSolici${status.count}"  name="estatusSolici" size="20"  
										  value="LIBERADA"  readOnly="true" /> 
								</c:if>
								<c:if test="${Integrantes.solEstatus == 'A'}"> 
									<input type="text" id="estatusSolici${status.count}"  name="estatusSolici" size="20"  
										  value="AUTORIZADA"  readOnly="true" /> 
								</c:if>
								<c:if test="${Integrantes.solEstatus == 'C'}"> 
									<input type="text" id="estatusSolici${status.count}"  name="estatusSolici" size="20"  
										  value="CANCELADA" disabled="true" /> 
								</c:if>
								<c:if test="${Integrantes.solEstatus == 'R'}"> 
									<input type="text" id="estatusSolici${status.count}"  name="estatusSolici" size="20"  
										  value="RECHAZADA"  readOnly="true" /> 
								</c:if>
								<c:if test="${Integrantes.solEstatus == 'D'}"> 
									<input type="text" id="estatusSolici${status.count}"  name="estatusSolici" size="20"  
										  value="DESEMBOLSADA"  readOnly="true" /> 
								</c:if>
							</td>
							 <td> 
								<input type="text" id="nombreSucursal${status.count}" name="nombreSucursal" size="20" 
									value="${Integrantes.nombreSucursal}"  readOnly="true" /> 
						  	</td> 
						  	 <td> 
								<input type="text" id="plazo${status.count}" name="plazo" size="15" 
									value="${Integrantes.plazoID}"  readOnly="true" /> 
						  	</td> 
						  	<td> 
								<input type="text" id="fechaVencimiento${status.count}"  name="fechaVencimiento" size="10"  
										  value="${Integrantes.fechaVencimiento}"  readOnly="true" style="text-align:center;"/> 
							</td> 
						  	<td> 
								<input type="text" id="montoSolici${status.count}"  name="montoSolici" size="15"  style="text-align:right;"
									  value="${Integrantes.montoSol}"  readOnly="true" esMoneda="true" /> 
							</td> 
							<td> 
							<input type="text" id="montoAutori${status.count}"  name="montoAutori" size="15"  style="text-align:right;"
										   value="${Integrantes.montoAutorizado}" onBlur="validaMonto(this.id)" esMoneda="true" /> 
							</td>
							<td> 
							<input type="text" id="aporte${status.count}"  name="aporte" size="15"  style="text-align:right;"
										     value="${Integrantes.aporte}" esMoneda="true" readOnly="true" /> 
							</td>						
							<td>
						  		<input type="hidden" id="esquemaSolicitud${status.count}"  size="5"  value="${Integrantes.esquemaGrid}"  
						  		name="esquemaSolicitud" readOnly="true"  />  
							</td> 
						</tr>
				     	<c:set var="productoCredito" value="${Integrantes.productoCreditoID}"/>
					</c:forEach>
					<tr>
						<td align="right" colspan="5" align="right">
							<input id="prodCreditoID" name="prodCreditoID" size="10" align="right"  type = "hidden"
							        value="${productoCredito}"  readOnly="true" />														 
						</td>
					</tr>
				</c:when>
			</c:choose>
		</table>
	</fieldset>
</form>
