<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head> 
		<script type="text/javascript" src="dwr/interface/cajasVentanillaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>

		<script type="text/javascript" src="js/ventanilla/administraCajasVentanilla.js"></script>  
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cajasVentanillaBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Administración de Estados de Cajas</legend>			
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
	 	<tr>
	 		<td class="label">
	 			<label for="lblCaja">Caja:</label>
	 		</td>
	 		<td>
					<form:input id="cajaID" name="cajaID" path="cajaID" size="5" tabindex="1" />
	 		</td>
	 		<td class="label">
	 			<label for="lblTipoCaja">Tipo Caja:</label>
				<form:select id="tipoCaja" name="tipoCaja" path="tipoCaja" tabindex="2" disabled="true">
					<form:option value="CA">Caja de Atención al Público</form:option>
					<form:option value="CP">Caja Principal de Sucursal</form:option>
					<form:option value="BG">Boveda Central</form:option>
				</form:select>					
	 		</td>
		</tr>
		<tr>
	 		<td class="label">
	 			<label for="lblUsuario">Usuario:</label>
	 		</td>
	 		<td colspan="2">
	 			<form:input id="usuarioID" name="usuarioID" path="usuarioID" size="5" tabindex="3" disabled="true" />
	 			<input type="text" id="nombreUsuario" name="nombreUsuario" size="40" disabled="true" />
	 		</td>
	 	</tr>
	 	<tr id="trSucursal">
	 		<td class="label">
	 			<label for="lblSucursal">Sucursal:</label>
	 		</td>
	 		<td colspan="2">
				<form:input id="sucursalID" name="sucursalID" path="sucursalID" size="5" tabindex="4" disabled="true"/>
				<input type="text" id="desSucursal" name="desSucursal" size="40" disabled="true"/>
	 		</td>
		</tr>
		<tr>
			<td class="label">
	 			<label for="lblLimite">Límite de Efectivo:</label>
	 		</td>
	 		<td colspan="2">
	 			<form:input type="text" id="limiteEfectivoMN" name="limiteEfectivoMN" path="limiteEfectivoMN" size="10" disabled="true" esMoneda="true" tabindex="5" />
	 		</td>
		</tr>
		<tr>
			<td class="label">
				<label for="lblEstatus">Estatus:</label>
			</td>
			<td>
				<form:input id="estatus" name="estatus" path="estatus" size="12" disabled="true" />
			</td>
			<td class="label">
				<label for="lblMotivoUltimo">Motivo Último Movimiento:</label>
				<textarea id="motivoUltimo" name="motivoUltimo" size="12" disabled="true" ></textarea>
			</td>
		</tr>
		<tr>
			<td class="label">
				<label for="lblDescripcion">Descripción Caja:</label>
			</td>
			<td>
				<form:textarea id="descripcionCaja" name="descripcionCaja" path="descripcionCaja" maxlength="50" size="12" disabled="true" />
			</td>
		</tr>
		<tr>
			<td class="label">
				<label for="lblFecha">Fecha:</label>
			</td>
			<td>
				<input type="text" id="fecha" name="fecha" size="10" disabled="true"/>
			</td>
		</tr>
		<tr>
			<td class="label">
				<label for="lblMotivo">Motivo Nuevo Movimiento:</label>
			</td>
			<td>
				<textarea id="motivo" name="motivo" cols="20" rows="3" maxlength="100"></textarea>
			</td>
		</tr>
		
	</table>
	<table align="right">
		<tr>
			<td align="right">
				<input type="submit" id="activa" name="activa" class="submit" value="Activar" tabindex="6" />
				<input type="submit" id="inactiva" name="inactiva" class="submit" value="Inactivar" tabindex="7" />
				<input type="submit" id="cancela" name="cancela" class="submit" value="Cancelar Caja" tabindex="7" />
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
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