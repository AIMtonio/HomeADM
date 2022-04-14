<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/castigosCarteraServicio.js"></script>
<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/recupCarteraCastAgroServicio.js"></script>
<script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js"></script>
<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>

<script type="text/javascript" src="js/fira/recupCarteraCastAgro.js"></script>

</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="recupCarteraCastAgro">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Recuperación de Cartera Castigada Agro</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="label"><label for="creditoAgro">Crédito: </label></td>
							<td><form:input path="creditoAgro" id="creditoAgro" name="creditoAgro" iniForma="true" size="15" type="text" value="" tabindex="1" /></td>
							<td class="separador"></td>
							<td class="label"><label for="productoCreditoAgro">Producto:</label></td>
							<td><form:input path="productoCreditoAgro" id="productoCreditoAgro" name="productoCreditoAgro" iniForma="true" size="15" type="text" readOnly="true" disabled="true" value="" tabindex="2"/>
								<form:input path="desProducAgro" id="desProducAgro" name="desProducAgro" iniForma="true" size="35" type="text" readOnly="true" disabled="true"	 /></td>
						</tr>
						<tr>
							<td class="label"><label for="clienteID"><s:message code="safilocale.cliente"/>:</label></td>
							<td><form:input path="clienteID" id="clienteID" name="clienteID"   size="15" type="text" readOnly="true" disabled="true"  value="" tabindex="3" />
								<form:input path="nombreCliente" id="nombreCliente" name="nombreCliente" iniForma="true" size="35" type="text" readOnly="true" disabled="true"  /></td>
							<td class="separador"></td>
							<td class="label"><label for="estatusCred">Estatus:</label></td>
							<td><form:input path="estatusCred" id="estatusCred" name="estatusCred"  size="15" type="text" readOnly="true" disabled="true"  value="" tabindex="4" /></td>
						</tr>
						<tr>
							<td class="label"><label for="monedaCartAgro">Moneda:</label></td>
							<td><form:input path="monedaCartAgro" id="monedaCartAgro" name="monedaCartAgro"  iniForma="true" size="15" type="text" readOnly="true" disabled="true"  value="" tabindex="5" />
								<form:input path="desMonedaCartAgro" id="desMonedaCartAgro" name="desMonedaCartAgro" iniForma="true" size="35" type="text" readOnly="true" disabled="true"  /></td>
							<td class="separador"></td>
							<td class="label"><label for="montoCreditoCastAgro">Monto Credito:</label></td>
							<td><form:input path="montoCreditoCastAgro" id="montoCreditoCastAgro" name="montoCreditoCastAgro"  esMoneda="true" iniForma="true" size="15" type="text" readOnly="true" disabled="true" value="" tabindex="6"/></td>
						</tr>
						<tr>
							<td class="label"><label for="cuentaID">Cuenta: </label></td>
						    <td><form:input path="cuentaID" type="text" id="cuentaID" name="cuentaID"   iniForma="true" size="15"  readOnly="true" disabled="true" value="" tabindex="7" />
						    <form:input path="desCuenta" type="text" id="desCuenta" name="desCuenta"  iniForma="true" size="15" readOnly="true" disabled="true" /></td>
							<td class="separador"></td>
							<td class="label"><label for="saldoCreditoAgro">Saldo:</label></td>
							<td><form:input path="saldoCreditoAgro" id="saldoCreditoAgro" name="saldoCreditoAgro"  esMoneda="true" iniForma="true" size="15" type="text" readOnly="true" disabled="true" value="" tabindex="8"/></td>
						</tr>
					</table>
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend>Castigo</legend>
				<div>
						<table>
								<tr>
									<td class="label"><label for="fechaCastigo">Fecha Castigo:</label></td>
									<td><form:input path="fechaCastigo" id="fechaCastigo" name="fechaCastigo" iniForma="true" size="18" type="text" readOnly="true" disabled="true" value="" tabindex="9"/></td>
									<td class="separador"></td>
									<td class="label"><label for="motivoCastigo">Motivo:</label></td>
									<td><select path="motivoCastigo" id="motivoCastigo"	name="motivoCastigo" readOnly="true" disabled="true" disabled="true" value="" tabindex="10"></select></td>
								</tr>
								<tr>
									<td class="label"><label for="observacionesCastigo">Observaciones:</label></td>
									<td><form:textarea path="observacionesCastigo" id="observacionesCastigo" name="observacionesCastigo" type="text" readOnly="true" disabled="true" value="" tabindex="11"/></textarea></td>
									<td class="separador"></td>
									<td class="label"><label for="monRecuperado">Monto:</label></td>
									<td><form:input path="monRecuperado" id="monRecuperado" name="monRecuperado"  esMoneda="true" iniForma="true" size="18" type="text"  style="text-align: right" value="" tabindex="12" /></td>
								</tr>
								<tr>
								    <td class="label"><label for="porcentajeCreditoRec">&#37; Cr&eacute;dito R: </label></td>
									<td><form:input path="porcentajeCreditoRec" type="text" id="porcentajeCreditoRec" name="porcentajeCreditoRec" iniForma="true" size="18"   style="text-align: right" value="" tabindex="13" maxlength="3" /></td>
								    <td class="separador"></td>
								    <td class="label"><label for="porcentajeCreditoRecCont">&#37; Cr&eacute;dito RC: </label></td>
									<td><form:input path="porcentajeCreditoRecCont" type="text" id="porcentajeCreditoRecCont" name="porcentajeCreditoRecCont" iniForma="true" size="18"  style="text-align: right" value="" tabindex="14" maxlength="3"/></td>
								</tr>
						</table>
					</div>
				</fieldset>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend>Cr&eacute;dito Activo</legend>
				<div>
						<table>
								<tr>
									<td><label for="capitalActivoCast">Capital Castigado: </label></td>
									<td><form:input path="capitalActivoCast" type="text" id="capitalActivoCast" name="capitalActivoCast"  esMoneda="true" iniForma="true" size="18"  readOnly="true" disabled="true" style="text-align: right" value="" tabindex="15"/></td>
									<td class="separador"></td>
									<td class="label"><label for="interesActivoCast">Inter&eacute;s Castigado:</label></td>
									<td><form:input path="interesActivoCast" type="text" id="interesActivoCast" name="interesActivoCast"  esMoneda="true" iniForma="true" size="18"  readOnly="true" disabled="true" style="text-align: right" value="" tabindex="16"/></td>
								</tr>
								<tr>
									<td class="label"><label for="moratoriosActivosCast">Moratorios Castigados :</label></td>
									<td><form:input path="moratoriosActivosCast" id="moratoriosActivosCast" name="moratoriosActivosCast" type="text"  esMoneda="true" iniForma="true" size="18"  readOnly="true" disabled="true" style="text-align: right" value="" tabindex="17"/></input></td>
									<td class="separador"></td>
									<td class="label"><label for="comisionesActivasCast">Comisiones Cast:</label></td>
									<td><form:input path="comisionesActivasCast" id="comisionesActivasCast" name="comisionesActivasCast" type="text"  esMoneda="true" iniForma="true" size="18"  readOnly="true" disabled="true" style="text-align: right" value="" tabindex="18"/></td>
								</tr>
								<tr>
								    <td class="label"><label for="IVAActivoCast">IVA: </label></td>
									<td><form:input path="IVAActivoCast" type="text" id="IVAActivoCast" name="IVAActivoCast" esMoneda="true" iniForma="true" size="18"  readOnly="true" disabled="true" style="text-align: right" value="" tabindex="19"/></td>
								    <td class="separador"></td>
								    <td class="label"><label for="totalActivoCastigado">Total Castigado: </label></td>
									<td><form:input path="totalActivoCastigado" type="text" id="totalActivoCastigado" name="totalActivoCastigado" esMoneda="true" iniForma="true" size="18"  readOnly="true" disabled="true" style="text-align: right" value="" tabindex="20"/></td>
								</tr>
								<tr>
								    <td class="label"><label for="montoRecActivoCast">Monto Recuperado: </label></td>
									<td><form:input path="montoRecActivoCast" type="text" id="montoRecActivoCast" name="montoRecActivoCast" esMoneda="true" iniForma="true" size="18"  readOnly="true" disabled="true" style="text-align: right" value="" tabindex="21" /></td>
								    <td class="separador"></td>
								    <td class="label"><label for="montoxRecActivoCast">Monto por Recuperar: </label></td>
									<td><form:input path="montoxRecActivoCast" type="text" id="montoxRecActivoCast" name="montoxRecActivoCast"esMoneda="true" iniForma="true" size="18" readOnly="true" disabled="true" style="text-align: right" value="" tabindex="22" /></td>
								</tr>

						</table>
					</div>
				</fieldset>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend>Cr&eacute;dito Contingente</legend>
				<div>
						<table>
								<tr>
									<td class="label"><label>Capital Castigado: </label></td>
									<td><form:input path="capitalContCast" type="text" id="capitalContCast" name="capitalContCast" esMoneda="true" iniForma="true" size="18"  readOnly="true" disabled="true" style="text-align: right" value="" tabindex="23"/></td>
									<td class="separador"></td>
									<td class="label"><label for="interesContCast">Inter&eacute;s Castigado:</label></td>
									<td><form:input path="interesContCast" type="text" id="interesContCast" name="interesContCast"  esMoneda="true" iniForma="true" size="18"  readOnly="true" disabled="true" style="text-align: right" value="" tabindex="24"/></td>
								</tr>
								<tr>
									<td class="label"><label for="moratoriosContCast">Moratorios Castigados :</label></td>
									<td><form:input path="moratoriosContCast" id="moratoriosContCast" name="moratoriosContCast" type="text"  esMoneda="true" iniForma="true" size="18"  readOnly="true" disabled="true" style="text-align: right" value="" tabindex="25"/></input></td>
									<td class="separador"></td>
									<td class="label"><label for="comisionesContCast">Comisiones Cast:</label></td>
									<td><form:input path="comisionesContCast" id="comisionesContCast" name="comisionesContCast" type="text"  esMoneda="true" iniForma="true" size="18" readOnly="true" disabled="true" style="text-align: right" value="" tabindex="26"/></td>
								</tr>
								<tr>
								    <td class="label"><label for="IVAContCast">IVA: </label></td>
									<td><form:input path="IVAContCast" type="text" id="IVAContCast" name="IVAContCast" esMoneda="true" iniForma="true" size="18"  readOnly="true" disabled="true" style="text-align: right" value="" tabindex="27"/></td>
								    <td class="separador"></td>
								    <td class="label"><label for="totalContCastigado">Total Castigado: </label></td>
									<td><form:input path="totalContCastigado" type="text" id="totalContCastigado" name="totalContCastigado" esMoneda="true" iniForma="true" size="18"  readOnly="true" disabled="true" style="text-align: right" value="" tabindex="28"/></td>
								</tr>
								<tr>
								    <td class="label"><label for="montoRecContCast">Monto Recuperado: </label></td>
									<td><form:input path="montoRecContCast" type="text" id="montoRecContCast" name="montoRecContCast" esMoneda="true" iniForma="true" size="18"  readOnly="true" disabled="true" style="text-align: right" value="" tabindex="29"/></td>
								    <td class="separador"></td>
								    <td class="label"><label for="montoxRecContCast">Monto por Recuperar: </label></td>
									<td><form:input path="montoxRecContCast" type="text" id="montoxRecContCast" name="montoxRecContCast" esMoneda="true" iniForma="true" size="18"  readOnly="true" disabled="true" style="text-align: right" value="" tabindex="30"/></td>
								</tr>
						</table>
					</div>
				</fieldset>
				<div>
				<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">
					<tr>
						<td colspan="3" align="right">
							<input type="submit" id="graba"	name="graba" class="submit" value="Grabar"  tabindex="31"/>
							<input type="hidden" id="numeroTransaccion" name="numeroTransaccion" />
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
						</td>
					</tr>
				</table>
			</div>
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