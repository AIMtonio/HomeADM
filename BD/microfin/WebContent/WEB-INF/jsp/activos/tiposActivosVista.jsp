<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/tiposActivosServicio.js"></script>
		<script type="text/javascript" src="js/activos/tiposActivos.js"></script>
	</head>
	<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="tiposActivosBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Tipos de Activos</legend>
				<table>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="tipoActivoID">N&uacute;mero:</label>
						</td>
						<td nowrap="nowrap">
							<form:input type="text" id="tipoActivoID" name="tipoActivoID" path="tipoActivoID" size="15" tabindex="1" autocomplete="off"/>
						</td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap">
							<label for="descripcion">Descripci&oacute;n:</label>
						</td>
						<td nowrap="nowrap">
							<form:textarea id="descripcion" name="descripcion" path="descripcion" COLS="40" ROWS="2" tabindex="2"  onBlur="ponerMayusculas(this); limpiarCajaTexto(this.id);" maxlength="300"/>
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="descripcionCorta">Descripci&oacute;n Corta:</label>
						</td>
						<td nowrap="nowrap">
							<form:input type="text" id="descripcionCorta" name="descripcionCorta" path="descripcionCorta" size="15" tabindex="3" autocomplete="off"  maxlength="15"/>
						</td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap">
							<label for="clasificaActivoID">Clasificaci&oacute;n:</label>
						</td>
						<td nowrap="nowrap">
							<form:select id="clasificaActivoID" name="clasificaActivoID" path="clasificaActivoID" tabindex="4">
								<form:option value="">SELECCIONAR</form:option>
							</form:select>
							<a href="javaScript:" onClick="descripcionCampo('clasificaActivoID');">
								<img src="images/help-icon.gif" >
							</a>
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="depreciacionAnual">% Depreciaci&oacute;n Anual:</label>
						</td>
						<td nowrap="nowrap">
							<form:input type="text" id="depreciacionAnual" name="depreciacionAnual" path="depreciacionAnual" size="15" tabindex="5" autocomplete="off"  maxlength="10"/>
							<a href="javaScript:" onClick="descripcionCampo('depreciacionAnual');">
								<img src="images/help-icon.gif" >
							</a>
						</td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap">
							<label for="tiempoAmortiMeses">Tiempo Amortizar en Meses:</label>
						</td>
						<td nowrap="nowrap">
							<form:input type="text" id="tiempoAmortiMeses" name="tiempoAmortiMeses" path="tiempoAmortiMeses" size="15" tabindex="6" autocomplete="off"  maxlength="2" onkeypress="return validaSoloNumero(event,this);"/>
							<a href="javaScript:" onClick="descripcionCampo('tiempoAmortiMeses');">
								<img src="images/help-icon.gif" >
							</a>
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="estatus">Estatus:</label>
						</td>
						<td nowrap="nowrap">
							<form:select id="estatus" name="estatus" path="estatus" tabindex="7">
								<form:option value="">SELECCIONAR</form:option>
								<form:option value="A">ACTIVO</form:option>
								<form:option value="I">INACTIVO</form:option>
							</form:select>
							<a href="javaScript:" onClick="descripcionCampo('estatus');">
								<img src="images/help-icon.gif" >
							</a>
						</td>
					</tr>
				</table>
				<table align="right">
					<tr>
						<td align="right">
							<input type="submit" id="agrega" name="agrega" class="submit" tabindex="8" value="Agregar" />
							<input type="submit" id="modifica" name="modifica" class="submit" tabindex="9" value="Modificar" />
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
						</td>
					</tr>
				</table>
			</fieldset>
		</form:form>
	</div>
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;overflow:">
		<div id="elementoLista"></div>
	</div>
	</body>
	<div id="mensaje" style="display: none;"></div>
	<div id="ContenedorAyuda" style="display: none;">
		<div id="elementoLista"/>
	</div>
</html>