<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head> 
		<script type="text/javascript" src="dwr/interface/cajasVentanillaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>
		
		<script type="text/javascript" src="js/ventanilla/cajasVentanilla.js"></script>  
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cajasVentanillaBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Registro de Cajas</legend>			
	<table border="0" cellpadding="0" cellspacing="0" width="500">
	 	<tr>
	 		<td class="label">
	 			<label for="lblCaja">Caja:</label>
	 		</td>
	 		<td>
					<form:input id="cajaID" name="cajaID" path="cajaID" size="5" tabindex="1" />
	 		</td>
	 		<td class="label">
	 			<label for="lblTipoCaja">Tipo Caja:</label>
				<form:select id="tipoCaja" name="tipoCaja" path="tipoCaja" tabindex="2">
					<form:option value="CA">Caja de Atención al Público</form:option>
					<form:option value="CP">Caja Principal de Sucursal</form:option>
					<form:option value="BG">Boveda Central</form:option>
				</form:select>					
	 		</td>
		</tr>
		<tr>
			<td class="label"><label for="lblValidaHuella">Huella Digital:</label></td>
			<td><select id="huellaDigital" name="huellaDigital" tabindex="11" disabled="true">
					<option value="S">SI</option>
					<option value="N">NO</option>
			</select></td>
		</tr>
		<tr id="trSucursal">
	 		<td class="label">
	 			<label for="lblSucursal">Sucursal:</label>
	 		</td>
	 		<td colspan="2">
				<form:input id="sucursalID" name="sucursalID" path="sucursalID" size="5" tabindex="3" />
				<input type="text" id="desSucursal" name="desSucursal" size="40" disabled="true"/>
	 		</td>
		</tr>
		<tr>
	 		<td class="label">
	 			<label for="lblUsuario">Usuario:</label>
	 		</td>
	 		<td colspan="2">
	 			<form:input id="usuarioID" name="usuarioID" path="usuarioID" size="5" tabindex="4" />
	 			<input type="text" id="nombreUsuario" name="nombreUsuario" size="40" disabled="true" />
	 		</td>
	 	</tr>
	 	
		<tr>
			<td class="label">
	 			<label for="lblLimite">Límite de Efectivo:</label>
	 		</td>
	 		<td colspan="2">
	 			<form:input type="text" id="limiteEfectivoMN" name="limiteEfectivoMN" path="limiteEfectivoMN" size="15" esMoneda="true" tabindex="5" style="text-align: right" onkeypress="return IsNumber(event)" />
	 		</td>
		</tr>
		<tr>
			<td class="label">
	 			<label for="lblLimite">Límite de Desembolso:</label>
	 		</td>
	 		<td colspan="2">
	 			<form:input type="text" id="limiteDesembolsoMN" name="limiteDesembolsoMN" path="limiteDesembolsoMN" size="15" esMoneda="true" tabindex="6" style="text-align: right" onkeypress="return IsNumber(event)" />
	 		</td>
		</tr>
		<tr>
			<td class="label">
	 			<label for="lblLimite">Máximo Retiro:</label>
	 		</td>
	 		<td colspan="2">
	 			<form:input type="text" id="maximoRetiroMN" name="maximoRetiroMN" path="maximoRetiroMN" size="15" esMoneda="true" tabindex="7" style="text-align: right" onkeypress="return IsNumber(event)" />
	 		</td>
		</tr>
		<tr>
			<td class="label">
	 			<label for="lblNombImpresora">Impresora Comprobantes: </label>
	 		</td>
	 		<td colspan="2">
	 			<form:input type="text" id="nomImpresora" name="nomImpresora" path="nomImpresora" maxlength="30" size="30" tabindex="8"  />
	 		</td>
		</tr>
		<tr>
			<td class="label">
	 			<label for="lblNombImpresora">Impresora Cheques: </label>
	 		</td>
	 		<td colspan="2">
	 			<form:input type="text" id="nomImpresoraCheq" name="nomImpresoraCheq" path="nomImpresoraCheq" maxlength="30" size="30" tabindex="9"  />
	 		</td>
		</tr>
		<tr>
			<td class="label">
	 			<label for="lblDescripcion">Descripción de la Caja:</label>
	 		</td>
	 		<td colspan="2">
	 			<form:textarea id="descripcionCaja" name="descripcionCaja" path="descripcionCaja" maxlength="50" size="10" tabindex="10" />
	 		</td>
		</tr>
	</table>
	<table align="right">
		<tr>
			<td align="right">
				<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="12" />
				<input type="submit" id="modificar" name="modificar" class="submit" value="Modificar" tabindex="13" />
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
				<input type="hidden" id="tipoLista" name="tipoLista"/>
				<input type="hidden" id="tipoConsulta" name="tipoConsulta"/>
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