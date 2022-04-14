<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/carCreditoSuspendidoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/carCreditoSuspendidoServicio.js"></script>
		<script type="text/javascript" src="js/credito/creditoSuspendidosVista.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="carCreditoSuspendidoBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Suspensi&oacute;n por Defunci&oacute;n</legend>
						<table border="0" >
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="lbCreditoID">Cr&eacute;dito:</label>
								</td>
								<td nowrap="nowrap">
									<input type="text" id="creditoID" name="creditoID" size="17"  tabindex="1" autocomplete="off" />
								</td>

								<td class="label" nowrap="nowrap">
									<label for="lbProductoCreditoID">Producto Cr&eacute;dito:</label>
								</td>
								<td nowrap="nowrap">
									<input type="text" id="productoCreditoID" name="productoCreditoID" size="10"  tabindex="2" autocomplete="off" readOnly="true"/>
									<input type="text" id="descProducto" name="descProducto" size="40" tabindex="3" autocomplete="off" onBlur="ponerMayusculas(this)" readOnly="true"/>
								</td>
							</tr>

							<tr>
								<td class="label" nowrap="nowrap">
									<label for="lbClienteID">Cliente:</label>
								</td>
								<td nowrap="nowrap">
									<input type="text" id="clienteID" name="clienteID" size="10"  tabindex="4" autocomplete="off" readOnly="true"/>
									<input type="text" id="nombreCliente" name="nombreCliente" size="45" tabindex="5" autocomplete="off" onBlur="ponerMayusculas(this)" readOnly="true"/>
								</td>

								<td class="label" nowrap="nowrap">
									<label for="lbEstatus">Estatus:</label>
								</td>
								<td nowrap="nowrap">
									<input type="text" id="estatus" name="estatus" size="20" tabindex="6" autocomplete="off" onBlur="ponerMayusculas(this)" readOnly="true"/>
								</td>
							</tr>

							<tr>
								<td class="label" nowrap="nowrap">
									<label for="lbMontoCredito">Monto Otorgado:</label>
								</td>
								<td nowrap="nowrap">
									<input type="text" id="montoCredito" name="montoCredito"  size="15" tabindex="15" autocomplete="off" readOnly="true" style="text-align: right" esMoneda="true"/>
								</td>

								<td class="label" nowrap="nowrap">
									<label for="lbConvenioNominaID">Convenio:</label>
								</td>
								<td nowrap="nowrap">
									<input type="text" id="convenioNominaID" name="convenioNominaID"  size="10" tabindex="7" autocomplete="off" readOnly="true"/>
									<input type="text" id="descConvenioNomina" name="descConvenioNomina"  size="40" tabindex="8" autocomplete="off" onBlur="ponerMayusculas(this)" readOnly="true"/>
								</td>
							</tr>

							<tr>
								<td class="label" nowrap="nowrap">
									<label for="lbFechaInicio">Fecha Inicio:</label>
								</td>
								<td nowrap="nowrap">
									<input type="text" id="fechaInicio" name="fechaInicio"  size="15" tabindex="17" autocomplete="off" readOnly="true"/>
								</td>

								<td class="label" nowrap="nowrap">
									<label for="lbFechaVencimiento">Fecha Vencimiento:</label>
								</td>
								<td nowrap="nowrap">
									<input type="text" id="fechaVencimiento" name="fechaVencimiento"  size="15" tabindex="17" autocomplete="off" readOnly="true"/>
								</td>
							</tr>

							<tr>
								<td class="label" nowrap="nowrap">
									<label for="lbTotalAdeudo">Total Adeudo:</label>
								</td>
								<td nowrap="nowrap">
									<input type="text" id="totalAdeudo" name="totalAdeudo"  size="15" tabindex="15" autocomplete="off" readOnly="true" style="text-align: right" esMoneda="true"/>
								</td>

								<td class="label" nowrap="nowrap">
									<label for="lbDiaAtraso">Dia de Atraso:</label>
								</td>
								<td nowrap="nowrap">
									<input type="text" id="diaAtraso" name="diaAtraso"  size="10" tabindex="7" autocomplete="off" readOnly="true"/>
								</td>
							</tr>
							
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="lbFechaSuspension">Fecha de Suspensi&oacute;n:</label>
								</td>
								<td nowrap="nowrap">
									<input type="text" id="fechaSuspension" name="fechaSuspension"  size="15" tabindex="17" autocomplete="off" readOnly="true"/>
								</td>
							</tr>
						</table><br>

						<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<legend>Detalle del Adeudo</legend>
							<table border="0">
								<tr>
									<td class="label" nowrap="nowrap">
										<label for="lbTotalSalCapital">Saldo Capital:</label>
									</td>
									<td nowrap="nowrap">
										<input type="text" id="totalSalCapital" name="totalSalCapital"  size="15" tabindex="15" autocomplete="off" readOnly="true" style="text-align: right" esMoneda="true"/>
									</td>

									<td class="label" nowrap="nowrap">
										<label for="lbTotalSalInteres">Saldo Inter&eacute;s:</label>
									</td>
									<td nowrap="nowrap">
										<input type="text" id="totalSalInteres" name="totalSalInteres" size="15" tabindex="15" autocomplete="off" readOnly="true" style="text-align: right" esMoneda="true"/>
									</td>
								</tr>

								<tr>
									<td class="label" nowrap="nowrap">
										<label for="lbTotalSalMoratorio">Saldo Moratorios:</label>
									</td>
									<td nowrap="nowrap">
										<input type="text" id="totalSalMoratorio" name="totalSalMoratorio"  size="15" tabindex="15" autocomplete="off" readOnly="true" style="text-align: right" esMoneda="true"/>
									</td>

									<td class="label" nowrap="nowrap">
										<label for="lbTotalSalComisiones">Saldo Comisiones:</label>
									</td>
									<td nowrap="nowrap">
										<input type="text" id="totalSalComisiones" name="totalSalComisiones" size="15" tabindex="15" autocomplete="off" readOnly="true" style="text-align: right" esMoneda="true"/>
									</td>
								</tr>
							</table >
						</fieldset><br>

						<table border="0">
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="lbFechaDefuncion">Fecha Defunci&oacute;n:</label>
								</td>
								<td nowrap="nowrap">
									<input type="text" id="fechaDefuncion" name="fechaDefuncion"  size="20" tabindex="17" autocomplete="off" esCalendario="true"/>
								</td>

								<td class="label" nowrap="nowrap">
									<label for="lbFolioActa">Folio Acta:</label>
								</td>
								<td nowrap="nowrap">
									<input type="text" id="folioActa" name="folioActa" maxlength="30" size="30" tabindex="6" autocomplete="off" onBlur="ponerMayusculas(this)"/>
								</td>
								
								<td class="label" nowrap="nowrap">
									<label for="lbObservDefuncion">Observaci&oacute;n: </label>
								</td>
								<td nowrap="nowrap" colspan="3">
									<textarea id="observDefuncion" maxlength="250" name="observDefuncion" cols="35" rows="3" tabindex="6" onBlur=" ponerMayusculas(this)"></textarea>
								</td>
							</tr>
						</table ><br>

						<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">
							<tr>
								<td align="right">
									<input type="submit" id="procesar" name="procesar" class="submit" value="Procesar"  tabindex="13"/>
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
