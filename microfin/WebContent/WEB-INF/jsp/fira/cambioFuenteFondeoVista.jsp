<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head> 
<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/lineasCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
<script type="text/javascript" src="dwr/interface/amortizacionCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/creditosMovsServicio.js"></script>
<script type="text/javascript" src="dwr/interface/gruposCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/formTipoCalIntServicio.js"></script>
<script type="text/javascript" src="dwr/interface/tasasBaseServicio.js"></script>
<script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>
<script type="text/javascript" src="dwr/interface/fondeoServicio.js"></script>  
<script type="text/javascript" src="dwr/interface/lineaFonServicio.js"></script>
<script type="text/javascript" src="js/fira/cambioFondeo.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditosBean" target="_blank">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Cambio de Fuente de Fondeo</legend>
				<table border="0" width="100%">
					<tr>
						<td class="label"><label for="creditoID">Cr&eacute;dito: </label></td>
						<td><form:input id="creditoID" name="creditoID" path="creditoID" size="12" autocomplete="off" iniForma='false' tabindex="1"/></td>
						<td class="separador"></td>
						<td class="label"><label for="clienteID"><s:message code="safilocale.cliente" />: </label></td>
						<td><input id="clienteID" name="clienteID" path="clienteID" size="12" tabindex="2" type="text" readOnly="true" disabled="true" /> <input id="nombreCliente" name="nombreCliente" path="nombreCliente" size="45" tabindex="3" type="text" readOnly="true" disabled="true" /></td>
					</tr>
					<tr>
						<td class="label"><label for="cuentaID">Cuenta: </label></td>
						<td><input id="cuentaID" name="cuentaID" path="cuentaID" size="12" tabindex="4" type="text" readOnly="true" disabled="true" /></td>
						<td class="separador"></td>
						<td class="label"><label for="moneda">Moneda: </label></td>
						<td>
						<input id="monedaID" name="monedaID" path="monedaID" size="12" tabindex="5" type="text" readOnly="true" disabled="true" /> <input id="monedaDes" name="monedaDes" size="12" tabindex="6" type="text" readOnly="true" disabled="true" /></td>
					</tr>
					<tr>
						<td class="label"><label for="lblestatus">Estatus:</label></td>
						<td><input id="estatus" name="estatus" path="estatus" size="12" tabindex="7" type="text" readOnly="true" disabled="true" /></td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap"><label for="producCreditoID">Producto Cr&eacute;dito: </label></td>
						<td nowrap="nowrap"><input id="producCreditoID" name="producCreditoID" path="producCreditoID" size="12" tabindex="8" type="text" readOnly="true" disabled="true" /> <input id="descripProducto" name="descripProducto" size="45" tabindex="9" type="text" readOnly="true" disabled="true" /></td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap"><label for="lbldiasFaltaPago">D&iacute;as Falta Pago:</label></td>
						<td><input id="diasFaltaPago" name="diasFaltaPago" size="12" tabindex="10" type="text" readOnly="true" disabled="true" /></td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap"><label id="lbltasaFija" for="tasaFija">Tasa Fija:</label></td>
						<td><input id="tasaFija" name="tasaFija" path="tasaFija" size="12" tabindex="11" type="text" readOnly="true" disabled="true" style="text-align: right;" /> <label>%</label></td>

					</tr>
					<tr>
						<td class="label"><label for="lblOrigen">Origen:</label></td>
						<td><input id="origen" name="origen" path="origen" size="25" tabindex="13" type="text" readOnly="true" disabled="true" /></td>
					</tr>
					<tr>
						<td class="label">
							<label for="FuenteF">Fondeador: </label>
							</td>
						<td nowrap="nowrap">
							<input type="text" id="institFondeoIDN" name="institFondeoIDN" size="8" readonly="true" disabled="true" tabindex="14" /> 
							<input type="text" id="nombreFondeo" name="nombreFondeo" size="35" readonly="true" disabled="true" tabindex="15" /></td>
						<td class="separador"></td>
						<td class="label">
							<label for="lblLineaFondeo">L&iacute;nea de Fondeo: </label>
						</td>
						<td nowrap="nowrap">
							<input type="text" id="lineaFondeoN" name="lineaFondeoN"  size="12" disabled="true" readonly="true" />
							<input type="text" id="descripLineaFonN" name="descripLineaFonN" size="35" disabled="true" />
						</td>
					</tr>
				</table>
				<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Saldo Total del Cr&eacute;dito</legend>
					<div>
						<table width="100%">
							<tr>
								<td class="label" colspan="2"><label><b>Capital </b></label></td>
								<td class="separador"></td>
								<td class="label" colspan="2"><label><b>Inter&eacute;s</b></label></td>
								<td class="separador"></td>
								<td class="label"><label><b>IVA Inter&eacute;s </b></label></td>
								<td><input type="text" name="saldoIVAInteres" id="saldoIVAInteres" size="8" readonly="true" disabled="true" tabIndex="29" esMoneda="true" style="text-align: right" /></td>
								<td class="separador"></td>
								<td class="label" colspan="2"><label><b>Comisiones</b></label>
								<td class="separador"></td>
								<td class="label" colspan="2"><label><b>IVA Comisiones</b></label></td>
							</tr>
							<tr>
								<td><label>Vigente: </label></td>
								<td><input id="saldoCapVigent" name="saldoCapVigent" size="8" type="text" readOnly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
								<td class="separador"></td>
								<td><label>Ordinario: </label></td>
								<td><input type="text" name="saldoInterOrdin" id="saldoInterOrdin" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
								<td colspan="2"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td><label> Falta Pago: </label></td>
								<td><input type="text" name="saldoComFaltPago" id="saldoComFaltPago" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
								<td class="separador"></td>
								<td><label> Falta Pago: </label></td>
								<td><input type="text" name="salIVAComFalPag" id="salIVAComFalPag" size="8" readonly="true" disabled="true"  esMoneda="true" style="text-align: right" /></td>
							</tr>
							<tr>
								<td><label>Atrasado: </label></td>
								<td><input id="saldoCapAtrasad" name="saldoCapAtrasad" size="8" tabindex="19" type="text" readOnly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
								<td class="separador"></td>
								<td><label>Atrasado: </label></td>
								<td><input type="text" name="saldoInterAtras" id="saldoInterAtras" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
								<td class="separador"></td>
								<td class="label"><label><b>Moratorio</b></label></td>
								<td><input type="text" name="saldoMoratorios" id="saldoMoratorios" size="8" readonly="true" disabled="true"  esMoneda="true" style="text-align: right" /></td>
								<td class="separador"></td>
								<td><label>Otras: </label></td>
								<td><input type="text" name="saldoOtrasComis" id="saldoOtrasComis" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
								<td class="separador"></td>
								<td><label>Otras: </label></td>
								<td><input type="text" name="saldoIVAComisi" id="saldoIVAComisi" size="8" readonly="true" disabled="true"  esMoneda="true" style="text-align: right" /></td>
							</tr>
							<tr>
								<td><label>Vencido: </label></td>
								<td><input type="text" name="saldoCapVencido" id="saldoCapVencido" size="8" readonly="true" disabled="true"  esMoneda="true" style="text-align: right" /></td>
								<td class="separador"></td>
								<td><label>Vencido: </label></td>
								<td><input type="text" name="saldoInterVenc" id="saldoInterVenc" size="8" readonly="true" disabled="true"  esMoneda="true" style="text-align: right" /></td>
								<td class="separador"></td>
								<td class="label" nowrap="nowrap"><label><b>IVA Moratorio</b></label></td>
								<td><input type="text" name="saldoIVAMorator" id="saldoIVAMorator" size="8" readonly="true" disabled="true"  esMoneda="true" style="text-align: right" /></td>
								<td class="separador"></td>
								<td><label>Admon: </label></td>
								<td><input type="text" name="saldoAdmonComis" id="saldoAdmonComis" size="8" readonly="true" disabled="true"  esMoneda="true" style="text-align: right" value="" /></td>
								<td class="separador"></td>
								<td><label>Admon: </label></td>
								<td><input type="text" name="saldoIVAAdmonComisi" id="saldoIVAAdmonComisi" size="8" readonly="true" disabled="true"  esMoneda="true" style="text-align: right" value="" /></td>
							</tr>
							<tr>
								<td nowrap="nowrap"><label>Vencido no Exigible: </label></td>
								<td><input type="text" name="saldCapVenNoExi" id="saldCapVenNoExi" size="8" readonly="true" disabled="true"  esMoneda="true" style="text-align: right" /></td>
								<td class="separador"></td>
								<td><label>Provisi&oacute;n:</label></td>
								<td><input type="text" name="saldoInterProvi" id="saldoInterProvi" size="8" readonly="true" disabled="true"  esMoneda="true" style="text-align: right" /></td>
								<td></td>
								<td></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="label"><label>Seguro:</label></td>
								<td><input type="text" name="saldoSeguroCuota" id="saldoSeguroCuota" size="8" readonly="true" disabled="true"  esMoneda="true" style="text-align: right" /></td>
								<td class="separador"></td>
								<td nowrap="nowrap" class="label"><label>IVA Seguro:</label></td>
								<td><input type="text" name="saldoIVASeguroCuota" id="saldoIVASeguroCuota" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
							</tr>
							<tr>
								<td><label><b>Total: </b></label></td>
								<td><input name="totalCapital" id="totalCapital" type="text" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
								<td class="separador"></td>
								<td nowrap="nowrap"><label>Cal.No Cont.: </label></td>
								<td><input type="text" name="saldoIntNoConta" id="saldoIntNoConta" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
								<td class="label"><label></label></td>
								<td></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td><label>Anualidad:</label></td>
								<td><input type="text" name="saldoComAnual" id="saldoComAnual" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
								<td class="separador"></td>
								<td><label>Anualidad:</label></td>
								<td><input type="text" name="saldoComAnualIVA" id="saldoComAnualIVA" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
							</tr>
							<tr>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td><label><b>Total: </b></label></td>
								<td><input type="text" name="totalInteres" id="totalInteres" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>								

								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td><label><b>Total: </b></label></td>
								<td><input type="text" name="totalComisi" id="totalComisi" size="8" readonly="true" disabled="true" esMoneda="true" style="text-align: right" /></td>
								<td class="separador"></td>
								<td><label><b>Total: </b></label></td>
								<td><input type="text" name="totalIVACom" id="totalIVACom" size="8" readonly="true" disabled="true"  esMoneda="true" style="text-align: right" /></td>
							</tr>
							<tr>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="label"><label><b> Saldo Total Crédito :</b></label></td>
									<td><input id="saldoTotal" name="saldoTotal" size="15" type="text" readOnly="true" disabled="true" esMoneda="true" style="text-align: right" />
									<input type="hidden" id="adeudoTotal" name="adeudoTotal"/>
								</td>
							</tr>
						</table>
					</div>
				</fieldset>
				<div id="fuenteFon">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend>Cambio Fuente Fondeo</legend>
						<table >
							<tr>
								<td class="label"><label for="FuenteF">Fondeador: </label></td>
								<td nowrap="nowrap">
									<input type="text" id="institFondeoID" name="institFondeoID" path="institFondeoID" size="8" tabindex="16" maxlength="12"  autocomplete="off" /> 
									<input type="text" id="nombreFondeoN" name="nombreFondeoN" size="35" readonly="true" disabled="true" tabindex="17" />
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="lblLineaFondeo">L&iacute;nea de Fondeo: </label>
								</td>
								<td>
									<form:input id="lineaFondeo" name="lineaFondeo" path="lineaFondeo" size="12"  autocomplete="off" tabindex="18"/>
									<input type="text" id="descripLineaFon" name="descripLineaFon" size="45" disabled="true" />
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="lblTasaPasiva">Tasa Pasiva: </label>
								</td>
								<td>
									<input type="text" id="tasaPasiva" name="tasaPasiva" size="12" tabindex="19" esTasa="true" style="text-align: right" />
								</td>
							</tr>
							<tr class="mostrarAcredFIRA" style="display: none">
								<td class="label mostrarAcred">
									<label for="acreditadoIDFIRA">ID de Acreditado: </label>
								</td>
								<td class="mostrarAcred" style="display: none">
									<input type="text" id="acreditadoIDFIRA" name="acreditadoIDFIRA" size="18" maxlength="20" tabindex="20"/>
								</td>
								<td class="separador mostrarCredS" style="display: none"></td>
								<td class="label mostrarCred" style="display: none">
									<label for="creditoIDFIRA">ID de Cr&eacute;dito: </label>
								</td>
								<td class="mostrarCred" style="display: none">
									<input type="text" id="creditoIDFIRA" name="creditoIDFIRA" size="18" maxlength="20" tabindex="21"/>
								</td>
							</tr>
						</table>
						<table>
							<tr>
								<td>
									<div id="usuarioContrasenia">
									<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend class="ui-widget ui-widget-header ui-corner-all">Usuario  Autoriza</legend>
									<table  width="100%">
										<tr>
											<td class="label" nowrap="nowrap">
												<label for="lblUsuario">Usuario:</label>
											</td>
											<td>
												<input id="usuarioAutoriza" name="usuarioAutoriza" size="20" type="text" tabindex="22" autocomplete="off"/>
											</td>
										</tr>
										<tr>
											<td class="label" nowrap="nowrap">
												<label for="lblContrasenia">Contrase&ntilde;a:</label>
											</td>
											<td>
												<input id="contrasenia" name="contrasenia" size="20" type="password" iniForma="false" tabindex="23" autocomplete="new-password"/>
												<input type="hidden" id="usuarioID" name="usuarioID" size="50"  iniForma="false"/>
											</td>
										</tr>	
									</table>
									</fieldset>
									</div>
								</td>
							</tr>	
						</table>
					</fieldset>
				</div>
				<table align="right">
					<tr>
						<td align="right">	
							<input type="submit" id="agrega" name="agrega" class="submit" value="Cambiar"  tabindex="24"/>
							<input type="button" id="genPoliza" name="genPoliza" class="submit" value="Ver Poliza" tabindex="25"/>
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>		
							<input type="hidden" id="fecha" name="fecha"/>		
							<input type="hidden" id="usuarioSesion" name="usuarioSesion"/>	
							<input type="hidden" id="saldoLinea" name="saldoLinea"/>
							<input type="hidden" id="solicitudCreditoID" name="solicitudCreditoID"/>
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
</body>
<div id="mensaje" style="display: none;"></div>
</html>