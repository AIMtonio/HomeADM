<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/arrendamientoServicio.js"></script>
		<script type="text/javascript" src="js/arrendamiento/mesaControlArrendamiento.js"></script>
	</head>
	
	<body>
		<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="arrendamientosBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Mesa de Control Arrendamiento</legend>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td class="label">
							<label for="arrendaID">Número: </label>
						</td> 
						<td>
							<form:input type="text" id="arrendaID" name="arrendaID" path="arrendaID" size="12" maxlength="12" tabindex="1" autocomplete="off" />
						</td>
						
						<td class="separador"></td>
											
						<td class="label">
							<label for="clienteID"><s:message code="safilocale.cliente"/>: </label>
						</td>
						<td >
							<form:input type="text"  id="clienteID" name="clienteID" path="clienteID" size="12" disabled="true" />
							<input type="text" id="nombreCliente" name="nombreCliente" disabled="true" size="50"/>
						</td>
					</tr>
					
					<tr>
						<td class="label">
						 	<label for="productoArrendaID">Producto Arrendamiento: </label>
						</td>
						<td>
						 	<form:input type="text" id="productoArrendaID" name="productoArrendaID" path="productoArrendaID" size="5"
						 	disabled="true"/>
						 	<input type="text" id="nombreCorto" name="nombreCorto" disabled="true" size="30" /> 
						</td> 
						
						<td class="separador"></td>
						
						<td class="label">
							<label for="fechaAutoriza">Fecha de Autorización: </label>  
						</td> 
						<td>
							<form:input  id="fechaAutoriza" name="fechaAutoriza" path="fechaAutoriza" size="12" type="text"	readOnly="true" disabled = "true" />  
						</td>			
					</tr>
					
					<tr>
			 			<td class="label">
							<label for="usuarioAutoriza">Usuario autoriza: </label> 
						</td> 
						<td>
							<form:input type="text" id="usuarioAutoriza" name="usuarioAutoriza" path="usuarioAutoriza" size="12" 
							readOnly="true" disabled="true"/>
							<input type="text" id="nombreUsuario" name="nombreUsuario" size="40" readOnly="true" disabled="true"/>
						</td>
						
						<td class="separador"></td>
						 
						<td class="label">
							<label for="estatus">Estatus: </label> 
						</td>   	
						<td>
							<input type="text" id="estatus" name="estatus" path="estatus" size="12" readOnly="true" disabled="true"/>
						</td>
					</tr>
					
					<tr>
						<td class="label">
							<label for="montoArrenda">Monto del bien: </label>  
						</td> 
						<td>
							<form:input id="montoArrenda" name="montoArrenda" path="montoArrenda" size="12" type="text" esMoneda ="true" style="text-align: right" readOnly="true" disabled="true" />  
						</td>
						
						<td class="separador"></td>
						
						<td class="label">
							<label for="ivaMontoArrenda">IVA del bien: </label> 
						</td> 
						<td>
							<form:input id="ivaMontoArrenda" name="ivaMontoArrenda" path="ivaMontoArrenda" size="12" type="text" esMoneda ="true" style="text-align: right" readOnly="true" disabled="true" />
						</td>
					</tr>
					
					<tr>
						<td class="label">
							<label for="fechaApertura">Fecha de apertura: </label>  
						</td> 
						<td>
							<form:input id="fechaApertura" name="fechaApertura" path="fechaApertura" size="12" type="text" readOnly="true" disabled="true" />  
						</td>
						
						<td class="separador"></td>
						 
						<td class="label">
							<label for="montoEnganche">Enganche: </label> 
						</td>
						<td>
							<form:input type="text" id="montoEnganche" name="montoEnganche" path="montoEnganche" size="12" esMoneda ="true" style="text-align: right" disabled="true" />
						</td>
					</tr>
					
					<tr>
						<td class="label">
							<label for="frecuenciaPlazo">Periodicidad: </label> 
						</td> 
						<td>
							<form:input id="frecuenciaPlazo" name="frecuenciaPlazo" path="frecuenciaPlazo" size="12" type="text" readOnly="true" disabled="true" />
						</td>
						
						<td class="separador"></td>
						
						<td class="label">
							<label for="montoSeguroAnual">Seguro: </label>
						</td>
						<td>
							<form:input type="text" id="montoSeguroAnual" name="montoSeguroAnual" path="montoSeguroAnual" size="12" esMoneda ="true" style="text-align: right" disabled="true"/>
						</td>
					</tr>
					
					<tr>
						<td class="label">
							<label for="plazo">Plazo: </label>  
						</td> 
						<td>
							<form:input id="plazo" name="plazo" path="plazo" size="12" type="text" readOnly="true" disabled="true" />  
						</td>
						
						<td class="separador"></td>
						
						<td class="label">
							<label for="tipoPagoSeguro">Seguro de vida: </label>  
						</td> 
						<td>
							<form:input id="tipoPagoSeguro" name="tipoPagoSeguro" path="tipoPagoSeguro" size="12" type="text" readOnly="true" disabled="true" />  
						</td>
					</tr>
					
					<tr>
						<td class="label">
							<label for="montoFinanciado">Monto a financiar total: </label> 
						</td> 
						<td>
							<form:input id="montoFinanciado" name="montoFinanciado" path="montoFinanciado" size="12" type="text" esMoneda ="true" style="text-align: right" readOnly="true" disabled="true" />
						</td>
						
						<td class="separador"></td>
						
						<td class="label">
							<label for="diaPagoProd">Días de pago: </label> 
						</td> 
						<td>
							<form:input id="diaPagoProd" name="diaPagoProd" path="diaPagoProd" size="12" type="text" readOnly="true" disabled="true" />
						</td>
					</tr>
				</table>
				
				<br>
				<br>
				
				<table align="right">
					<tr>
						<td align="right">
							<input type="submit" id="autorizar" name="autorizar" class="submit" value="Autorizar" tabindex="2" />
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="3"/>
							<input type="hidden" id="tipoActualizacion" name="tipoActualizacion" value="1"/>
						</td>
					</tr>
				</table>
			</fieldset>
		</form:form>
		</div>
		<div id="cargando" style="display: none;"></div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"/>
		</div>
	</body>
	<div id="mensaje" style="display: none;"/>
</html>