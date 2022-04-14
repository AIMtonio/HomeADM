<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/usuarioServicios.js"></script>
<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
<script type="text/javascript" src="js/pld/reporteOpFraccionadas.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="opeInusualesBean" target="_blank">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Operaciones Fraccionadas</legend>
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
											<label for="fechaInicio">Periodo: </label>
										</td>
										<td>
											<form:input type="text" name="fechaInicio" id="fechaInicio" path="fechaInicio" autocomplete="off" size="12" tabindex="1" esCalendario="true"/>
											<form:input type="text" name="periodoDes" id="periodoDes" path="" autocomplete="off" disabled= "true" readOnly="true" size="45"/>
										</td>
									</tr>
									<tr id="trOperaciones">
										<td class="label" nowrap="nowrap">
											<label for="lblOperaciones">Operaciones de:</label>
										</td>
										<td nowrap="nowrap">
											<form:select id="operaciones" name="operaciones" path="operaciones" tabindex="2">
												<form:option value="">TODOS</form:option>
												<form:option value="C">CLIENTES</form:option>
												<form:option value="U">USUARIOS DE SERVICIOS</form:option>
											</form:select>
										</td>
									</tr>
									<tr id="trClientes">
										<td class="label"><label for="clienteID"><s:message code="safilocale.cliente"/>: </label></td>
										<td nowrap="nowrap">
											<form:input type="text" name="clienteID" id="clienteID" path="clienteID" autocomplete="off" size="12" tabindex="3"/> 
											<form:input type="text" name="nombresPersonaInv" id="nombresPersonaInv" path="nombresPersonaInv" autocomplete="off" size="50" disabled= "true" readOnly="true"/>
										</td>
									</tr>
									<tr id="trUsuarios">
										<td class="label">
											<label for="lblUsuarioServicioID">Usuario: </label>
										</td>
										<td nowrap="nowrap">
											<form:input id="usuarioServicioID" name="usuarioServicioID"  path="usuarioServicioID" autocomplete="off" size="12" tabindex="4" /> 
											<form:input type="text" id="nombreUsuario" name="nombreUsuario"  path="nombreUsuario" size="50" disabled= "true" readOnly="true" autocomplete="off"/>
										</td>
									</tr>
								</table>
							</fieldset>
						</td>
					</tr>
					<tr>
						<td>
							<table width="200px">
								<tr>
									<td class="label">
										<fieldset class="ui-widget ui-widget-content ui-corner-all">
											<legend>
												<label>Presentaci&oacute;n</label>
											</legend>
											<table style="width: 50%">
												<tr>
													<td><input type="radio" id="pdf" name="tipoReporte" value="1" tabindex="5" checked="checked" /></td>
													<td><label for="pdf"> PDF </label></td>
												</tr>
												<tr>
													<td><input type="radio" id="excel" name="tipoReporte" value="2" tabindex="6" /></td>
													<td><label for="excel"> Excel </label></td>
												</tr>
											</table>
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
										<input type="button" id="generar" name="generar" class="submit" tabindex="7" value="Generar" />
										<input type="hidden" id="alertSocio" name="alertSocio" value="<s:message code="safilocale.cliente"/>"/>
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