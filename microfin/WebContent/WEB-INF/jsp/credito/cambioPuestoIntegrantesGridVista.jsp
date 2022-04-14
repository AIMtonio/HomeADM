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
				<c:when test="${tipoLista == '13'}">
					<tr>
						<td class="label" align="center">
						   	<label for="lblconsecutivo"></label> 
						</td>
						<td class="label" align="left">
					   		<label for="lblSolicitudCre">Solicitud</label> 
						</td>
						<td class="label" align="left">
							<label for="lblProspecto">Prospecto</label> 
				  		</td>
				  		<td class="label" align="left">
							<label for="lblClienteID"><s:message code="safilocale.cliente"/></label> 
				  		</td>
				  		<td class="label" align="left">
							<label for="lblNombre">Nombre</label> 
				  		</td>
				  		<td class="label" align="left">
							<label for="lblMontoSol">Monto <br> Solicitado</br></label> 
				  		</td>
				  		<td class="label" align="left">
							<label for="lblMontoAu">Monto <br> Autorizado</br></label> 
				  		</td>
				  		<td class="label" align="left">
							<label for="lblFechaVen">Fecha <br>Inicio</label> 
				  		</td>
				  		<td class="label" align="left">
							<label for="lblFechaVen">Fecha <br>Vencimiento</label> 
				  		</td>
				  		<td class="label" align="left">
							<label for="lblEstatusSol">Estatus <br>Solicitud</label> 
				  		</td>
				  		<td class="label" align="left">
							<label for="lblCredito">Crédito</label>
				  		</td>
				  		<td class="label" align="left">
							<label for="lblEstatusCredito">Estatus <br>Crédito</label> 
				  		</td>
				  		<td class="label" align="left">
							<label for="lblCargo">Cargo</label> 
				  		</td>
				  	
				 	</tr>
					<c:forEach items="${listaResultado}" var="Integrantes" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td> 
								<input id="consecutivo${status.count}"  name="consecutivo" size="3"  
									value="${status.count}" readOnly="true" readOnly="true" type="hidden"/> 
						  	</td> 
						  	<td> 
								<input type="text" id="solicitudCre${status.count}" name="lsolicitudCreditoID" size="9" 
									value="${Integrantes.solicitudCreditoID}" readOnly="true" /> 
						  	</td>
							<td> 
								<input type="text" id="prospecto${status.count}"  name="prospecto" size="7"  
										  value="${Integrantes.prospectoID}" readOnly="true" style='text-align:left;' /> 
							</td> 
							<td> 
								<input type="text" id="cliente${status.count}"  name="cliente" size="7"  
										  value="${Integrantes.clienteID}" readOnly="true"  style='text-align:left;' /> 
							</td>  
						  	<td> 
						  		<input type="text" id="nombreCliente${status.count}" name="nombreCliente" size="50" 
										value="${Integrantes.nombre}" readOnly="true" /> 
						  	</td> 
						  	<td> 
								<input type="text" id="montoSolici${status.count}"  name="montoSolici" size="15"  style="text-align:right;"
									  value="${Integrantes.montoSol}" readOnly="true" esMoneda="true" /> 
							</td>
							
							<td> 
								<input type="text" id="montoAutor${status.count}"  name="montoAutor" size="15"  style="text-align:right;"
									  value="${Integrantes.montoAutoriza}" readOnly="true" esMoneda="true" /> 
							</td>
							<td> 
								<input type="text" id="fechaInicio${status.count}"  name="fechaInicio" size="10"  
										  value="${Integrantes.fechaInicio}" readOnly="true" style="text-align:center;"/> 
							</td> 
							<td> 
								<input type="text" id="fechaVencimiento${status.count}"  name="fechaVencimiento" size="10"  
										  value="${Integrantes.fechaVencimiento}" readOnly="true" style="text-align:center;"/> 
							</td> 
						  	<td> 
								  <input type="hidden" id="estatusSolicitud${status.count}"  name="estatusSolicitud"   value="${Integrantes.estatusSol}"  />  
								<c:if test="${Integrantes.estatusSol == 'I'}"> 
									<input type="text" id="estatusSolici${status.count}"  name="estatusSolici" size="20"  
										  value="INACTIVA" readOnly="true" /> 
								</c:if>
								<c:if test="${Integrantes.estatusSol == 'L'}"> 
									<input type="text" id="estatusSolici${status.count}"  name="estatusSolici" size="20"  
										  value="LIBERADA" readOnly="true" /> 
								</c:if>
								<c:if test="${Integrantes.estatusSol == 'A'}"> 
									<input type="text" id="estatusSolici${status.count}"  name="estatusSolici" size="20"  
										  value="AUTORIZADA" readOnly="true" /> 
								</c:if>
								<c:if test="${Integrantes.estatusSol == 'C'}"> 
									<input type="text" id="estatusSolici${status.count}"  name="estatusSolici" size="20"  
										  value="CANCELADA" readOnly="true" /> 
								</c:if>
								<c:if test="${Integrantes.estatusSol == 'R'}"> 
									<input type="text" id="estatusSolici${status.count}"  name="estatusSolici" size="20"  
										  value="RECHAZADA" readOnly="true" /> 
								</c:if>
								<c:if test="${Integrantes.estatusSol == 'D'}"> 
									<input type="text" id="estatusSolici${status.count}"  name="estatusSolici" size="20"  
										  value="DESEMBOLSADA" readOnly="true" /> 
								</c:if>
							</td>
							 <td> 
								<input type="text" id="credito${status.count}" name="credito" size="12" 
									 value="${Integrantes.credito}" readOnly="true" /> 
						  	</td> 
						  	 <td> 
						  	     <c:if test="${Integrantes.estatusCredito == 'I'}"> 
								<input type="text" id="estatusCredito${status.count}" name="estatusCredito" size="20" 
									value="INACTIVO" readOnly="true" /> 
								</c:if>
								 <c:if test="${Integrantes.estatusCredito == 'A'}"> 
								<input type="text" id="estatusCredito${status.count}" name="estatusCredito" size="20" 
									value="AUTORIZADO" readOnly="true" /> 
								</c:if>
								 <c:if test="${Integrantes.estatusCredito == 'V'}"> 
								<input type="text" id="estatusCredito${status.count}" name="estatusCredito" size="20" 
									value="VIGENTE" readOnly="true" /> 
								</c:if>
								<c:if test="${Integrantes.estatusCredito == 'P'}"> 
								<input type="text" id="estatusCredito${status.count}" name="estatusCredito" size="20" 
									value="PAGADO" readOnly="true" /> 
								</c:if>
								<c:if test="${Integrantes.estatusCredito == 'C'}"> 
								<input type="text" id="estatusCredito${status.count}" name="estatusCredito" size="20" 
									value="CANCELADO" readOnly="true" /> 
								</c:if>
								<c:if test="${Integrantes.estatusCredito == 'B'}"> 
								<input type="text" id="estatusCredito${status.count}" name="estatusCredito" size="20" 
									value="VENCIDO" readOnly="true" /> 
								</c:if>
								<c:if test="${Integrantes.estatusCredito == 'K'}"> 
								<input type="text" id="estatusCredito${status.count}" name="estatusCredito" size="20" 
									value="CASTIGADO" readOnly="true" /> 
								</c:if>
								<c:if test="${Integrantes.estatusCredito == ''}"> 
								<input type="text" id="estatusCredito${status.count}" name="estatusCredito" size="20" 
									value="" readOnly="true" esMoneda="true" /> 
								</c:if>
						  	</td> 	
						  	<td id="tdCargo${status.count}">
						  		<input type="hidden" id="cargoIntegra${status.count}" size="2"  value="${Integrantes.cargo}"  />  
							</td>
							<td id="tdEstatus${status.count}">
						  		<input type="hidden" id="estatusCre${status.count}"  size="2"  value="${Integrantes.estatusCredito}"  />  
							</td>
							<td>
						  		<input type="hidden" id="estatusSol${status.count}"  size="2"  value="${Integrantes.estatusSol}"  />  
							</td>
							<td>
						  		<input type="hidden" id="estatusPagare${status.count}"  size="2"  value="${Integrantes.pagareImpreso}"  />  
							</td>
							<td>
						  		<input type="hidden" id="montoCredito${status.count}"  size="5"  value="${Integrantes.montoCredito}"  
						  		name="montoCredito" readOnly="true"  />  
							</td>
						</tr>
				     	<c:set var="productoCredito" value="${Integrantes.productoCreditoID}"/>
					</c:forEach>
					<tr>
						<td align="right" colspan="5" align="right">
							<input id="prodCreditoID" name="prodCreditoID" size="10" align="right"  type = "hidden"
							        value="${productoCredito}" readOnly="true"/>														 
						</td>
					</tr>
				</c:when>
			</c:choose>
		</table>
	</fieldset>
</form>

