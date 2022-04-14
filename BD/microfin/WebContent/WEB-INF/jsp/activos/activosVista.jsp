<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/tiposActivosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/activosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/proveedoresServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/centroServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cuentasContablesServicio.js"></script>
		<script type="text/javascript" src="js/activos/activos.js"></script>
	</head>
	<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="activosBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Activos</legend>
				<table>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="activoID">N&uacute;mero:</label>
						</td>
						<td nowrap="nowrap">
							<form:input type="text" id="activoID" name="activoID" path="activoID" size="10" tabindex="1" autocomplete="off"/>
						</td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap">
							<label for="tipoActivoID">Tipo de Activo:</label>
						</td>
						<td nowrap="nowrap">
							<form:input type="text" id="tipoActivoID" name="tipoActivoID" path="tipoActivoID" size="15" tabindex="2"  autocomplete="off"/>
							<input type="text" id="descripcionActivo" name="descripcionActivo"  size="45" disabled="true" readonly="true">
							<input type="hidden" id="clasificaActivoID" name="clasificaActivoID" size="5" disabled="true" readOnly="true"/>
							<input type="hidden" id="tiempoAmortiMeses" name="tiempoAmortiMeses" size="15" disabled="true" readOnly="true"/>
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="numeroConsecutivo">N&uacute;mero Consecutivo:</label>
						</td>
						<td nowrap="nowrap">
							<input type="text" id="numeroConsecutivo" name="numeroConsecutivo" size="15" disabled="true" readonly="true" />
						</td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap">
							<label for="descripcion">Descripci&oacute;n:</label>
						</td>
						<td nowrap="nowrap">
							<form:textarea id="descripcion" name="descripcion" path="descripcion" COLS="48" ROWS="2" tabindex="3"  onBlur="ponerMayusculas(this); limpiarCajaTexto(this.id);" maxlength="300"/>
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="fechaAdquisicion">Fecha de Adquisición:</label>
						</td>
						<td nowrap="nowrap">
							<form:input type="text" id="fechaAdquisicion" name= "fechaAdquisicion" path="fechaAdquisicion" size="15" maxlength="10"  autocomplete="off" tabindex="4"/>
						</td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap">
							<label for="proveedorID">Proveedor:</label>
						</td>
						<td nowrap="nowrap">
							<form:input type="text" id="proveedorID" name="proveedorID" path="proveedorID" size="10" tabindex="5" autocomplete="off" maxlength="30"/>
							<input type="text" id="nombreProveedor" name="nombreProveedor" size="40" disabled="true" readOnly="true"/>
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="numFactura">No. Factura:</label>
						</td>
						<td nowrap="nowrap">
							<form:input type="text" id="numFactura" name="numFactura" path="numFactura" maxlength="50" size="15" tabindex="6" autocomplete="off"/>
						</td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap">
							<label for="numSerie">No. Serie:</label>
						</td>
						<td nowrap="nowrap">
							<form:input type="text" id="numSerie" name="numSerie" path="numSerie" size="15" tabindex="7" autocomplete="off" maxlength = "100"/>
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="moi">Monto Original Inversi&oacute;n(MOI):</label>
						</td>
						<td>
							<form:input type="text" id="moi" name="moi" path="moi" size="15" tabindex="8" maxlength = "18" autocomplete="off" esMoneda="true" style="text-align: right" onkeypress="return validaSoloNumero(event,this);" />
						</td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap">
							<label for="depreciadoAcumulado">Depreciado Acumulado:</label>
						</td>
						<td>
							<form:input type="text" id="depreciadoAcumulado" name="depreciadoAcumulado" path="depreciadoAcumulado" size="15" tabindex="9" maxlength = "18" autocomplete="off" esMoneda="true" style="text-align: right" onkeypress="return validaSoloNumero(event,this);" />
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="totalDepreciar">Total por Depreciar:</label>
						</td>
						<td>
							<form:input type="text" id="totalDepreciar" name="totalDepreciar" path="totalDepreciar" size="15" tabindex="10" maxlength = "18" autocomplete="off" esMoneda="true" style="text-align: right" onkeypress="return validaSoloNumero(event,this);" />
						</td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap">
							<label for="porDepFiscal">% Depreciación Fiscal:</label>
						</td>
						<td>
							<form:input type="text" id="porDepFiscal" name="porDepFiscal" path="porDepFiscal" size="15" tabindex="11" maxlength="18" autocomplete="off" esMoneda="true" style="text-align: right" onkeypress="return validaSoloNumero(event,this);" />
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="depFiscalSaldoInicio">Dep. Fiscal Saldo Inicial:</label>
						</td>
						<td>
							<form:input type="text" id="depFiscalSaldoInicio" name="depFiscalSaldoInicio" path="depFiscalSaldoInicio" size="15" tabindex="12" maxlength="18" autocomplete="off" esMoneda="true" style="text-align: right" onkeypress="return validaSoloNumero(event,this);" />
						</td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap">
							<label for="depFiscalSaldoFin">Dep. Fiscal Saldo Final:</label>
						</td>
						<td>
							<form:input type="text" id="depFiscalSaldoFin" name="depFiscalSaldoFin" path="depFiscalSaldoFin" size="15" tabindex="13" maxlength="18" autocomplete="off" esMoneda="true" style="text-align: right" onkeypress="return validaSoloNumero(event,this);" />
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="mesesUso">Meses de Uso:</label>
						</td>
						<td nowrap="nowrap">
							<form:input type="text" id="mesesUso" name="mesesUso" path="mesesUso" size="15" tabindex="14" autocomplete="off"  maxlength="5" onkeypress="return validaSoloNumero(event,this);"/>
						</td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap">
							<label for="polizaFactura">Póliza Factura:</label>
						</td>
						<td nowrap="nowrap">
							<form:input type="text" id="polizaFactura" name="polizaFactura" path="polizaFactura" size="15" tabindex="15" autocomplete="off"  maxlength="15" onkeypress="return validaSoloNumero(event,this);"/>
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="centroCostoID">Centro de Costos:</label>
						</td>
						<td nowrap="nowrap">
							<form:input type="text" id="centroCostoID" name="centroCostoID" path="centroCostoID" size="10" tabindex="16" autocomplete="off" maxlength="30"/>
							<input type="text" id="descripcionCenCos" name="descripcionCC" size="40" disabled="true" readOnly="true"/>
						</td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap">
							<label for="ctaContable">Cuenta Contable:</label>
						</td>
						<td nowrap="nowrap">
							<form:input type="text" id="ctaContable" name="ctaContable" path="ctaContable" size="15" tabindex="17" autocomplete="off" maxlength="30"/>
							<input type="text" id="descripcionCtaCon" name="descripcionCtaCon" size="45" disabled="true" readOnly="true"/>
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="estatus">Estatus:</label>
						</td>
						<td nowrap="nowrap">
							<form:select id="estatus" name="estatus" path="estatus" tabindex="18">
								<form:option value="">SELECCIONAR</form:option>
								<form:option value="VI">VIGENTE</form:option>
								<form:option value="BA">BAJA</form:option>
								<form:option value="VE">VENDIDO</form:option>
							</form:select>
						</td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap">
							<label for="fechaRegistro">Fecha de Registro:</label>
						</td>
						<td nowrap="nowrap">
							<form:input type="text" id="fechaRegistro" name= "fechaRegistro" path="fechaRegistro" size="15" maxlength="10" autocomplete="off" tabindex="19" disabled="true" readOnly="true"/>
						</td>
					</tr>
				</table>
				<table align="right">
					<tr>
						<td align="right">
							<input type="submit" id="agrega" name="agrega" class="submit" tabindex="20" value="Agregar" />
							<input type="submit" id="modifica" name="modifica" class="submit" tabindex="21" value="Modificar" />
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
							<form:input type="hidden" id="tipoRegistro" name="tipoRegistro"  path="tipoRegistro" value="M"/>
							<form:input type="hidden" id="sucursalID" name="sucursalID"  path="sucursalID"/>
						</td>
					</tr>
				</table>
			</fieldset>
		</form:form>
	</div>

	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;overflow:">
		<div id="elementoLista"></div>
	</div>
	</body>
	<div id="mensaje" style="display: none;"></div>
</html>