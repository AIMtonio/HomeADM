<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/lineasCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/huellaDigitalServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/calendarioMinistracionServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/diaFestivoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/consolidacionesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/lineasCreditoServicio.js"></script>
		<script type="text/javascript" src="js/utileria.js"></script>
		<script type="text/javascript" src="js/fira/desembolsoCredito.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditos" autocomplete="off">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Desembolso de Cr&eacute;dito</legend>
					<table border="0" width="950px">
						<tr>
							<td class="label">
								<label for="creditoID">N&uacute;mero: </label>
							</td>
							<td >
								<form:input type="text" id="creditoID" name="creditoID" path="creditoID" size="12" tabindex="1"  />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="clienteID"><s:message code="safilocale.cliente"/>: </label>
							</td>
							<td nowrap="nowrap">
								<form:input id="clienteID" name="clienteID" path="clienteID" size="11" readOnly="true" disabled="true" />
								<input type="text" id="nombreCliente" name="nombreCliente" readOnly="true" disabled="true" size="45"/>
							</td>
						</tr>
						<tr>
							<td class="label" style="display:none">
								<label for="lineaCreditoID">L&iacute;nea de Cr&eacute;dito: </label>
							</td>
							<td style="display:none">
								<form:input id="lineaCreditoID" name="lineaCreditoID" path="lineaCreditoID" size="12" readOnly="true" disabled="true"/>
							</td>
							<td class="label">
								<label for="producCreditoID">Producto de Cr&eacute;dito: </label>
							</td>
							<td nowrap="nowrap">
								<form:input id="producCreditoID" name="producCreditoID" path="producCreditoID" size="11" readOnly="true" disabled="true"/>
								<input type="text" id="nombreProd" name="nombreProd" readOnly="true" disabled="true" size="45"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="cuentaID">Cuenta: </label>
							</td>
							<td>
								<form:input id="cuentaID" name="cuentaID" path="cuentaID" size="12" readOnly="true" disabled="true"/>
							</td>
						</tr>
					</table>
					<br>
					<div id="divLineaCredito" style="display:none">
						<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<legend>Saldos de la L&iacute;nea de Cr&eacute;dito</legend>
							<table border="0" width="950px">
								<tr>
									<td class="label">
										<label for="saldoDisponible">Saldo disponible: </label>
									</td>
									<td>
										<input type="text" id="saldoDisponible" name="saldoDisponible" size="15" readOnly="true" disabled="true" style="text-align: right;"/>
									</td>
									<td class="separador"></td>
									<td class="label">
										<label for="saldoDeudor">Saldo Deudor: </label>
									</td>
									<td >
										<input type="text" id="saldoDeudor" name="saldoDeudor" size="15" readOnly="true" disabled="true" style="text-align: right;" />
									</td>
								</tr>
							</table>
						</fieldset>
					</div>
					<br>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend>Condiciones</legend>
						<table border="0" width="950px">
							<tr>
								<td class="label">
									<label for="montoCredito">Monto: </label>
								</td>
								<td>
									<form:input id="montoCredito" name="montoCredito" path="montoCredito" size="15" readOnly="true" disabled="true" esMoneda="true" style="text-align: right;"/>
								</td>
								<td class="separador"></td>
								<td class="label">
								<label for="monedaID">Moneda: </label>
								</td>
								<td >
									<form:input id="monedaID" name="monedaID" path="monedaID" size="3" readOnly="true"  disabled="true"/>
									<input type="text" id="monedaDes" name="monedaDes" size="30" readOnly="true" disabled="true" />
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="fechaInicio">Fecha de Inicio : </label>
								</td>
								<td >
									<form:input id="fechaInicio" name="fechaInicio" path="fechaInicio" size="15" readOnly="true" disabled="true" />
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="fechaVencimien">Fecha de Vencimiento: </label>
								</td>
								<td>
									<form:input id="fechaVencimien" name="fechaVencimien" path="fechaVencimien" size="15" readOnly="true" disabled="true"/>
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="factorMora">Factor Mora: </label>
								</td>
								<td >
									<form:input id="factorMora" name="factorMora" path="factorMora" size="8" esTasa="true" readOnly="true" disabled="true" />
									<label for="lblveces" id="lblveces"></label>
								</td>
								<td class="separador"></td>
							</tr>
						</table>
					</fieldset>
					<br>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend>Estatus</legend>
						<table border="0" width="950px">
							<tr>
								<td class="label">
									<label for="estatus">Estatus:</label>
								</td>
								<td>
									<form:select id="estatus" name="estatus" path="estatus" readOnly="true" disabled="true">
										<form:option value="I">INACTIVO</form:option>
										<form:option value="V">VIGENTE</form:option>
										<form:option value="P">PAGADO</form:option>
										<form:option value="C">CANCELADO</form:option>
										<form:option value="A">AUTORIZADO</form:option>
										<form:option value="B">VENCIDO</form:option>
										<form:option value="K">CASTIGADO</form:option>
										<form:option value="M">PROCESADO</form:option>
									</form:select>
								</td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
							</tr>
						</table>
					</fieldset>
					<br>
					<div id="calendarioMinistraGrid"></div>
					<br>
					<div id="divComentarios" style="display: none;">
						<fieldset class="ui-widget ui-widget-content ui-corner-all" >
							<legend>Comentarios</legend>
							<table >
								<tr>
									<td class="label" >
										<label for="comentarioCred">Comentarios: </label>
									</td>
									<td>
										<form:textarea  id="comentarioCred" name="comentarioCred" path="comentarioCred" tabindex="21" COLS="50" ROWS="4" onBlur=" ponerMayusculas(this);  limpiarCajaTexto(this.id);" disabled="false" maxlength="500"/>
									</td>
								</tr>
							</table>
						</fieldset>
					</div>
					<br>
					<div id="usuarioContrasenia" style="width: 400px; display: none;">
						<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<legend class="ui-widget ui-widget-header ui-corner-all">Usuario Autoriza</legend>
							<table border="0" width="100%">
								<tr>
									<td class="label" nowrap="nowrap">
										<label for="usuarioAutoriza">Usuario:</label>
									</td>
									<td>
										<input id="usuarioAutoriza" name="usuarioAutoriza" readonly onfocus="evitaAutocompletado(this);" size="25" iniForma="false" type="text" maxlength="45" tabindex="22" onblur="validaUsuarioAutorizacion(); validaAutorizacion();" />
									</td>
								</tr>
								<tr>
									<td class="label" nowrap="nowrap">
										<label for="contraseniaAutoriza">Contraseña:</label>
									</td>
									<td>
										<input id="contraseniaAutoriza" name="contraseniaAutoriza" readonly onfocus="evitaAutocompletado(this);" size="25" type="password" maxlength="45" iniForma="false" tabindex="23" onblur="validaAutorizacion();" />
									</td>
								</tr>
							</table>
						</fieldset>
					</div>
					<table align="right">
						<tr>
							<td align="right">
								<input type="submit" id="desembolsar" name="desembolsar" class="submit" value="Desembolsar" tabindex="24"/>
								<input type="submit" id="cancelar" name="cancelar" class="submit" value="Cancelar" tabindex="25"/>
							</td>
						</tr>
						<tr>
							<td>
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
								<input type="hidden" id="tipoActualizacion" name="tipoActualizacion"/>
								<input type="hidden" id="solicitudCreditoID" name="solicitudCreditoID" value="solicitudCreditoID"/>
								<input type="hidden" id="numeroID" name="numeroID" value="" size="10" />
								<input type="hidden" id="diasCancelacion" name="diasCancelacion" value="" size="10" />
								<input type="hidden" id="diasMaxMinistraPosterior" name="diasMaxMinistraPosterior" value="" size="10" />
								<input type="hidden" id="fechaDeMinistracion" name="fechaDeMinistracion" value="" size="10" />
								<input type="hidden" id="fechaLimCancelacion" name="fechaCancelacion" value="" size="10" />
								<input type="hidden" id="fechaLimMinistraPosterior" name="fechaMinistraPosterior" value="" size="10" />
								<input type="hidden" id="tipoCalculoInteres" name="tipoCalculoInteres" value="" size="10" />
								<input type="hidden" id="esLineaCreditoAgro" name="esLineaCreditoAgro" value="" size="10" />
								<input type="hidden" id="forPagComGarantia" name="forPagComGarantia" value="" size="10" />
							</td>
						</tr>
					</table>
				</fieldset>
			</form:form>
		</div>
		<div id="cargando" style="display: none;">
		</div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"></div>
		</div>
	</body>
	<div id="mensaje" style="display: none;">
	</div>
<html>