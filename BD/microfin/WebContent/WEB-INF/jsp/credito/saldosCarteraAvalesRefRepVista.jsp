<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/municipiosServicio.js"></script>
	<script type="text/javascript" src="js/credito/repSaldosCarteraAvaRef.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST"
			commandName="creditosBean">

			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Saldos Cartera, Avales y Referencias</legend>

				<table border="0" width="600px">
					<tr>
						<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend>
									<label>Par&aacute;metros</label>
								</legend>
								<table border="0" width="560px">
									<tr>
										<td class="label"><label for="fechaInicio">Fecha: </label></td>
										<td colspan="4"><input id="fechaInicio" name="fechaInicio" path="fechaInicio" size="12" tabindex="1"
											type="text" esCalendario="true" /></td>
									</tr>
									<tr>
										<td class="label"><label for="sucursalID">Sucursal: </label></td>
										<td colspan="4">
											<form:input type="text" name="sucursalID" id="sucursalID" path="" autocomplete="off" size="6" tabindex="2" />
											<input type="text" 	name="nombreSucursal" id="nombreSucursal" autocomplete="off" size="39" disabled="true" />
										</td>
									</tr>
									<tr>
										<td><label for="monedaID">Moneda:</label></td>
										<td colspan="4">
											<select name="monedaID" id="monedaID" path="monedaID" tabindex="3" style="width:80%;">
													<option value="0">Todas</option>
											</select>
										</td>
									</tr>
									<tr>
										<td><label for="producCreditoID">Producto de Cr&eacute;dito:</label></td>
										<td colspan="4">
							         		<form:input id="producCreditoID" name="producCreditoID" path="producCreditoID" size="6" tabindex="4" />
							         		<input type= "text" id="descripProducto" name="descripProducto" size="39" type="text" disabled="true"/>
										</td>
									</tr>
									<tr>
										<td class="label"><label for="promotorID">Promotor:</label></td>
										<td colspan="4">
											<form:input id="promotorID" name="promotorID" path="promotorID" tabindex="5" size="6" />
											<input type="text" id="nombrePromotorI" name="nombrePromotorI" size="39" disabled="true"
											readOnly="true" />
										</td>
									</tr>
									<tr>
										<td class="label"><label for="sexo">
												G&eacute;nero:</label></td>
										<td colspan="4">
											<form:select id="sexo" name="sexo" path="sexo" tabindex="6">
												<form:option value="0">TODOS</form:option>
												<form:option value="M">MASCULINO</form:option>
												<form:option value="F">FEMENINO</form:option>
											</form:select>
										</td>
									</tr>
									<tr>
										<td class="label"><label for="estadoID">Estado: </label></td>
										<td colspan="4">
											<form:input id="estadoID" name="estadoID" path="estadoID" size="6" tabindex="7" />
											<input type="text" id="nombreEstado" name="nombreEstado" size="39"
											disabled="true" readOnly="true" /></td>
									</tr>
									<tr>
										<td class="label"><label for="municipioID">Municipio:</label></td>
										<td colspan="4">
											<form:input id="municipioID" name="municipioID" path="municipioID" size="6" tabindex="8" />
											<input type="text" id="nombreMuni" name="nombreMuni"
											size="39" disabled="true" readOnly="true" />
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="atrasoInicial">D&iacute;as de <br>Atraso Inicial: </label>
										</td>
										<td>
											<form:input id="atrasoInicial" name="atrasoInicial"
												path="atrasoInicial" size="6" tabindex="9" maxlength="5" onkeypress="return validaSoloNumero(event);"/>
										</td>
										<td class="separador" />
										<td class="label">
											<label for="atrasoFinal">D&iacute;as de <br>Atraso Final: </label>
										</td>
										<td>
											<form:input id="atrasoFinal" name="atrasoFinal"
												path="atrasoFinal" size="6" tabindex="10" maxlength="5" onkeypress="return validaSoloNumero(event);"/>
										</td>
									</tr>
								</table>
							</fieldset>
						</td>
						<td>
							<table width="200px">
								<tr class="label" style="position: absolute; top: 8%;">
									<td>
										<fieldset class="ui-widget ui-widget-content ui-corner-all">
											<legend>
												<label>Presentaci&oacute;n</label>
											</legend>
											<input type="radio" id="excel" name="generaRpt" value="excel" tabindex="11">
											<label>Excel </label>
										</fieldset>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan="2" align="right">
							<input type="button" id="generar" name="generar" class="submit" tabIndex="50" value="Generar" />
							<input type="hidden" id="tipoReporte" name="tipoReporte" class="submit" />
							<input type="hidden" id="tipoLista" name="tipoLista" />
						</td>
					</tr>
				</table>
			</fieldset>
		</form:form>
	</div>
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista" />
	</div>
</body>
<div id="mensaje" style="display: none;" />
</html>