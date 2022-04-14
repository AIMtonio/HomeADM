<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>
<head>

</head>
<body>
</br>



<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaResultado"  value="${listaResultado[1]}"/> 


	<c:choose>
<c:when test="${tipoLista == '5'}">
<form id="gridIntegrantes" name="gridIntegrantes">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend>Integrantes</legend>	
			<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
				<tbody>	
					
					<tr>
						<td class="label"> 
					   	<label for="lblconsecutivo"></label> 
						</td>
						<td class="label"> 
					   	<label for="lblSolicitudCre">No. Crédito</label> 
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
				  		
				  		
				  		<td class="label"> &nbsp;&nbsp;
							<label for="lblCargo">Doc. Completa </label> 
				  		</td>
				  		
				  		<td class="label"> &nbsp;&nbsp;
							<label for="lblCargo">Visualizar</label> 
				  		</td>
				  	</tr>
				
					<c:forEach items="${listaResultado}" var="integraGruposDetalle" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td> 
							
								<input id="consecutivoID${status.count}"  name="consecutivoID" size="3"  
										value="${status.count}" readOnly="true" disabled="true" type="hidden"/> 
								<input type="hidden"  id="estatus${status.count}" name="estatus" value="${integraGruposDetalle.estatus}"/>
								<input type="hidden"  id="cuentaID${status.count}" name="cuentaID" value="${integraGruposDetalle.cuentaID}"/>  																						  														
								<input type="hidden"  id="comentariosEje${status.count}" name="comentariosEje" value="${integraGruposDetalle.comentarioMesaControl}"/>
								
						  	</td> 
						  	<td> 
								<input type="text" id="solicitudCre${status.count}" name="solicitudCre" size="12" 
										 value="${integraGruposDetalle.solicitudCreditoID}" readOnly="true" disabled="true" /> 
						  	</td>
						  	<td> 
								<input  type="text" id="clienteID${status.count}"  name="clienteID" size="12"  
										  value="${integraGruposDetalle.clienteID}"readOnly="true" disabled="true" /> 
							</td>  
						  	<td> 
						  	<input  type="text" id="nombre${status.count}" name="nombre" size="50" 
										value="${integraGruposDetalle.nombre}" readOnly="true" disabled="true"/> 
								
						  	</td> 
							<td> 
								<input type="text" id="monto${status.count}"  name="monto" size="15"  
										  value="${integraGruposDetalle.montoAu}" readOnly="true" disabled="true" esTasa="true" style="text-align:right;" /> 
							</td>
							<td> 
								<input type="text" id="fechaInicio${status.count}"  name="fechaInicio" size="15"  
										  value="${integraGruposDetalle.cargo}" readOnly="true" disabled="true" /> 
							</td> 
							<td> 
								<input type="text" id="fechaVencimiento${status.count}"  name="fechaVencimiento" size="15"  
										  value="${integraGruposDetalle.montoSol}" readOnly="true" disabled="true" /> 
							</td> 	
							
							<td> &nbsp;&nbsp;
								<input type="hidden"  id="credCheckComp${status.count}" name="credCheckComp" value="${integraGruposDetalle.credCheckComp}"/>  														
								<input TYPE="checkbox"id="docCompleta${status.count}" name="docCompleta" value="${integraGruposDetalle.credCheckComp}" readOnly="true" disabled="true"  />
	    							<label for="docCompleta" > </label>  							 							
						  	</td> 
										 
						  	<td>&nbsp;&nbsp;
						  		 																				
	    						<input type="radio"  id="visualizar${status.count}" name="visualizar" value="S" onClick="busca(this.id)"/>
													 							
						  	</td> 						
				     	</tr>
				     		<c:set var="productoCredito" value="${integraGruposDetalle.productoCreditoID}"/>
					</c:forEach>
						<input type="hidden"  id="ver" name="ver" value=""/>  														
															
				
						 <tr>
							<table colspan="5" align="right">
								<tr>
									<td align="right">
										<input id="productoCreditoID" name="productoCreditoID" size="10" align="right"  type = "hidden"
							         value="${productoCredito}" readOnly="true" disabled="true"/>													 
									</td>
								</tr> 	
								
									
							</table> 
								
						</tr>
				</tbody>
			</table>
		</fieldset>
	
</form>
</c:when>
<c:when test="${tipoLista != '5'}">
<div id="gridIntegrantes" name="gridIntegrantes">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend>Integrantes</legend>	
			<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
				<tbody>	
					
					<tr>
						<td class="label"> 
					   	<label for="lblconsecutivo"></label> 
						</td>
						<td class="label"> 
					   	<label for="lblSolicitudCre">No. Crédito</label> 
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
					
						<td class="label" id="lbltipoPrepago" style="display: none;"> 
							<label for="lblPrepago">Tipo Prepago Capital</label> 
				  		</td>
						
				  	</tr>
				
					<c:forEach items="${listaResultado}" var="Integrantes" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td> 
							
								<input  id="consecutivoID${status.count}"  name="consecutivoID" size="3"  
										value="${status.count}" readOnly="true" disabled="true" type="hidden"/> 
						  	</td> 
						  	<td> 
								<input  id="solicitudCre${status.count}" name="lcreditos" size="12" 
										 value="${Integrantes.solicitudCreditoID}" readOnly="true" readonly="true" /> 
						  	</td>
						  	<td> 
								<input id="clienteID${status.count}"  name="clienteID" size="12"  
										  value="${Integrantes.clienteID}"readOnly="true"  /> 
							</td>  
						  	<td> 
						  	<input id="nombre${status.count}" name="nombre" size="50" 
										value="${Integrantes.nombre}" readOnly="true" /> 
								
						  	</td> 
							<td> 
								<input id="monto${status.count}"  name="monto" size="15"  
										  value="${Integrantes.montoAu}" readOnly="true"  esMoneda="true" style='text-align:right;'/> 
							</td>
							<td> 
								<input id="fechaInicio${status.count}"  name="fechaInicio" size="15"  
										  value="${Integrantes.cargo}" readOnly="true"  /> 
							</td> 
							<td> 
								<input id="fechaVencimiento${status.count}"  name="fechaVencimiento" size="15"  
										  value="${Integrantes.montoSol}" readOnly="true"  /> 
							</td> 
				
<c:if test="${Integrantes.mostrarTipoPrepago == 'S'}">	
				<td>
					<input type="hidden" id="prepagos${status.count}" name="prepagos" value="${Integrantes.tipoPrepago}" >
					<select id="tipoPrepago${status.count}"  name="ltipoPrepago" >
						<option value="">Seleccionar</option>
		     			<option value="U">Últimas Cuotas</option>
				      	<option value="I">Cuotas Siguientes Inmediatas</option>	
						<option value="V">Prorrateo Cuotas Vigentes</option>				
					</select> 
				</td>
</c:if> 


							
				     	</tr>
				     		<c:set var="productoCredito" value="${Integrantes.productoCreditoID}"/>
						<c:set var="contador" value="${status.count}"/>
					</c:forEach>
					
						<tr>
							<table colspan="5" align="right">
								<tr>
									<td align="right">
										<input id="productoCreditoID" name="productoCreditoID" size="10" align="right"  type = "hidden"
							         value="${productoCredito}" readOnly="true" disabled="true"/>													 
<input id="contador" name="contador" size="10" align="right"  type = "hidden"
							         value="${contador}" readOnly="true" disabled="true"/>									</td>
								</tr> 	
								
									
							</table> 
								
						</tr>
				</tbody>
			</table>
		</fieldset>
	
</div>

</c:when>
</c:choose>

</body>
</html>