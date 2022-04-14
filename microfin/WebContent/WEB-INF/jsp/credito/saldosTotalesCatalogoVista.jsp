<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
<script type="text/javascript" src="dwr/interface/divisasServicio.js"></script>
<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script>
<script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/municipiosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/clasificCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/conveniosNominaServicio.js"></script>
<script type="text/javascript" src="dwr/interface/institucionNomServicio.js"></script>
<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
<script type="text/javascript" src="js/credito/repSaldosTotales.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditosBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Anal&iacute;tico Cartera</legend>
				<table border="0" width="600px">
					<tr>
						<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend>
									<label>P&aacute;rametros</label>
								</legend>
								<table border="0" width="560px">
									<tr>
										<td class="label">
											<label for="fechaInicio">Fecha: </label>
										</td>
										<td colspan="4">
											<input id="fechaInicio" name="fechaInicio" path="fechaInicio" size="11" tabindex="1" type="text" esCalendario="true" />
										</td>
									</tr>
									<tr>
										<td>
											<label for="sucursal">Sucursal:</label>
										</td>
										<td colspan="4" nowrap="nowrap">
											<input type="text" id="sucursal" name="sucursal" size="11" maxlength="3" tabindex="2" autocomplete="off" value="" />
											<input type="text" id="nombreSucursal" name="nombreSucursal" disabled="disabled" size="40" value="" />
										</td>
									</tr>
									<tr>
										<td>
											<label for="monedaID">Moneda:</label>
										</td>
										<td colspan="4">
											<input type="text" id="monedaID" name="monedaID" size="11" maxlength="11" tabindex="3" iniforma="false">
											<input type="text" id="descripcion" name="descripcion" size="40" disabled="disabled">
										</td>
									</tr>
									<tr>
										<td>
											<label for="producCreditoID">Producto de Cr&eacute;dito:</label>
										</td>
										<td colspan="4">
											<form:input type="text" id="producCreditoID" name="producCreditoID" path="producCreditoID" size="11" tabindex="4"/>
				 							<input type="text" id="nombreProd" name="nombreProd" disabled="disabled" size="40" />
										</td>
									</tr>
									<tr class="datosNominaE" >
										<td>
											<label for="institucionNominaID">Empresa N&oacute;mina:</label>
										</td>
										<td colspan="4">
											<form:input type="text" id="institucionNominaID" name="institucionNominaID" path="institucionNominaID" size="11" tabindex="5" value=""/>
				 							<input type="text" id="nombreInstit" name="nombreInstit"  disabled="disabled" size="40" value=""/>
										</td>
									</tr>
									<tr class="datosNominaC" >
										<td>
											<label for="convenioNominaID">No. Convenio:</label>
										</td>
										<td colspan="4">
											<form:input type="text" id="convenioNominaID" name="convenioNominaID" path="convenioNominaID" size="11" tabindex="5" value=""/>
											<input type="text" id="desConvenio" name="desConvenio"   disabled="disabled" size="40" value="" />
										</td>
									</tr>
									
									<tr>
										<td class="label">
											<label for="promotorID">Promotor:</label>
										</td>
										<td colspan="4">
											<form:input id="promotorID" name="promotorID" path="promotorID" tabindex="6" size="6" />
											<input type="text" id="nombrePromotorI" name="nombrePromotorI" size="39" readOnly="true" />
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="sexo"> G&eacute;nero:</label>
										</td>
										<td colspan="4">
											<form:select id="sexo" name="sexo" path="sexo" tabindex="7">
												<form:option value="0">TODOS</form:option>
												<form:option value="M">Masculino</form:option>
												<form:option value="F">Femenino</form:option>
											</form:select>
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="estado">Estado: </label>
										</td>
										<td colspan="4">
											<form:input id="estadoID" name="estadoID" path="estadoID" size="6" tabindex="8" />
											<input type="text" id="nombreEstado" name="nombreEstado" size="39" readOnly="true" />
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="municipio">Municipio: </label>
										</td>
										<td colspan="4">
											<form:input id="municipioID" name="municipioID" path="municipioID" size="6" tabindex="9" />
											<input type="text" id="nombreMuni" name="nombreMuni" size="39" readOnly="true" />
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="lblClasificacion">Clasificaci&oacute;n: </label>
										</td>
										<td colspan="4">
											<form:select id="clasificacion" name="clasificacion" path="clasificacion" tabindex="10">
												<form:option value="0">TODOS</form:option>
											</form:select>
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="diasatrasoinicial">Días de <br>Atraso Inicial:
											</label>
										</td>
										<td>
											<form:input id="atrasoInicial" name="atrasoInicial" path="atrasoInicial" size="6" tabindex="11" maxlength="5" />
										</td>
										<td class="separador" />
										<td class="label">
											<label for="diasatrasofinal">Días de <br>Atraso Final:
											</label>
										</td>
										<td>
											<form:input id="atrasoFinal" name="atrasoFinal" path="atrasoFinal" size="6" tabindex="12" maxlength="5" />
											<input type="hidden" id="nomSucurs" name="nomSucurs" />
										</td>
									</tr>
								</table>
							</fieldset>
						</td>
						<td>
							<table width="200px">
								<tr>
									<td class="label" style="position: absolute; top: 9%;">
										<fieldset class="ui-widget ui-widget-content ui-corner-all">
											<legend>
												<label>Presentaci&oacute;n</label>
											</legend>
											<input type="radio" id="excel" name="generaRpt" value="excel"> <label> Excel </label>
										</fieldset>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				<input type="hidden" id="tipoReporte" name="tipoReporte" class="submit" value=""/>
				<input type="hidden" id="tipoLista" name="tipoLista" value=""/>
					<input type="hidden" id="esNomina" name="esNomina" value="N"/>
				<input type="hidden" id="manejaConvenio" name="manejaConvenio" />
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td colspan="4" align="right" border='0'>
							<a id="ligaGenerar" href="RepSaldosTotalesCredito.htm" target="_blank">
							<input type="button" id="generar" name="generar" class="submit" tabIndex="48" value="Generar" />
							</a>
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
</body>
</html>