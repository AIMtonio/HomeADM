<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/catCajerosATMServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>

		<script type="text/javascript" src="dwr/interface/ingresosOperacionesServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/cajasVentanillaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cajeroATMTransfServicio.js"></script>
		
		<script type="text/javascript" src="js/tesoreria/cajeroATMRecepTransf.js"></script>  
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cajeroATMTransfer">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Recepción de Efectivo ATM</legend>
	<table border="0" cellpadding="0" cellspacing="0" width="100%"> 	 	
		<tr>
			<td class="label">
				<label for="lblUsurio">Usuario:</label>
			</td>
			<td>
				<input id="usuarioID" name="usuarioID"  size="5" readOnly="true" tabindex="2" readOnly="true" />
				<input type="text" id="nombreUsuario" name="nombreUsuario" size="40" readOnly="true" tabindex="3">
			</td>
			<td class="separador"></td>
			<td class="label"><label for="lblTransferenciaID">Transferencias:</label></td>
			<td>
				<form:select id="cajeroTransfID" name="cajeroTransfID"  path="cajeroTransferID" tabindex="7">
				<form:option value="">Selecciona:</form:option>
				</form:select>
			</td>
			<!-- 
			<td class="label">
				<label for="lblCajero">Cajero:</label>
			</td>
			<td>
				<form:input id="cajeroDestinoID" name="cajeroDestinoID" path="cajeroDestinoID" size="25" tabindex="1" />				
			</td>
			 -->
			
		</tr>
		<tr>
			<td class="label">
				<label for="lblSucursal">Sucursal:</label>
			</td>
			<td>
				<input id="sucursalCajero" name="sucursalCajero"  size="5" tabindex="4" readOnly="true"  />
				<input type="text" id="desSucursal" name="desSucursal" size="40" readOnly="true" tabindex="5">
				
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="lblUbicacion">Ubicación:</label>
			</td>
			<td>
				<input id="ubicacion" name="ubicacion" size="45" readOnly="true" tabindex="6" readOnly="true" />
				
			</td>
		</tr>
			
		
		<tr>
			<td class="label"><label for="lblCajaOrigen">Caja Origen:</label></td>
			<td>
				<form:input id="cajeroOrigenID" name="cajeroOrigenID" path="cajeroOrigenID" size="8" readOnly="true" tabindex="10"/>
				<input type="text" id="descCaja" name="descCaja" readOnly="true"  size="40" tabindex="11">	
			</td>
			<td class="separador"></td>	
			
				<td class="label">
				<label for="lblSucursalOrigen">Sucursal Origen:</label>
			</td>
			<td>
				<form:input id="sucursalID" name="sucursalID" path="sucursalID" size="5" readOnly="true" tabindex="8"/>
				<input type="text" id="descSucursal" name="descSucursal" size="40" readOnly="true" tabindex="9">
			</td>
			
										
			
		</tr>

		<tr>
			<td class="label">
				<label for="lblMoneda">Moneda:</label>
			</td>
			<td>
				<form:select id="monedaID" name="monedaID" path="monedaID" tabindex="12" readOnly="true" disabled="true">
				<form:option value="0">Selecciona:</form:option>
				</form:select>
			</td>	
				<td class="separador"></td>	
			<td class="label"><label for="lblFecha">Fecha:</label></td>
			<td>
				<form:input id="fecha" name="fecha" path="fecha" size="15" readOnly="true" tabindex="13"/>			
			</td>
			
		</tr>
		<tr>
			
			<td class="label"><label for="lblCantidad">Monto:</label></td>
			<td>
				<input id="cantidad" name="cantidad"  size="15" readOnly="true" tabindex="15" esMoneda=true/>			
			</td>
		</tr>

	</table>
	<table align="right">
		<tr>
			<td align="right">
				<input type="submit" id="aceptar" name="aceptar" class="submit" value="Aceptar"  tabindex="20"/>							
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" iniForma="false"/>				
				<input type="button" id="impPoliza" name="impPoliza" class="submit" value="Imp. Póliza" style="display:none"  tabindex="20"/>	
				<input type="hidden" id="polizaID" name="polizaID"  tabindex="20"/>
				<input type="hidden" id="folioTransaccion" name="folioTransaccion" iniForma="false"  />
										
			</td>
		</tr>
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
</html>