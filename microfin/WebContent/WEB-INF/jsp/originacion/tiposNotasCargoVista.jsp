<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/tiposNotasCargoServicio.js"></script>
		<script type="text/javascript" src="js/originacion/tiposNotasCargo.js"></script>
	</head>
<body>
<div id="contenedorForma">
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="tiposNotasCargoBean">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend class="ui-widget ui-widget-header ui-corner-all">Tipos de notas de cargo</legend>
			<table>
				<tr>
					<td class="label" nowrap="nowrap" align="left">
						<label for="tipoNotaCargoID">N&uacute;mero: </label>
					</td>
					<td>
						<input type="text" id="tipoNotaCargoID" name="tipoNotaCargoID" maxlength="9" tabindex="1" size="5"/>
						<input type="text" id="nombre" readOnly="true" size="26"/>
					</td>
				</tr>
				<tr>
					<td class="label" nowrap="nowrap" align="left">
						<label for="nombreCorto">Nombre Corto: </label>
					</td>
					<td>
						<input type="text" id="nombreCorto" name="nombreCorto" maxlength="50" tabindex="2" size="35" onBlur="ponerMayusculas(this);"/>
					</td>
				</tr>
				<tr>
					<td class="label" nowrap="nowrap" align="left">
						<label for="descripcion">Descripci&oacute;n: </label>
					</td>
					<td>
						<input type="text" id="descripcion" name="descripcion" maxlength="500" tabindex="3" size="35" onBlur="ponerMayusculas(this);"/>
					</td>
				</tr>
				<tr>
					<td class="label" nowrap="nowrap" align="left">
						<label for="estatus">Estatus: </label>
					</td>
					<td>
						<select id="estatus" name="estatus" path="estatus" tabindex="4" type="select">
							<option value="">SELECCIONAR</option>
							<option value="A">ACTIVO</option>
							<option value="I">INACTIVO</option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="label" nowrap="nowrap" align="left">
						<label for="cobraIVA">Cobra IVA: </label>
					</td>
					<td>
						<select id="cobraIVA" name="cobraIVA" path="cobraIVA" tabindex="5" type="select">
							<option value="">SELECCIONAR</option>
							<option value="S">SI</option>
							<option value="N">NO</option>
						</select>
					</td>
				</tr>
			</table>
			<br/>
			<table align="right">
				<tr>
				<td class="separador"></td>
				<td colspan="5" align="right">
					<input type="submit" id="guardar" name="guardar" class="submit" value="Guardar" tabindex="5" />
					<input type="submit" id="modificar" name="modificar" class="submit" value="Modificar" tabindex="7" />
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
<br>
<br>
</html>