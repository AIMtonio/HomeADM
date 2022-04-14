<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/nomDetCapacidadPagoSolServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/nomCapacidadPagoSolServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/prospectosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/solicitudCredServicio.js"></script>
		<script type="text/javascript" src="js/nomina/datosSocioEconomicoCapacidadPagoSol.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="nomCapacidadPagoSolBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Alta de Capacidad de Pago</legend>
						<table border="0" >
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="lbSolicitudCreditoID">No. Solicitud:</label>
								</td>
								<td nowrap="nowrap">
									<input type="text" id="solicitudCreditoID" name="solicitudCreditoID" size="13"  tabindex="1" autocomplete="off" />
								</td>

								<td class="label" nowrap="nowrap">
									<label for="lbProspectoID">Prospecto:</label>
								</td>
								<td nowrap="nowrap">
									<input type="text" id="prospectoID" name="prospectoID"  size="10" tabindex="2" autocomplete="off" readOnly="true"/>
									<input type="text" id="descProspecto" name="descProspecto"  size="50" tabindex="3" autocomplete="off" onBlur="ponerMayusculas(this)" readOnly="true"/>
								</td>
							</tr>

							<tr>
								<td class="label" nowrap="nowrap">
									<label for="lbClienteID">Cliente:</label>
								</td>
								<td nowrap="nowrap">
									<input type="text" id="clienteID" name="clienteID"  size="10" tabindex="4" autocomplete="off" readOnly="true"/>
									<input type="text" id="nombreCliente" name="nombreCliente"  size="50" tabindex="5" autocomplete="off" onBlur="ponerMayusculas(this)" readOnly="true"/>
								</td>

								<td class="label" nowrap="nowrap">
									<label for="lbProductoCreditoID">Producto de Cr&eacute;dito:</label>
								</td>
								<td nowrap="nowrap">
									<input type="text" id="productoCreditoID" name="productoCreditoID"  size="10" tabindex="6" autocomplete="off" readOnly="true"/>
									<input type="text" id="descProductoCredito" name="descProductoCredito"  size="50" tabindex="7" autocomplete="off" onBlur="ponerMayusculas(this)" readOnly="true"/>
								</td>
							</tr>

							<tr>
								<td class="label" nowrap="nowrap">
									<label for="lbConvenioNominaID">Convenio N&oacute;mina:</label>
								</td>
								<td nowrap="nowrap">
									<input type="text" id="convenioNominaID" name="convenioNominaID"  size="10" tabindex="8" autocomplete="off" readOnly="true"/>
									<input type="text" id="descConvenioNomina" name="descConvenioNomina"  size="50" tabindex="9" autocomplete="off" onBlur="ponerMayusculas(this)" readOnly="true"/>
								</td>

								<td class="label" nowrap="nowrap">
									<label for="lbInstitNominaID">Empresa  N&oacute;mina:</label>
								</td>
								<td nowrap="nowrap">
									<input type="text" id="institNominaID" name="institNominaID"  size="10" tabindex="10" autocomplete="off" readOnly="true"/>
									<input type="text" id="nombreInstit" name="nombreInstit"  size="50" tabindex="11" autocomplete="off" onBlur="ponerMayusculas(this)" readOnly="true"/>
								</td>
							</tr>

							<tr>
								<td class="label" nowrap="nowrap">
									<label for="lbNoEmpleado">N&uacute;mero de Empleado:</label>
								</td>
								<td nowrap="nowrap">
									<input type="text" id="noEmpleado" name="noEmpleado"  size="15" tabindex="12" autocomplete="off" readOnly="true"/>
								</td>

								<td class="label" nowrap="nowrap">
									<label for="lbTipoCredito">Tipo Cr&eacute;dito:</label>
								</td>
								<td nowrap="nowrap">
									<input type="hidden" id="tipoCreditoID" name="tipoCreditoID"  size="15" tabindex="13" autocomplete="off" readOnly="true"/>
									<input type="text" id="tipoCredito" name="tipoCredito"  size="15" tabindex="13" autocomplete="off" readOnly="true"/>
								</td>
							</tr>

							<tr>
								<td class="label" nowrap="nowrap">
									<label for="lbTipoEmpleado">Tipo Empleado:</label>
								</td>
								<td nowrap="nowrap">
									<input type="text" id="tipoEmpleado" name="tipoEmpleado"  size="15" tabindex="14" autocomplete="off" readOnly="true"/>
								</td>

								<td class="label" nowrap="nowrap">
									<label for="lbMontoSolici">Monto Solicitado:</label>
								</td>
								<td nowrap="nowrap">
									<input type="text" id="montoSolici" name="montoSolici"  size="15" tabindex="15" autocomplete="off" readOnly="true" style="text-align: right" esMoneda="true"/>
								</td>
							</tr>

							<tr>
								<td class="label" nowrap="nowrap">
									<label for="lbSucursalID">Sucursal Registro:</label>
								</td>
								<td nowrap="nowrap">
									<input type="text" id="descSucursal" name="descSucursal"  size="20" tabindex="16" autocomplete="off" readOnly="true"/>
								</td>

								<td class="label" nowrap="nowrap">
									<label for="lbFechaRegistro">Fecha Registro:</label>
								</td>
								<td nowrap="nowrap">
									<input type="text" id="fechaRegistro" name="fechaRegistro"  size="20" tabindex="17" autocomplete="off" readOnly="true"/>
								</td>
							</tr>
						</table>

						<br>
						<br>

						<table border="0" >
							<tr >
								<div id="gridClasifClavePresupConv" style="display: none; width: 1150px;" ></div>
							</tr>
						</table>
						<br>
						<br>

						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td align="left">
									<input type="submit" id="calculrCapc" name="calculrCapc" class="submit" value="Calcular Capacidad"  tabindex="21"/>
									<label for="" style="color: black; font-weight: bold;" > $ </label>
									<input type="text" id="valorCapacidadPago" size="20" name="valorCapacidadPago" value="" style="text-align: right; height:18px" readonly="true" />
									<input type="hidden" id="listaClasifClavPresup" name="listaClasifClavPresup" size="30" value=""/>
								</td>
								<td align="right">
									<input type="submit" id="graba" name="graba" class="submit" value="Grabar"  tabindex="22"/>
									<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar"  tabindex="23"/>
									<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="tipoTransaccion"/>
									<input type="hidden" id="nomCapacidadPagoSolID" name="nomCapacidadPagoSolID" value="0"/>
									<input type="hidden" id="porcentajeCapacidad" name="porcentajeCapacidad" value="0"/>
									<input type="hidden" id="estatus" name="estatus" value=""/>
									<input type="hidden" id="montoResguardoConvenio" name="montoResguardoConvenio" value="0"/>
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
