<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/tiposFondeadoresServicio.js"></script>
		<script type="text/javascript" src="js/crowdfunding/tiposFondeadores.js"></script>
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="tiposFondeadores">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend class="ui-widget ui-widget-header ui-corner-all">Tipo Inversionista</legend>
		<table border="0" width="100%">
			<tr>
				<td class="label">
					<label for="tipoFondeadorID">Tipo Inversionista: </label>
				</td>
				<td>
					<form:input id="tipoFondeadorID" name="tipoFondeadorID" path="tipoFondeadorID" size="10" tabindex="1" iniforma="false"/>
				</td>
				<td class="separador"></td>
				<td class="label">
					<label for="descripcion">Descripci&oacute;n: </label>
				</td>
				<td>
					<form:input id="descripcion" name="descripcion" path="descripcion" size="35" tabindex="2"  onBlur=" ponerMayusculas(this)" autocomplete="off"/>
				</td>
			</tr>
			<tr>
				<td class="label">
					<label for="obligado">Es Obligado Solidario: </label>
				</td>
				<td class="label">
					<form:radiobutton id="esObligadoSolSi" name="esObligadoSol" path="esObligadoSol"
					value="S" tabindex="3" />
					<label for="esObligadoSolSi">Si</label>&nbsp;&nbsp;
					<form:radiobutton id="esObligadoSolNo" name="esObligadoSol" path="esObligadoSol"
					value="N" tabindex="3" checked="checked"/>
					<label for="esObligadoSolNo">No</label>
				</td>
				<td class="separador"></td>
				<td class="label">
					<label for="obligado">Pago en Incumplimiento: </label>
				</td>
				<td class="label">
					<form:radiobutton id="pagoEnIncumpleSi" name="pagoEnIncumple" path="pagoEnIncumple"
					value="S" tabindex="4" />
					<label for="pagoEnIncumpleSi">Si</label>&nbsp&nbsp;
					<form:radiobutton id="pagoEnIncumpleNo" name="pagoEnIncumple" path="pagoEnIncumple"
					value="N" tabindex="4" checked="checked"/>
					<label for="pagoEnIncumpleNo">No</label>
				</td>
			</tr>
			<tr>
				<td class="label" nowrap="nowrap">
					<label for="porcentajeMora">% Participaci&oacute;n en Mora: </label>
				</td>
				<td>
					<form:input id="porcentajeMora" maxlength="8" name="porcentajeMora" path="porcentajeMora" size="10" tabindex="5" esTasa="true" style="text-align: right;"/>
				</td>
				<td class="separador"></td>
				<td class="label" nowrap="nowrap">
					<label for="porcentajeComisi">% Participaci&oacute;n en Comisiones: </label>
				</td>
				<td>
					<form:input id="porcentajeComisi" maxlength="8" name="porcentajeComisi" path="porcentajeComisi" size="10" tabindex="6" esTasa="true" style="text-align: right;"/>
				</td>
			</tr>
			<tr>
				<td class="label">
					<label for="estatus">Estatus: </label>
				</td>
				<td>
					<form:input id="estatus" name="estatus" path="estatus" size="10" tabindex="-1" disabled="true" readOnly="true"/>
				</td>
				<td class="separador"></td>
				<td class="separador"></td>
				<td class="separador"></td>
			</tr>
			<tr align="right">
				<td align="right" colspan="5">
					<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar" tabindex="20"/>
					<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar" tabindex="21"/>
					<input type="submit" id="elimina" name="elimina" class="submit" value="Eliminar" tabindex="22"/>
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
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;position:absolute; z-index:999;"></div>
</html>
