<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/diaFestivoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
<script type="text/javascript" src="js/utileria.js"></script>
<script type="text/javascript" src="js/pld/repPerfilTransaccional.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="perfilTransaccional" target="_blank">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">
					Perfil Transaccional del
					<s:message code="safilocale.cliente" />
				</legend>
				<table border="0" width="100%">
					<tr>
						<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend>
									<label>Par&aacute;metros</label>
								</legend>
								<table border="0" width="100%">
									<tr>
										<td class="label">
											<label for="sucursal">Sucursal:</label>
										</td>
										<td nowrap="nowrap">
											<input type="text" id="sucursalID" name="sucursalID" size="11" tabindex="1" autocomplete="off" value="" /> <input type="text" id="nombreSucursal" name="nombreSucursal" disabled="disabled" size="40" value="" />
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="sucursal"><s:message code="safilocale.cliente" />:</label>
										</td>
										<td nowrap="nowrap">
											<input type="text" id="clienteID" name="clienteID" size="11" tabindex="2" autocomplete="off" value="" /> <input type="text" id="nombreCompleto" name="" nombreCompleto"" disabled="disabled" size="40" value="" />
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="tipoPersona">Tipo de Persona:</label>
										</td>
										<td>
											<form:select id="tipoPersona" path="tipoPersona" name="tipoPersona" tabindex="3">
												<form:option value="">SELECCIONAR</form:option>
												<form:option value="T">TODAS</form:option>
												<form:option value="F">FÍSICA</form:option>
												<form:option value="M">MORAL</form:option>
												<form:option value="A">FÍSICA CON ACTIVIDAD EMPRESARIAL</form:option>
											</form:select>
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="fechaInicio">Fecha Inicio: </label>
										</td>
										<td>
											<form:input type="text" name="fechaInicio" id="fechaInicio" path="fechaInicio" autocomplete="off" size="12" tabindex="4" esCalendario="true" />
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="fechaFinal">Fecha Final: </label>
										</td>
										<td>
											<form:input type="text" name="fechaFinal" id="fechaFinal" path="fechaFinal" autocomplete="off" size="12" tabindex="5" esCalendario="true" />
										</td>
									</tr>
									<tr id="trOperaciones">
										<td class="label" nowrap="nowrap">
											<label for="lblOperaciones">Operaciones de:</label>
										</td>
										<td nowrap="nowrap">
											<form:select id="operaciones" name="operaciones" path="operaciones" tabindex="6">
												<form:option value="">TODOS</form:option>
												<form:option value="C">CLIENTES</form:option>
												<form:option value="U">USUARIOS DE SERVICIOS</form:option>
											</form:select>
										</td>
									</tr>
								</table>
							</fieldset>
						</td>
						<td>
							<table width="200px">
								<tr>
									<td class="label" style="position:absolute;top:6%;">
										<fieldset class="ui-widget ui-widget-content ui-corner-all">
											<legend><label>Presentaci&oacute;n</label></legend>
												<input type="radio" id="excel" name="tipoReporte" value="1" tabindex="7" checked="checked" />
												<label for="excel"> Excel </label>
										</fieldset>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				<table border="0" width="100%">
					<tr>
						<td colspan="5">
							<table align="right" border='0'>
								<tr>
									<td width="350px">&nbsp;</td>
									<td align="right">
										<input type="button" id="generar" name="generar" class="submit" tabindex="8" value="Generar" /> <input type="hidden" id="safilocale" name="safilocale" value="<s:message code="safilocale.cliente"/>" />
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</fieldset>
		</form:form>
	</div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
</body>
</html>