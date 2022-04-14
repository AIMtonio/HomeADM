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
				<c:when test="${tipoLista == '2'}">
					<tr>
						<td class="label"> 
					   		<label for="lblconsecutivo"></label> 
						</td>
						<td class="label"> 
					   		<label for="lblSolicitudCre">Sol. de Crédito</label> 
						</td>
						<td class="label"> 
							<label for="lblClienteID">No. <s:message code="safilocale.cliente"/></label> 
				  		</td>
				  		<td class="label"> 
							<label for="lblNombre">Nombre</label> 
				  		</td>
				  		<td class="label"> 
							<label for="lblMontoAu">Monto</label> 
				  		</td>
						<td class="label"> 
							<label for="lblProductoCre">Fecha Inicio</label> 
				  		</td>
				  		
				  		<td class="label"> 
							<label for="lblCargo">Fecha Vencimiento</label> 
				  		</td>
				  		<td class="label"> 
							<label for="lblCargo">No. Crédito</label> 
				  		</td>
				  	</tr>
					<c:forEach items="${listaResultado}" var="Integrantes" varStatus="status">
					<tr id="renglon${status.count}" name="renglon">
						<td> 
							<input id="consecutivoID${status.count}"  name="consecutivoID" size="3"  
										value="${status.count}" readOnly="true" disabled="true" type="hidden"/> 
						</td> 
						<td> 
							<input type="text" id="solicitudCre${status.count}" name="solicitudCre" size="12" 
										 value="${Integrantes.solicitudCreditoID}" readOnly="true" disabled="true" /> 
						</td>
						<td> 
							<input type="text" id="clienteID${status.count}"  name="clienteID" size="12"  
										  value="${Integrantes.clienteID}"readOnly="true" disabled="true" /> 
						</td>  
						<td> 
						 	<input type="text" id="nombre${status.count}" name="nombre" size="50" 
										value="${Integrantes.nombre}" readOnly="true" disabled="true"/> 
						</td> 
						<td> 
							<input type="text" id="monto${status.count}"  name="monto" size="15"  
									  value="${Integrantes.montoAu}" readOnly="true" disabled="true" esMoneda="true" style='text-align:right;' /> 
						</td>
						<td> 
							<input type="text" id="fechaInicio${status.count}"  name="fechaInicio" size="15"  
									  value="${Integrantes.fechaInicio}" readOnly="true" disabled="true" /> 
						</td> 
						<td> 
							<input type="text" id="fechaVencimiento${status.count}"  name="fechaVencimiento" size="15"  
									  value="${Integrantes.fechaVencimiento}" readOnly="true" disabled="true" /> 
						</td> 
						<td> 
							<input type="text" id="prospectoID${status.count}"  name="prospectoID" size="15"  
									  value="${Integrantes.creditoID}" readOnly="true" disabled="true" /> 
						</td> 
				 	</tr>
				    	<c:set var="productoCredito" value="${Integrantes.productoCreditoID}"/>
				     	<c:set var="fecReg" value="${Integrantes.fechaRegistro}"/>
					</c:forEach>
					<tr>
						<td align="right">
							<input id="productoCreditoID" name="productoCreditoID" size="10" align="right"  type = "hidden"
								value="${productoCredito}" readOnly="true" disabled="true"/>	
							<input id="fecRegistro" name="fecRegistro" size="10" align="right"  type = "hidden"
							    value="${fecReg}" readOnly="true" disabled="true"/>													 
						</td>
					</tr>
				</c:when>
				
				<c:when test="${tipoLista == '4'}">
					<tr>
						<td class="label"> 
							<label for="lblCargo">Selec.</label> 
				  		</td>
						<td class="label"> 
						   	<label for="lblconsecutivo"></label> 
						</td>
						<td class="label"> 
					   		<label for="lblSolicitudCre">Solicitud</label> 
						</td>
						<td class="label"> 
					   		<label for="lblSolicitudCre">Crédito</label> 
						</td>
						<td class="label"> 
							<label for="lblClienteID">Prospecto</label> 
				  		</td>
				  		<td class="label"> 
							<label for="lblClienteID"><s:message code="safilocale.cliente"/></label> 
				  		</td>
				  		<td class="label"> 
							<label for="lblNombre">Nombre</label> 
				  		</td>
				  		<td class="label"> 
							<label for="lblMontoAu">Monto <br> Solicitado</br></label> 
				  		</td>
				  		<td class="label"> 
							<label for="lblMontoAu">Monto <br> Autorizado</br></label> 
				  		</td>
				  		<td class="label"> 
							<label for="lblProductoCre">Fecha <br> Inicio</label> 
				  		</td>
				  		<td class="label"> 
							<label for="lblCargo">Fecha <br>Vencimiento</label> 
				  		</td>
				  		<td class="label"> 
							<label for="lblCargo">Estatus <br> Solicitud</label> 
				  		</td>
				  		<td class="label"> 
							<label for="lblCargo">Estatus <br> Integrante</label> 
				  		</td>
				  		<td class="label">
							 <!-- td parte donde van los mensajes ocultos de ejecutivos, si 
							 requiere o no garantía -->
							 <label for="lblTipoIntegrante">Tipo <br> Integrante</label> 
				  		</td>
				  		<td class="label"> 
							<label for="lblCiclo">Ciclo</label> 
				  		</td>
				 	</tr>
					<c:forEach items="${listaResultado}" var="Integrantes" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td>
								<c:if test="${status.count == '1'}"> 
									<input type="radio" id="radioSolicitud${status.count}" checked="true" name="radioSolicitud" size="12" 
										value="${Integrantes.solicitudCreditoID}"  onclick="validarRadio('${status.count}');" />  
									
									<input type="hidden" id="${status.count}"  name="radioSeleccionado"  value="S"    />  
								</c:if>	
								<c:if test="${status.count != '1'}"> 
									<input type="radio" id="radioSolicitud${status.count}" name="radioSolicitud" size="12" 
										value="${Integrantes.solicitudCreditoID}"  onclick="validarRadio('${status.count}');" />  
									<input type="hidden" id="${status.count}"  name="radioSeleccionado"  value="N"    />
								</c:if>
							</td>
							<td> 
								<input id="consecutivo${status.count}"  name="consecutivo" size="3"  
									value="${status.count}" readOnly="true" disabled="true" type="hidden"/> 
						  	</td> 
						  	<td> 
								<input type="text" id="solicitudCre${status.count}" name="solicitudCre" size="9" 
									value="${Integrantes.solicitudCreditoID}" readOnly="true" disabled="true" /> 
						  	</td>
						  	<td> 
								<input type="text" id="creditoID${status.count}" name="creditoID" size="9" 
									value="${Integrantes.creditoID}" readOnly="true" disabled="true" /> 
						  	</td>
						  	<td> 
								<input type="text" id="prospecto${status.count}"  name="prospecto" size="7"  
										  value="${Integrantes.prospectoID}"readOnly="true" disabled="true"  style='text-align:right;' /> 
							</td> 
							<td> 
								<input type="text" id="cliente${status.count}"  name="cliente" size="7"  
										  value="${Integrantes.clienteID}"readOnly="true" disabled="true"  style='text-align:right;' /> 
							</td>  
						  	<td> 
						  		<input type="text" id="nomb${status.count}" name="nomb" size="40" 
										value="${Integrantes.nombre}" readOnly="true" disabled="true"/> 
						  	</td> 
						  	<td> 
								<input type="text" id="montoSolici${status.count}"  name="montoSolici" size="15"  style="text-align:right;"
									  value="${Integrantes.montoSol}" readOnly="true" disabled="true" esMoneda="true"/> 
							</td> 
							<td> 
								<input type="text" id="montoAutori${status.count}"  name="montoAutori" size="15"  style="text-align:right;"
										  value="${Integrantes.montoAu}" readOnly="true" disabled="true" esMoneda="true" /> 
							</td>
							<td> 
								<input type="text" id="fechaIni${status.count}"  name="fechaIni" size="10"  
										  value="${Integrantes.fechaInicio}" readOnly="true" disabled="true" /> 
							</td> 
							<td> 
								<input type="text" id="fechaVencimiento${status.count}"  name="fechaVencimiento" size="10"  
										  value="${Integrantes.fechaVencimiento}" readOnly="true" disabled="true" /> 
							</td> 
							<td> 
								<input type="hidden" id="estatusSolicitud${status.count}"  name="estatusSolicitud"   value="${Integrantes.solEstatus}"  /> 
								<c:if test="${Integrantes.solEstatus == 'I'}"> 
									<input type="text" id="estatusSolici${status.count}"  name="estatusSolici" size="15"  
										  value="INACTIVA" readOnly="true" disabled="true" /> 
								</c:if>
								<c:if test="${Integrantes.solEstatus == 'L'}"> 
									<input type="text" id="estatusSolici${status.count}"  name="estatusSolici" size="15"  
										  value="LIBERADA" readOnly="true" disabled="true" /> 
								</c:if>
								<c:if test="${Integrantes.solEstatus == 'A'}"> 
									<input type="text" id="estatusSolici${status.count}"  name="estatusSolici" size="15"  
										  value="AUTORIZADA" readOnly="true" disabled="true" /> 
								</c:if>
								<c:if test="${Integrantes.solEstatus == 'C'}"> 
									<input type="text" id="estatusSolici${status.count}"  name="estatusSolici" size="15"  
										  value="CANCELADA" readOnly="true" disabled="true" /> 
								</c:if>
								<c:if test="${Integrantes.solEstatus == 'R'}"> 
									<input type="text" id="estatusSolici${status.count}"  name="estatusSolici" size="15"  
										  value="RECHAZADA" readOnly="true" disabled="true" /> 
								</c:if>
								<c:if test="${Integrantes.solEstatus == 'D'}"> 
									<input type="text" id="estatusSolici${status.count}"  name="estatusSolici" size="15"  
										  value="DESEMBOLSADA" readOnly="true" disabled="true" /> 
								</c:if>
							</td>
							<td> 
								<input type="hidden" id="estatusIntegrante${status.count}"  name="estatusIntegrante"   
									value="${Integrantes.integEstatus}" /> 
								<c:if test="${Integrantes.integEstatus == 'A'}"> 
									<input type="text" id="estatusIntegra${status.count}"  name="estatusIntegra" size="15"  
										  value="ACTIVO" readOnly="true" disabled="true" /> 
								</c:if>
								<c:if test="${Integrantes.integEstatus == 'I'}"> 
									<input type="text" id="estatusIntegra${status.count}"  name="estatusIntegra" size="15"  
										  value="INACTIVO" readOnly="true" disabled="true" /> 
								</c:if>
								<c:if test="${Integrantes.integEstatus == 'R'}"> 
									<input type="text" id="estatusIntegra${status.count}"  name="estatusIntegra" size="15"  
										  value="RECHAZADO" readOnly="true" disabled="true" /> 
								</c:if>
							</td>
							<td> 
								<input type="hidden" id="estatusCargo${status.count}"  name="estatusCargo" value="${Integrantes.cargo}" /> 
								<c:if test="${Integrantes.cargo == '1'}"> 
									<input type="text" id="cargo${status.count}"  name="cargo" size="13"  
										  value="PRESIDENTE" readOnly="true" disabled="true" /> 
								</c:if>
								<c:if test="${Integrantes.cargo == '2'}"> 
									<input type="text" id="cargo${status.count}"  name="cargo" size="13"  
										  value="TESORERO" readOnly="true" disabled="true" /> 
								</c:if>
							 	<c:if test="${Integrantes.cargo == '3'}"> 
									<input type="text" id="cargo${status.count}"  name="cargo" size="13"  
										  value="SECRETARIO" readOnly="true" disabled="true" /> 
								</c:if>
					 			<c:if test="${Integrantes.cargo == '4'}"> 
									<input type="text" id="cargo${status.count}"  name="cargo" size="13"  
										  value="INTEGRANTE" readOnly="true" disabled="true" /> 
								</c:if>
						 	</td>		
						 	<td> 
								<input type="text" id="ciclo${status.count}"  name="ciclo" size="5"  
										  value="${Integrantes.ciclo}" readOnly="true" disabled="true" /> 
							</td> 
							<td> 
								<input id="sexo${status.count}"  name="sexo"  size="0" 
										  value="${Integrantes.sexo}"  type="hidden"/> 
							</td> 
							<td> 
								<input id="estadoCivil${status.count}"  name="estadoCivil" size="0"  
										  value="${Integrantes.estadoCivil}" type="hidden" /> 
							</td> 
							<td> 
								<input type="hidden" id="comentarioEjecutivo${status.count}"  name="LcomentarioEjecutivo"  
									  value="${Integrantes.comentarioEjecutivo}" readOnly="true" disabled="true" /> 
								<input type="hidden" id="nuevosComentarios${status.count}"  name="LnuevosComentarios"  
								    	  value="" readOnly="true" disabled="true" /> 
								<input type="hidden" id="requiereGarantia${status.count}"  name="LrequiereGarantia" 
										  value="${Integrantes.requiereGarantia}" readOnly="true" disabled="true" /> 
								<input type="hidden" id="requiereAvales${status.count}"  name="LrequiereAvales"  
										  value="${Integrantes.requiereAvales}" readOnly="true" disabled="true" /> 
								<input type="hidden" id="perAvaCruzados${status.count}"  name="LperAvaCruzados"  
										  value="${Integrantes.perAvaCruzados}" readOnly="true" disabled="true" /> 	
								<input type="hidden" id="perGarCruzadas${status.count}"  name="LperGarCruzadas" 
										  value="${Integrantes.perGarCruzadas}" readOnly="true" disabled="true" />									  			    		  
							</td>
						</tr>
				     	<c:set var="productoCredito" value="${Integrantes.productoCreditoID}"/>
				     	<c:set var="fecReg" value="${Integrantes.fechaRegistro}"/>
					</c:forEach>
					<tr>
						<td align="right" colspan="5" align="right">
							<input id="prodCreditoID" name="prodCreditoID" size="10" align="right"  type = "hidden"
							        value="${productoCredito}" readOnly="true" disabled="true"/>	
							<input id="fecRegistro" name="fecRegistro" size="10" align="right"  type = "hidden"
							         value="${fecReg}" readOnly="true" disabled="true"/>													 
						</td>
					</tr>
				</c:when>
			</c:choose>
		</table>
	</fieldset>
</form>

