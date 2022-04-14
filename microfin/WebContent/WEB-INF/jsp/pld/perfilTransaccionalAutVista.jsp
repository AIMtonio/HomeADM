<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/perfilTransaccionalServicio.js"></script>
<script type="text/javascript" src="js/pld/perfilTransaccionalAut.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="perfilTransaccional">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Autorizaci&oacute;n del Perfil Transaccional</legend>
				<table style="width: 100%">
					<tr>
						<td class="label">
							<label for="sucursalID">Sucursal:</label>
						</td>
						<td nowrap="nowrap">
							<input type="text" id="sucursalID" name="sucursalID" size="11" tabindex="1" autocomplete="off" value="" />
							<input type="text" id="nombreSucursal" name="nombreSucursal" disabled="disabled" size="40" value="" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="clienteID"><s:message code="safilocale.cliente" />:</label>
						</td>
						<td nowrap="nowrap">
							<input type="text" id="clienteID" name="clienteID" size="11" tabindex="2" autocomplete="off" value="" />
							<input type="text" id="nombreCliente" name="nombreCliente" disabled="disabled" size="50" value=""/>
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="sucursalID">Fecha Inicio:</label>
						</td>
						<td nowrap="nowrap">
							<input type="text" id="fechaInicio" name="fechaInicio" size="15" tabindex="3" autocomplete="off" esCalendario="true" value="" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="clienteID">Fecha Fin:</label>
						</td>
						<td nowrap="nowrap">
							<input type="text" id="fechaFin" name="fechaFin" size="15" tabindex="4" autocomplete="off" esCalendario="true" value="" />
						</td>
					</tr>
					<tr>
						<td colspan="5" style="text-align: right;">
							<input type="button" id="consultar" name="consultar" class="submit" value="Consultar" tabindex="5" />
						</td>
					</tr>
					<tr>
						<td colspan="5">
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend class="ui-widget ui-widget-header ui-corner-all">Transacción Real</legend>
								<div id="gridDetalle" style="width: 100%"></div>
							</fieldset>
						</td>
					</tr>
					<tr>
						<td colspan="5" style="text-align: right;">
							<input type="button" id="exportarExcel" name="exportarExcel" class="submit" value="Exportar Excel" tabindex="6" />
							<input type="button" id="procesar" name="procesar" class="submit" value="Procesar" tabindex="7" />
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="" />
							<input type="hidden" id="detalles" name="detalles" value=""/>
						</td>
					</tr>
				</table>
			</fieldset>
		</form:form>
	</div>
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
	<div id="mensaje" style="display: none;"></div>
	<input type="hidden" id="socioClienteAlert" name="socioClienteAlert" value="<s:message code="safilocale.cliente"/>" />
</body>
</html>