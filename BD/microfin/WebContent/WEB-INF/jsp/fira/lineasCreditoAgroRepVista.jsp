<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/lineasCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
		<script type="text/javascript" src="js/fira/lineasCreditoAgroRep.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="lineasCreditoAgro">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">L&iacute;neas de Cr&eacute;dito Agro</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="600px">
						<tr>
							<td>
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend><label>Par&aacute;metros</label></legend>
									<table  border="0"  width="560px">
										<tr>
											<td class="label">
												<label for="lblFechaInicio">Fecha de Inicio: </label>
											</td>
											<td>
												<input id="fechaInicio" name="fechaInicio" size="12" tabindex="1" type="text"  esCalendario="true" />
											</td>
										</tr>
										<tr>
											<td>
												<label for="lblFechaFin">Fecha de Fin: </label>
											</td>
											<td>
												<input id="fechaVencimiento" name="fechaVencimiento" size="12" tabindex="2" type="text" esCalendario="true"/>
											</td>
										</tr>
										<tr>
											<td class="label">
												<label for="lbllineaCreditoID">L&iacute;nea de Cr&eacute;dito: </label>
											</td>
											<td>
												<input id="lineaCreditoID" name="lineaCreditoID"  size="12" tabindex="3" numMax ="12" />
											</td>
										</tr>
										<tr>
											<td class="label">
												<label for="lblClienteID"><s:message code="safilocale.cliente"/>: </label>
											</td>
											<td>
												<input id="clienteID" name="clienteID" size="12" tabindex="4" numMax ="10" />
												<input type="text" id="nombreCliente" name="nombreCliente"size="50" readOnly= "true" />
											</td>
										</tr>
										<tr>
											<td class="label">
												<label for="lblproductoCreditoID">Producto Cr&eacute;dito:</label>
											</td>
											<td>
												<input id="productoCreditoID" name="productoCreditoID" size="12" tabindex="6"/>
												<input type="text" id="nombreProducto" name="nombreProducto" size="50" readOnly="true" />
											</td>
										</tr>
										<tr>
											<td class="label">
												<label for="lblSucursal">Sucursal: </label>
											</td>
											<td>
												<input id="sucursalID" name="sucursalID" size="12" tabindex="7" />
												<input type="text" id="nombreSucursal" name="nombreSucursal" size="50"  readOnly="true"/>
											</td>
										</tr>
										<tr>
											<td class="label">
												<label for="lblEstatus"> Estatus:</label>
											</td>
											<td>
												<form:select id="estatus" name="estatus" path="estatus" tabindex="8">
													<form:option value="0">TODOS</form:option>
													<form:option value="A">AUTORIZADA</form:option>
													<form:option value="B">BLOQUEADA</form:option>
													<form:option value="C">CANCELADA</form:option>
													<form:option value="R">RECHAZADA</form:option>
													<form:option value="S">AUTOMÁTICA</form:option>
													<form:option value="N">NO AUTOMÁTICA </form:option>
													<form:option value="E">VENCIDA</form:option>
												</form:select>
											</td>
										</tr>
									</table>
								</fieldset>
							</td>
							<td>
								<table width="200px">
									<tr>
										<td class="label" style="position:absolute;top:8%;">
											<fieldset class="ui-widget ui-widget-content ui-corner-all">
												<legend><label>Presentaci&oacute;n</label></legend>
												<input type="radio" id="pdf" name="generaRpt" value="pdf" />
												<label> PDF </label>
												<br>
												<input type="radio" id="excel" name="generaRpt" value="excel">
												<label> Excel </label>
											</fieldset>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td colspan="4">
								<table align="right" border='0'>
									<tr>
										<td align="right">
											<a id="ligaGenerar" href="lineasCreditoRep.htm" target="_blank" >
												<input type="button" id="generar" name="generar" class="submit" tabIndex = "9" value="Generar" />
											</a>
										</td>
									</tr>
								</table>
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