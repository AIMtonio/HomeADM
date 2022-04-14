<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
	<script type="text/javascript" src="dwr/interface/calculosyOperacionesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tiposNotasCargoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/notasCargoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
		<script type="text/javascript" src="js/credito/notasCargo.js"></script>
	</head>
<body>
<div id="contenedorForma">
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="notasCargoBean">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend class="ui-widget ui-widget-header ui-corner-all">Notas de Cargo</legend>
			<table>
				<tr>
					<td class="label" nowrap="nowrap" align="left">
						<label for="creditoID">Cr&eacute;dito: </label>
					</td>
					<td>
						<input type="text" id="creditoID" name="creditoID" tabindex="1" size="15"/>
					</td>
					<td class="separador"></td>
					<td class="label" nowrap="nowrap" align="left">
						<label for="clienteID">Cliente: </label>
					</td>
					<td>
						<input type="text" id="clienteID" name="clienteID" maxlength="9" size="5" readOnly="true"/>
						<input type="text" id="nombreCompleto" readOnly="true" size="40"/>
					</td>
				</tr>
				<tr>
					<td class="label" nowrap="nowrap" align="left">
						<label for="tipoNotaCargoID">Tipo de nota: </label>
					</td>
					<td>
						<select id="tipoNotaCargoID" name="tipoNotaCargoID" path="tipoNotaCargoID" tabindex="3" type="select"></select>
					</td>
					<td class="separador"></td>
					<td class="label" nowrap="nowrap" align="left">
						<label for="monto">Monto: </label>
					</td>
					<td>
						<input type="text" id="monto" name="monto" maxlength="14" tabindex="4" size="14" esMoneda="true"/>
					</td>
				</tr>
				<tr>
					<td class="label" nowrap="nowrap" align="left">
						<label for="amortizacionID">Amortizaci&oacute;n a aplicar: </label>
					</td>
					<td>
						<input type="text" id="amortizacionID" name="amortizacionID" maxlength="9" tabindex="5" size="15"/>
					</td>
					<td class="separador"></td>
					<td class="label" nowrap="nowrap" align="left">
						<label for="iva">IVA: </label>
					</td>
					<td>
						<input type="text" id="iva" name="iva" maxlength="14" size="14" esMoneda="true" readOnly="true"/>
					</td>
				</tr>
			</table>
			<table>
				<tr>
					<td class="label" nowrap="nowrap" align="left">
						<label for="motivo">Motivo: </label>
					</td>
					<td>
						<textarea maxlength="2000" id="motivo" name="motivo" rows="3" cols="97" onblur="ponerMayusculas(this);" tabindex="7"></textarea>
					</td>
				</tr>
			</table>
			<br/>
			<div id="formaTabla" style="display: none;"></div>
			<br/>
			<table align="right">
				<tr>
				<td class="separador"></td>
				<td colspan="5" align="right">
					<input type="submit" id="aplicar" name="aplicar" class="submit" value="Aplicar" tabindex="8" />
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
<div id="mensaje" style="display: none; top: 87px;">
</div>
<br>
<br>
</html>