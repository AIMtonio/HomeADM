<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type='text/javascript' src='js/jquery.formatCurrency-1.4.0.min.js'></script>
<script type="text/javascript" src="dwr/interface/conocimientoCtaServicio.js"></script>
<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js"></script>
<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
<script type="text/javascript" src="js/cuentas/conocimientoCuentaCatalogo.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="conocimientoCtaBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Formato Conocimiento de Cuentas</legend>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend> Datos del <s:message code="safilocale.cliente" /></legend>
					<table border="0" width="100%">
						<tr>
							<td class="label" nowrap="nowrap">
								<label for="lblCuentaAhoID">N&uacute;mero de Cuenta: </label>
							</td>
							<td>
								<form:input id="cuentaAhoID" name="cuentaAhoID" path="cuentaAhoID" size="12" iniForma='false' tabindex="2" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="lblNombreCliente">Nombre <s:message code="safilocale.cliente" />:
								</label>
							</td>
							<td colspan="4">
								<input id="numCliente" name="numCliente" size="12" iniForma='false' type="text" readOnly="true" disabled="true" /> <input id="nombreCliente" name="nombreCliente" size="95" iniForma='false' type="text" readOnly="true" disabled="true" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="lblCuentaAhoID">Tipo Cuenta: </label>
							</td>
							<td>
								<input id="tipoCuenta" name="tipoCuenta" size="12" iniForma='false' type="text" readOnly="true" disabled="true" /> <input id="tipoCuentaDescrip" name="tipoCuentaDescrip" size="35" iniForma='false' type="text" readOnly="true" disabled="true" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="lblMoneda">Moneda: </label>
							</td>
							<td>
								<input id="moneda" name="moneda" size="10" iniForma='false' type="text" readOnly="true" disabled="true" /> <input id="tipoMonedaDescrip" name="tipoMonedaDescrip" size="19" iniForma='false' type="text" readOnly="true" disabled="true" />
							</td>
						</tr>
					</table>
				</fieldset>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Transaccionalidad Esperada en su Cuenta</legend>
					<table border="0" width="100%">
						<tr>
							<td class="label">
								<label for="lblDepositoCred">Dep&oacute;sitos / Cr&eacute;ditos:&nbsp;</label>
							</td>
							<td>
								<form:input id="depositoCred" name="depositoCred" path="depositoCred" size="20" esMoneda="true" tabindex="3" style="text-align:right;" maxlength="18" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="lblRetirosCargo">Retiros / Cargos:&nbsp;</label>
							</td>
							<td>
								<form:input id="retirosCargo" name="retirosCargo" path="retirosCargo" size="20" esMoneda="true" tabindex="4" style="text-align:right;" maxlength="18" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="numDepositos">N&uacute;mero de Dep&oacute;sitos:&nbsp;</label>
							</td>
							<td>
								<form:input id="numDepositos" name="numDepositos" path="numDepositos" size="20" tabindex="3" maxlength="18" onkeyup="soloNumero(this);"/>
							</td>
							<td class="separador"></td>
							<td class="label" nowrap="nowrap">
								<label for="numRetiros">N&uacute;mero de Retiros:&nbsp;</label>
							</td>
							<td>
								<form:input id="numRetiros" name="numRetiros" path="numRetiros" size="20" tabindex="4" maxlength="18" onkeyup="soloNumero(this);"/>
							</td>
						</tr>
						<tr>
							<td class="label" nowrap="nowrap">
								<label for="frecDepositos">Frecuencia de Dep&oacute;sitos:&nbsp;</label>
							</td>
							<td>
								<form:input id="frecDepositos" name="frecDepositos" path="frecDepositos" size="20" tabindex="3" maxlength="3" onkeyup="soloNumero(this);"/>
								<label>d&iacute;a(s).&nbsp;</label>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="frecRetiros">Frecuencia de Retiros:&nbsp;</label>
							</td>
							<td>
								<form:input id="frecRetiros" name="frecRetiros" path="frecRetiros" size="20" tabindex="4" maxlength="3" onkeyup="soloNumero(this);"/>
								<label>d&iacute;a(s).&nbsp;</label>
							</td>
						</tr>
					</table>
				</fieldset>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Procedencia de los Recursos Para su Apertura</legend>
					<table border="0" width="100%">
						<tr>
							<td class="label" nowrap="nowrap">
								<label for="lblProcRecursos">Procedencia de los Recursos para la Apertura:&nbsp;</label>
							</td>
							<td colspan="4">
								<form:input id="procRecursos" name="procRecursos" path="procRecursos" size="80" tabindex="5" onBlur=" ponerMayusculas(this)" maxlength="80" />
							</td>
						</tr>
					</table>
				</fieldset>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Su Cuenta se Utilizar&aacute; Para: </legend>
					<table border="0" width="100%">
						<tr>
							<td class="separador"></td>
							<td class="label">
								<form:input type="checkbox" id="concentFondo" name="concentFondo" path="concentFondo" value="S" tabindex="6" />
								<label for="lblConcentracion">Concentraci&oacute;n de Fondos.</label>
							</td>
						</tr>
						<tr>
							<td class="separador"></td>
							<td class="label">
								<form:input type="checkbox" id="admonGtosIng" name="admonGtosIng" path="admonGtosIng" value="S" tabindex="7" />
								<label for="lblAdmon">Administraci&oacute;n de Gastos e Ingresos.</label>
							</td>
						</tr>
						<tr>
							<td class="separador"></td>
							<td class="label">
								<form:input type="checkbox" id="pagoNomina" name="pagoNomina" path="pagoNomina" value="S" tabindex="8" />
								<label for="lblPago">Pago de N&oacute;mina.</label>
							</td>
						</tr>
						<tr>
							<td class="separador"></td>
							<td class="label">
								<form:input type="checkbox" id="ctaInversion" name="ctaInversion" path="ctaInversion" value="S" tabindex="9" />
								<label for="lblCtaInver">Cuenta para Inversi&oacute;n.</label>
							</td>
						</tr>
						<tr>
							<td class="separador"></td>
							<td class="label">
								<form:input type="checkbox" id="pagoCreditos" name="pagoCreditos" path="pagoCreditos" value="S" tabindex="10" />
								<label for="lblPagoCred">Pago de Cr&eacute;ditos.</label>
							</td>
						</tr>
						<tr>
							<td class="separador"></td>
							<td class="label">
								<form:input type="checkbox" id="mediosElectronicos" name="mediosElectronicos" path="mediosElectronicos" value="S" tabindex="10" />
								<label for="lblPagoCred">Medios Electr&oacute;nicos.</label>
							</td>
						</tr>
						<tr>
							<td class="separador"></td>
							<td class="label">
								<form:input type="checkbox" id="otroUso" name="otroUso" path="otroUso" value="S" tabindex="11" onchange="habilitaImputConCheck(this);"/>
								<label for="lblOtros">Otros:</label>
								<form:input id="defineUso" name="defineUso" path="defineUso" size="50" tabindex="12" onBlur=" ponerMayusculas(this)" maxlength="40" />
							</td>
						</tr>
					</table>
				</fieldset>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Los Recursos que Manejar&aacute; en su Cuenta Provienen de: </legend>
					<table border="0" width="100%">
						<tr>
							<td class="separador"></td>
							<td class="label">
								<form:input type="checkbox" id="recursoProvP" name="recursoProv" path="recursoProv" value="P" tabindex="13" />
								<label for="lblRecProp">Recursos Propios (Producto de su Trabajo, Inversiones, u Otras Actividades).</label>
							</td>
						</tr>
						<tr>
							<td class="separador"></td>
							<td class="label">
								<form:input type="checkbox" id="recursoProvT" name="recursoProv" path="recursoProvT" value="T" tabindex="14" />
								<label for="lblRecTer">Recursos de Terceros (Pertenecen a Terceras Personas).</label>
							</td>
						</tr>
					</table>
				</fieldset>
				<table width="100%">
					<tr>
						<td align="right">
							<input type="submit" id="agrega" name="agrega" class="submit" tabindex="15" value="Agregar" /> <input type="submit" id="modifica" name="modifica" class="submit" tabindex="16" value="Modificar" /> <input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="tipoTransaccion" />
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
