<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/gruposCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script> 
		<script type="text/javascript" src="js/credito/modificaCondicionesDesem.js"></script>  
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditos">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">		
					<legend class="ui-widget ui-widget-header ui-corner-all">Modifica Condiciones de Desembolso</legend>	
					<table width="100%">
					<tr>
						<td class="label"> 
							<label for="creditoID">Crédito: </label> 
						</td>     
						<td>
							<form:input id="creditoID" name="creditoID" path="creditoID" size="25" tabindex="1" autocomplete ="off" /> 
						</td>
					  	<td class="separador"></td> 
					  	<td class="label"> 
					      	<label for="lblClienteID"><s:message code="safilocale.cliente"/>: </label>    
						<td>
							<form:input id="clienteID" name="clienteID" path="clienteID" size="15" readonly="true"  />
							<input id="nombreCliente" name="nombreCliente" readonly="true" size="40" /> 
						</td>
					</tr> 
					
					<tr>
						<td class="label"> 
   							<label for="producCreditoID">Producto Crédito: </label> 
						</td>     
						<td>
							<form:input id="producCreditoID" name="producCreditoID" path="producCreditoID" size="5" readonly="true" />
							<input id="nombreProducto" name="nombreProducto"  readonly="true" size="40"  /> 
						</td>
					
				  		<td class="separador"></td> 
				   		<td class="label"> 
				       		<label for="lblCuentaID">Cuenta: </label>
						<td>
							<form:input id="cuentaID" name="cuentaID" path="cuentaID" size="15" readonly="true" />
							<input id="descripcionCuenta" name="descripcionCuenta" readonly="true" size="40"  /> 
						</td>
					</tr> 
					 
					<tr>
						<td class="label"> 
							<label for="sucursal">Sucursal: </label> 
						</td>     
						<td>
							<form:input id="sucursal" name="sucursal" path="sucursal" size="5" readonly="true"  />
							<form:input id="nombreSucursal" name="nombreSucursal" path="nombreSucursal" readonly="true" size="40"  /> 
						</td>
						
						<td class="separador"> </td>
						<td class="label"> 
							<label for="lblsolicitudCreditoID">Solicitud: </label> 
						</td>     
						<td>
							<form:input id="solicitudCreditoID" name="solicitudCreditoID" path="solicitudCreditoID" size="15" readonly="true"  />
						</td>
					 </tr>
					 
					 <tr>
						<td class="label"> 
							<label for="">Grupo: </label> 
						</td>     
						<td>
							<form:input id="grupoID" name="grupoID" path="grupoID" size="5" readonly="true"  />
							<input id="descripcionGrupo" name="descripcionGrupo" size="40" readonly="true" /> 
						</td>
						
						<td class="separador"></td> 
						<td class="label"> 
						  		<label for="lblCiclo">Ciclo: </label> 
						</td>     
						<td>
							<input id="ciclo" name="ciclo"  size="15" readonly="true" />
						</td>
					 </tr>
					 
					 <tr>
						<td class="label"> 
							<label for="tipoDispersion">Tipo de Desembolso:</label>
						</td>
						<td>
						<form:select id="tipoDispersion" name="tipoDispersion" path="tipoDispersion"  tabindex="2">
							<form:option value="">SELECCIONAR</form:option>
							<form:option value="S">SPEI</form:option>
							<form:option value="C">CHEQUE</form:option>
							<form:option value="O">ORDEN DE PAGO</form:option>
							<form:option value="E">EFECTIVO</form:option>
						</form:select>
						</td>
						<td class="separador"></td> 
						<td class="label"> 
							<label for="lblEstatus">Estatus: </label> 
						</td>     
						<td>
							<form:input id="estatus" name="estatus" path="estatus" size="15" readonly="true" />
						</td>
					</tr>
					<tr id="tdMontoCredito">
						<td class="label">
						 	<label for="montoCredito">Monto: </label>
						</td> 
						<td>
						  	<input type="text" id="montoCredito" name="montoCredito" size="18" tabindex="3" esMoneda="true" style="text-align: right;" autocomplete ="off"/>
						</td>			
					</tr> 
				<table align="right">
					<tr>
						<td align="right">
						<input type="submit" id="modifica" name="modifica" class="submit" tabindex="4" value="Modificar"/>
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
						<input type="hidden" id="tipoActualizacion" name="tipoActualizacion"/>						
					</td>
					</tr>
				</table> 
		</table>
	</fieldset>
	</form:form>
	</div>
	
	<div id="cargando" style="display: none;">	
	</div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"/>
	</div>
	</body>
	<div id="mensaje" style="display: none;"/>
						
	</body>
</html>