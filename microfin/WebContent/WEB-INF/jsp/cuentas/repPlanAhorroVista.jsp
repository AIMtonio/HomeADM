<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/tiposPlanAhorroServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
		<script type="text/javascript" src="js/cuentas/repMovsPlanAhorro.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="foliosPlanAhorroBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget-header ui-corner-all">Movimientos de Plan de Ahorro</legend>
					<table border="0" width="100%">
					<tr>
						<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend><label>Par&aacute;metros</label></legend>
								<table>
									<tr>
										<td class="label">
											<label for="planID">Plan de Ahorro: </label>
										</td>
										<td>
											<form:select id="planID" name="planID" path="planID" tabindex="1">
												<form:option value="0">TODOS</form:option>
											</form:select>
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="sucursalID">Sucursal: </label>
										</td>
										<td>
											<form:input type="text" id="sucursal" name="sucursal" path="sucursal" size="10" tabindex="2" />
											<input type="text" id="nombreSucur" name="nombreSucur" size="35" tabindex="3" />
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="clienteID"><s:message code="safilocale.cliente"/>: </label>
										</td>
										<td>
											<form:input type="text" id="clienteID" name="clienteID" path="clienteID" size="10" tabindex="4" />
											<input type="text" id="nombreCliente" name="nombreClinombreCliente" size="35" tabindex="5" />
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="estatus">Estatus: </label>
										</td>
										<td>
											<form:select id="estatus" name="estatus" path="estatus" tabindex="6">
												<form:option value="">TODOS</form:option>
												<form:option value="A">ACTIVOS</form:option>
												<form:option value="C">CANCELADOS</form:option>
											</form:select>
										</td>
									</tr>
								</table>
							</fieldset>
							<table align="left">
								<tr><td class="label">
									<fieldset class="ui-widget ui-widget-content ui-corner-all">
										<legend><label>Presentaci&oacute;n</label></legend>
										<input type="radio" id="pdf" name="tipoReporte" value="1" tabindex="7"/>
										<label> PDF </label>
										<br>
										<input type="radio" id="excel" name="tipoReporte" value="2" tabindex="8"/>
										<label> EXCEL </label>
									</fieldset>
								</td></tr>
							</table>
						</td>
					</tr>
					<tr>
						<td>
							<table align="right">
								<tr>
									<td><input type="button" id="generar" name="generar" class="submit" tabIndex="9" value="Generar" /></td>
								</tr>
							</table>
						</td>
					</tr>
					</table>
				</fieldset>
			</form:form>
		</div>
		<div id="cargando" style="display: none;"></div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"/> </div>
		</div>
	</body>
	<div id="mensaje" style="display: none;" />
</html>