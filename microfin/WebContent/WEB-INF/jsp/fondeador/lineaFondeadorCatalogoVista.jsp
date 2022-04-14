<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>

<script type="text/javascript" src="dwr/interface/cuentasContablesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/destinosCredServicio.js"></script>
<script type="text/javascript" src="dwr/interface/condicionesDesctoActLinFonServicio.js"></script>
<script type="text/javascript" src="dwr/interface/condicionesDesctoCteLinFonServicio.js"></script>
<script type="text/javascript" src="dwr/interface/condicionesDesctoDestLinFonServicio.js"></script>
<script type="text/javascript" src="dwr/interface/condicionesDesctoEdoLinFonServicio.js"></script>
<script type="text/javascript" src="dwr/interface/fondeoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/formTipoCalIntServicio.js"></script>
<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/tiposLineaFonServicio.js"></script>
<script type="text/javascript" src="dwr/interface/cuentaNostroServicio.js"></script>
<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/lineaFonServicio.js"></script>
<script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/actividadesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/localidadRepubServicio.js"></script>
<script type="text/javascript" src="dwr/interface/municipiosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
<script type="text/javascript" src="dwr/interface/tasasBaseServicio.js"></script>
<script type="text/javascript" src="js/fondeador/lineaFondCatalogo.js"></script>
<script type="text/javascript" src="js/fondeador/lineaFondCondDesctEdoMun.js"></script>
<script type="text/javascript" src="js/fondeador/lineaFondCondDesctDest.js"></script>
<script type="text/javascript" src="js/fondeador/lineaFondCondDesctAct.js"></script>
<script type="text/javascript" src="js/utileria.js"></script>
</head>
<body>
	<%! int tabindex = 0; %>
	<div id="contenedorForma">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend class="ui-widget ui-widget-header ui-corner-all">L&iacute;nea de Fondeo</legend>
			<form:form id="formaGenerica" name="formaGenerica" method="post" commandName="lineaFondeo">
				<table border="0" width="100%">
					<tr>
						<td class="label"><label for="lineaFondeo">N&uacute;mero: </label></td>
						<td><form:input id="lineaFondeoID" name="lineaFondeoID" path="lineaFondeoID" size="7" tabindex="1" /></td>
						<td class="separador"></td>
						<td class="label"><label for="institucionFondeo">Instituci&oacute;n de Fondeo: </label></td>
						<td nowrap="nowrap"><form:input id="institutFondID" name="institutFondID" path="institutFondID" size="6" tabindex="2" /> <input type="text" id="nombreInstitFondeo" name="nombreInstitFondeo" size="30" disabled="true" /></td>
					</tr>
					<tr>
						<td class="label"><label for="razonSoc">Descripci&oacute;n: </label></td>
						<td><form:textarea id="descripLinea" name="descripLinea" path="descripLinea" rows="2" cols="30" tabindex="3" maxlength="200" onblur="ponerMayusculas(this)" /></td>
						<td class="separador"></td>
						<td class="label"><label for="tipo">Tipo de L&iacute;nea de Fondeo: </label></td>
						<td nowrap="nowrap">
							<form:input id="tipoLinFondeaID" name="tipoLinFondeaID" path="tipoLinFondeaID" size="6" tabindex="4" />
							<textarea id="desTipoLinFondea" name="desTipoLinFondea" rows="2" cols="30" onblur="ponerMayusculas(this)" readonly="readonly">
							</textarea>
						</td>
					</tr>
					<tr>
						<td class="label"><label for="monto">Monto Otorgado: </label></td>
						<td><form:input id="montoOtorgado" name="montoOtorgado" path="montoOtorgado" maxlength="14" onkeypress="return IsNumber1(event)" size="15" tabindex="5" esMoneda="true" style="text-align: right;" /></td>
						<td class="separador"></td>
						<td class="label"><label for="tipo">Saldo: </label></td>
						<td><form:input id="saldoLinea" name="saldoLinea" path="saldoLinea" size="15" tabindex="6" esMoneda="true" disabled="true" style="text-align: right;" /></td>
					</tr>
					<tr>
						<td class="label"><label for="lblCobraMora">Cobra Moratorio:</label></td>
						<td><form:select id="cobraMoratorios" name="cobraMoratorios" path="cobraMoratorios" tabindex="7">
								<form:option value="S">SI</form:option>
								<form:option value="N">NO</form:option>
							</form:select></td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap"><label for="lblDiasGraciaMora">Días Gracia Moratorios: </label></td>
						<td><form:input id="diasGraciaMora" name="diasGraciaMora" path="diasGraciaMora" size="15" tabindex="8" /></td>
					</tr>
					<tr>
						<td class="label"><label for="factor">Factor Mora: </label></td>
						<td><form:select id="tipCobComMorato" name="tipCobComMorato" path="tipCobComMorato" tabindex="9">
								<form:option value="N">N veces Tasa Ordinaria</form:option>
								<form:option value="T">Tasa Fija Anualizada</form:option>
							</form:select> <label for="lblcobraMora">Moratorio: </label> <form:input id="factorMora" name="factorMora" path="factorMora" size="5" esMoneda="true" onkeypress="return IsNumber2(event)" tabindex="10" /></td>
						<td class="separador"></td>
						<td class="carteraAgro" style="display:none;"><label>Refinancia Inter&eacute;s:</label></td>
						<td class="carteraAgro" style="display:none;"><form:select id="refinanciamiento" name="refinanciamiento" path="refinanciamiento" tabindex="11">
								<form:option value="S">S&iacute; Refinancia</form:option>
								<form:option value="N">No Refinancia</form:option>
							</form:select>
						</td>
					</tr>
					<tr class="carteraAgro" style="display:none;">
						<td class="label"><label>C&aacute;lculo de Inter&eacute;s:</label></td>
						<td><form:select id="calcInteresID" name="calcInteresID" path="calcInteresID" tabindex="12">
								<form:option value="1">TasaFija</form:option>
							</form:select></td>
						<td class="separador"></td>
						<td class="label"><label for="tasaBase">Tasa Base: </label></td>
						<td nowrap="nowrap">
							<form:input type="text" id="tasaBase" name="tasaBase" path="tasaBase" size="6" tabindex="13" />
							<input type="text" id="desTasaBase" name="desTasaBase" size="25" readonly="true"/>
						</td>
					</tr>
					<tr>
						<td class="label"><label for="monto">Tasa Pasiva: </label></td>
						<td><form:input type="text" id="tasaPasiva" name="tasaPasiva" path="tasaPasiva" maxlength="14" onkeypress="return IsNumber1(event)" size="15" tabindex="14" esTasa="true" style="text-align: right;" /><label for="monto">% </label></td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap"><label for="lblCobraFaltaPag">Cobra Falta Pago:</label></td>
						<td><form:select id="cobraFaltaPago" name="cobraFaltaPago" path="cobraFaltaPago" tabindex="15">
								<form:option value="S">SI</form:option>
								<form:option value="N">NO</form:option>
							</form:select></td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap"><label for="lblDiasGraciaFaltaPag">D&iacute;as Gracia Com. Falta Pago: </label></td>
						<td><form:input id="diasGraFaltaPag" name="diasGraFaltaPag" path="diasGraFaltaPag" onkeypress="return IsNumber(event)" size="15" tabindex="16" /></td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap"><label for="lblMontoComFaltaPag">Monto Com. Falta Pago: </label></td>
						<td><form:input id="montoComFaltaPag" name="montoComFaltaPag" maxlength="14" onkeypress="return IsNumber1(event)" path="montoComFaltaPag" esMoneda="true" size="15" tabindex="17" style="text-align: right;" /></td>
						<td class="separador"></td>
						<td class="label"><label for="lblAfectacionConta">Afectación Contable:</label></td>
						<td><form:select id="afectacionConta" name="afectacionConta" path="afectacionConta" tabindex="18">
								<form:option value="S">SI</form:option>
								<form:option value="N">NO</form:option>
							</form:select></td>
					</tr>
					<tr>
						<td class="label"><label for="lblEsRevolvente">Es Revolvente:</label></td>
						<td><form:select id="esRevolvente" name="esRevolvente" path="esRevolvente" tabindex="19">
								<form:option value="S">SI</form:option>
								<form:option value="N">NO</form:option>
							</form:select></td>
						<td class="separador"></td>
						<td class="label" id="tdlblTipoRevol"><label for="lblTipoRevol">Tipo Revolvencia: </label></td>
						<td id="tdTipoRevolvencia">
							<table border="0">
								<tr>
									<td valign="top"><input type="radio" id="tipoRevPago" name="tipoRevPago" value="P" tabindex="20" checked="checked" /></td>
									<td><label for="tipoRevPago">En cada Pago de Cuota</label></td>
									<td valign="top"><input type="radio" id="tipoRevLiq" name="tipoRevLiq" value="L" tabindex="21" /></td>
									<td><label for="tipoRevLiq">Al liquidar el Cr&eacute;dito</label> <input type="hidden" id="tipoRevNo" name="tipoRevNo" value="N" /> <form:input type="hidden" value="P" id="tipoRevolvencia" name="tipoRevolvencia" path="tipoRevolvencia" size="15" /></td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap"><label for="lblBanco">Banco:</label></td>
						<td nowrap="nowrap"><form:input id="institucionID" name="institucionID" path="institucionID" size="9" tabindex="22" />
						<input type="text" id="descripcionInstitucion" name="descripcionInstitucion" size="50" disabled="disabled" /></td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap"><label for="lblNumCtaBancaria">Número de Cuenta Bancaria:</label></td>
						<td><form:input type="text" id="numCtaInstit" name="numCtaInstit" size="38" path="numCtaInstit" tabindex="23" maxlength="18" />
						<input type="hidden" id="estatus" name="estatus" size="6" /></td>
					</tr>
					<tr>

						<td class="label" nowrap="nowrap"><label for="lblCtaClabe">Cuenta Clabe: </label></td>
						<td nowrap="nowrap"><form:input id="cuentaClabe" name="cuentaClabe" path="cuentaClabe" onkeypress="return IsNumber(event)" size="24" maxlength="24" readOnly="true" disabled="disabled" tabindex="25" /></td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap"><label for="folioFondeo">Folio Fondeo:</label></td>
						<td><form:input id="folioFondeo" name="folioFondeo" path="folioFondeo" onkeypress="" size="38" maxlength="45" onblur="ponerMayusculas(this)" tabindex="26" />
						<input type="hidden" id="reqIntegra" name="reqIntegra" value='N' size="6" /></td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap"><label for="lblMoneda">Moneda:</label></td>
						<td nowrap="nowrap"><form:input id="monedaID2" name="monedaID2" path="monedaID" size="9" tabindex="27" />
						<input type="text" id="descripcionMoneda" name="descripcionMoneda" size="50" disabled="disabled" /></td>
						<td class="separador"></td>
					</tr>
				</table>
				<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Ventana de Disposición</legend>
					<table border="0" cellpadding="0">
						<tr>
							<td class="label"><label for="FechaInc">Fecha de Inicio: </label></td>
							<td><form:input id="fechInicLinea" name="fechInicLinea" path="fechInicLinea" size="15" tabindex="28" esCalendario="true" /></td>
							<td class="separador"></td>
							<td class="label" nowrap="nowrap"><label for="FechaFin">Fecha de Fin: </label></td>
							<td nowrap="nowrap"><form:input id="fechaFinLinea" name="fechaFinLinea" path="fechaFinLinea" size="15" tabindex="29" esCalendario="true" /></td>
						</tr>
						<tr>
							<td class="label"><label for="FechaMax">Fecha Max. Vencimientos: </label></td>
							<td><form:input id="fechaMaxVenci" name="fechaMaxVenci" path="fechaMaxVenci" size="15" tabindex="30" esCalendario="true" /></td>
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="separador"></td>
						</tr>
					</table>
				</fieldset>
				<table border="0" cellpadding="0" width="100%">
					<tr>
						<td colspan="5" align="right"><input type="submit" id="agrega" name="agrega" class="submit" value="Grabar" tabindex="31" />
						<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar" tabindex="32" />
						<a id="enlace" href="poliza.htm" target="_blank">
						<button type="button" class="submit" id="impPoliza" style="display: none" tabindex="32">Ver P&oacute;liza</button>
						</a> <input type="hidden" id="tipoTransaccion" name="tipoTransaccion" /></td>
					</tr>
				</table>
			</form:form>
			<fieldset id="condiciones" class="ui-widget ui-widget-content ui-corner-all">
				<legend>Condiciones de Integraci&oacute;n</legend>
				<form:form id="formaGenerica1" name="formaGenerica1" method="post" action="/microfin/catalogoCondDesctoLineaFondeadorCte.htm" commandName="condicionesDesctoCteLinFonBean">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<table border="0" cellpadding="0">
							<tr>
								<td class="label" nowrap="nowrap"><label for="lblDiasGraciaIngCre">D&iacute;as de Gracia Ingreso Cr&eacute;dito: </label></td>
								<td><input id="diasGraIngCre" name="diasGraIngCre" path="diasGraIngCre" onkeypress="return IsNumber(event)" size="15" tabindex="33" style="text-align: right;" /></td>
							</tr>
							<tr>
								<td class="label" nowrap="nowrap"><label for="lblMonedaID">Moneda: </label></td>
								<td><select id="monedaID" name="monedaID" path="monedaID" tabindex="31">
										<option value="-1">SELECCIONAR</option>
								</select></td>
							</tr>
							<tr>
								<td class="label"><label for="lblGenero">Genero</label></td>
								<td colspan="4"><label for="lblMasculino">Masculino</label> <input type="radio" id="generoMasculino" name="generoMasculino" value="M" tabindex="33" />&nbsp;&nbsp; <label for="lblFemenino">Femenino</label> <input type="radio" id="generoFemenino" name="generoFemenino" value="F" tabindex="32" />&nbsp;&nbsp; <label for="lblGeneroIndistinto">Ambos</label> <input type="radio" id="generoIndistinto" name="generoIndistinto" value="I" tabindex="33" checked="checked" /> <input type="hidden"
									id="sexo" name="sexo" path="sexo" size="15" tabindex="34" /></td>
							</tr>
							<tr>
								<td class="label" nowrap="nowrap"><label for="pagoAu">Estado Civil: </label></td>
								<td colspan="4"><select multiple id="estadoCivil" name="estadoCivil" path="estadoCivil" tabindex="34">
										<option value="T">TODOS</option>
										<option value="S">SOLTERO</option>
										<option value="CS">CASADO BIENES SEPARADOS</option>
										<option value="CM">CASADO BIENES MANCOMUNADOS</option>
										<option value="CC">CASADO BIENES MANCOMUNADOS CON CAPITULACION</option>
										<option value="V">VIUDO</option>
										<option value="D">DIVORCIADO</option>
										<option value="SE">SEPARADO</option>
										<option value="U">UNION LIBRE</option>
								</select></td>
							</tr>
							<tr>
								<td class="label" nowrap="nowrap"><label for="lblMontoMinimo">Monto M&iacute;nimo: </label></td>
								<td><input id="montoMinimo" name="montoMinimo" path="montoMinimo" onkeypress="return IsNumber1(event)" size="15" tabindex="35" esMoneda="true" style="text-align: right;" /></td>
								<td class="separador"></td>
								<td class="label" nowrap="nowrap"><label for="lblMontoMaximo">Monto M&aacute;ximo: </label></td>
								<td><input id="montoMaximo" name="montoMaximo" path="montoMaximo" onkeypress="return IsNumber1(event)" size="15" tabindex="36" esMoneda="true" style="text-align: right;" /></td>
							</tr>
							<tr>
								<td class="label"><label for="lblproductosCre">Productos para los que Aplica: </label></td>
								<td colspan="4"><select multiple id="productosCre" name="productosCre" path="productosCre" tabindex="37" size="15">
										<option value="1">TODOS</option>
								</select></td>
							</tr>
							<tr>
								<td class="label" nowrap="nowrap"><label for="lblMaxDiasMora">Max. D&iacute;as Mora: </label></td>
								<td><input id="maxDiasMora" name="maxDiasMora" path="maxDiasMora" onkeypress="return IsNumber(event)" size="15" tabindex="38" style="text-align: right;" /></td>
							</tr>
							<tr>
								<td class="label" nowrap="nowrap"><label for="lblClasificacion">Clasificaci&oacute;n: </label></td>
								<td><label for="lblComercial">Comercial</label> <input type="radio" id="clasificacionComer" name="clasificacionComer" value="C" tabindex="39" />&nbsp;&nbsp; <label for="lblConsumo">Consumo</label> <input type="radio" id="clasificacionConsu" name="clasificacionConsu" value="O" tabindex="40" />&nbsp;&nbsp; <label for="lblHipotecario">Vivienda</label> <input type="radio" id="clasificacionHipo" name="clasificacionHipo" value="H" tabindex="41" />&nbsp;&nbsp; <label for="lblnoAplicaCla">No
										Aplica</label> <input type="radio" id="clasificacionNo" name="clasificacionNo" value="N" tabindex="42" checked="checked" /> <input type="hidden" id="clasificacion" name="clasificacion" path="clasificacion" size="15" tabindex="43" /></td>
							</tr>
						</table>
						<br>
						<table border="0" cellpadding="0" width="100%">
							<tr>
								<!-- Boton sumbit graba transaccion -->
								<td colspan="5" align="right"><input type="submit" id="grabarCte" name="grabarCte" class="submit" value="Graba" tabindex="44" /> <input type="hidden" id="tipoTransaccionCondCte" name="tipoTransaccionCondCte" /> <input type="hidden" id="lineaFondeoIDCte" name="lineaFondeoIDCte" path="lineaFondeoIDCte" size="7" tabindex="45" /></td>
							</tr>
						</table>
					</fieldset>
				</form:form>
				<br>
				<form:form id="formaGenerica2" name="formaGenerica2" method="post" action="/microfin/catalogoCondDesctoLineaFondeadorEdo.htm" commandName="condicionesDesctoEdoLinFonBean">
					<div id="gridEstadosMunLoc">
						<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<table border="0" cellpadding="0" width="100%">
								<tr>
									<td>
										<div id="gridEstadosMunLocGrid"></div>
									</td>
								</tr>
								<tr>
									<!-- Boton sumbit graba transaccion -->
									<td colspan="5" align="right"><input type="submit" id="grabarEdo" name="grabarEdo" class="submit" value="Graba" style="display: none;" disabled="disabled" /> <input type="hidden" id="tipoTransaccionEstado" name="tipoTransaccionEstado" value="1" /> <input type="hidden" id="lineaFondeoIDEdo" name="lineaFondeoIDEdo" path="lineaFondeoIDEdo" size="7" /></td>
								</tr>
							</table>
						</fieldset>
					</div>
				</form:form>
				<br>
				<form:form id="formaGenerica3" name="formaGenerica3" method="post" action="/microfin/catalogoCondDesctoLineaFondeadorDest.htm" commandName="condicionesDesctoDestLinFonBean">
					<div id="gridDestino">
						<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<table border="0" cellpadding="0" width="100%">
								<tr>
									<td>
										<div id="gridDestinoGrid"></div>
									</td>
								</tr>
								<tr>
									<!-- Boton sumbit graba transaccion -->
									<td align="right"><input type="submit" id="grabarDest" name="grabarDest" class="submit" value="Graba" style="display: none;" disabled="disabled" /> <input type="hidden" id="tipoTransaccionDestino" name="tipoTransaccionDestino" value="1" /> <input type="hidden" id="lineaFondeoIDDest" name="lineaFondeoIDDest" path="lineaFondeoIDDest" size="7" /></td>
								</tr>
							</table>
						</fieldset>
					</div>
				</form:form>
				<br>
				<form:form id="formaGenerica4" name="formaGenerica4" method="post" action="/microfin/catalogoCondDesctoLineaFondeadorAct.htm" commandName="condicionesDesctoActLinFonBean">
					<div id="gridActividades">
						<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<table border="0" cellpadding="0" width="100%">
								<tr>
									<td>
										<div id="gridActividadesGrid"></div>
									</td>
								</tr>
								<tr>
									<!-- Boton sumbit graba transaccion -->
									<td colspan="5" align="right"><input type="submit" id="grabarAct" name="grabarAct" class="submit" value="Graba" style="display: none;" disabled="disabled" /> <input type="hidden" id="tipoTransaccionAct" name="tipoTransaccionAct" /> <input type="hidden" id="lineaFondeoIDAct" name="lineaFondeoIDAct" path="lineaFondeoIDAct" size="7" /></td>
								</tr>
							</table>
						</fieldset>
					</div>
				</form:form>
			</fieldset>
		</fieldset>
	</div>

	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>