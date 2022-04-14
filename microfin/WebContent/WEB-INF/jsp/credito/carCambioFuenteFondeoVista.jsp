<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/creditoFondeoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/fondeoServicio.js"></script>  
		<script type="text/javascript" src="dwr/interface/lineaFonServicio.js"></script>
		<script type="text/javascript" src="js/credito/carCambioFuenteFondeo.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="carCambioFondeoBitBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Cambio de Fuente de Fondeo</legend>
						<table border="0" width="100%" >
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="creditoID">Cr&eacute;dito:</label>
								</td>
								<td nowrap="nowrap">
									<input type="text" id="creditoID" name="creditoID" size="15" autocomplete="off" tabindex="1"/>
								</td>

								<td class="label" nowrap="nowrap">
									<label for="clienteID">Cliente:</label>
								</td>
								<td nowrap="nowrap">
									<input type="text" id="clienteID" name="clienteID" size="12" readOnly="true" disabled="true" tabindex="2"/>
									<input type="text" id="nombreCliente" name="nombreCliente" size="45" readOnly="true" disabled="true" tabindex="3"/>
								</td>
							</tr>

							<tr>
								<td class="label" nowrap="nowrap">
									<label for="cuentaID">Cuenta: </label>
								</td>
								<td nowrap="nowrap">
									<input type="text" id="cuentaID" name="cuentaID" size="15" readOnly="true" disabled="true" tabindex="4"/>
								</td>

								<td class="label" nowrap="nowrap">
									<label for="lblestatus">Estatus:</label>
								</td>
								<td nowrap="nowrap">
									<input type="text" id="estatus" name="estatus" size="15" readOnly="true" disabled="true" tabindex="5"/>
								</td>
							</tr>

							<tr>
								<td class="label" nowrap="nowrap">
									<label for="producCreditoID">Producto Cr&eacute;dito: </label>
								</td>
								<td nowrap="nowrap">
									<input type="text" id="producCreditoID" name="producCreditoID" size="12" readOnly="true" disabled="true" tabindex="6"/>
									<input type="text" id="descripProducto" name="descripProducto" size="45" readOnly="true" disabled="true" tabindex="7"/>
								</td>

								<td class="label" nowrap="nowrap">
									<label for="fuenteF">Fondeador: </label>
									</td>
								<td nowrap="nowrap">
									<input type="text" id="institFondeoIDAnt" name="institFondeoIDAnt" size="12" readonly="true" disabled="true" tabindex="8"/>
									<input type="text" id="nombreFondeoAnt" name="nombreFondeoAnt" size="35" readonly="true" disabled="true" tabindex="9"/>
								</td>
							</tr>

							<tr>
								<td class="label" nowrap="nowrap">
									<label for="lblLineaFondeo">L&iacute;nea de Fondeo: </label>
								</td>
								<td nowrap="nowrap">
									<input type="text" id="lineaFondeoAnt" name="lineaFondeoAnt"  size="12" readonly="true" disabled="true" tabindex="10"/>
									<input type="text" id="descripLineaFonAnt" name="descripLineaFonAnt" size="35" readonly="true" disabled="true" tabindex="11"/>
								</td>

								<td class="label" nowrap="nowrap">
									<label for="lblFolioPasivo">Folio Pasivo: </label>
								</td>
								<td nowrap="nowrap">
									<input type="text" id="folioPasivoAnt" name="folioPasivoAnt"  size="12" readonly="true" disabled="true" tabindex="12"/>
									<input type="text" id="desFolioPasivoAnt" name="desFolioPasivoAnt" size="35" readonly="true" disabled="true" tabindex="13"/>
								</td>
							</tr>
						</table>

						<br>
						<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<legend>Fuente Fondeo</legend>
							<div>
								<table width="100%">
									<tr>
										<td class="label" nowrap="nowrap">
											<label for="FuenteF">Fondeador: </label>
										</td>
										<td nowrap="nowrap">
											<input type="text" id="institutFondActID" name="institutFondActID" size="12" maxlength="12" autocomplete="off" tabindex="14"/>
											<input type="text" id="nombreFondeoAct" name="nombreFondeoAct" size="35" readonly="true" disabled="true" tabindex="15"/>
										</td>

										<td class="label" nowrap="nowrap">
											<label for="lblLineaFondeo">L&iacute;nea de Fondeo: </label>
										</td>
										<td nowrap="nowrap">
											<input type="text" id="lineaFondeoAct" name="lineaFondeoAct" size="12"  autocomplete="off" tabindex="16"/>
											<input type="text" id="descripLineaAct" name="descripLineaAct" size="45" disabled="true" tabindex="17"/>
										</td>
									</tr>
									<tr>
										<td class="label" nowrap="nowrap">
											<label for="lblFolioPasivo">Folio Pasivo: </label>
										</td>
										<td nowrap="nowrap">
											<input type="text" id="creditoFondeoActID" name="creditoFondeoActID" size="12" autocomplete="off" tabindex="18"/>
											<input type="text" id="desFolioPasivoAct" name="desFolioPasivoAct" size="35" readonly="true" disabled="true" tabindex="19"/>
										</td>
									</tr>
								</table>
							</div>
						</fieldset>
						<br>
						<br>

						<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">
							<tr>
								<td align="right">
									<input type="submit" id="cambiar" name="cambiar" class="submit" value="Cambiar"  tabindex="5"/>
									<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="tipoTransaccion"/>
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
		<div id="mensaje" style="display: none;"> </div>
		<div id="ContenedorAyuda" style="display: none;">
			<div id="elementoLista"/>
		</div>
	</body>
</html>
