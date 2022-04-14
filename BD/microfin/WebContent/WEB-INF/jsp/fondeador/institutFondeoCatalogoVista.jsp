<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/cuentaNostroServicio.js"></script>
<script type="text/javascript" src="dwr/interface/fondeoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/centroServicio.js"></script>
<script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/municipiosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/localidadRepubServicio.js"></script>
<script type="text/javascript" src="dwr/interface/coloniaRepubServicio.js"></script>
<script type="text/javascript" src="dwr/interface/direccionesClienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/tipoFondeadorServicio.js"></script>
<script type="text/javascript" src="js/fondeador/instFondeoCatalogo.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="instFondeo">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Instituciones de Fondeo</legend>
				<table width="100%">
					<tr>
						<td class="label">
							<label for="institucionFon">N&uacute;mero: </label>
						</td>
						<td>
							<form:input id="institutFondID" name="institutFondID" path="institutFondID" size="7" tabindex="1" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="tipoFondeador">Tipo Fondeador: </label>
						</td>
						<td>
							<form:select id="tipoFondeador" name="tipoFondeador" path="tipoFondeador" tabindex="2">
								<form:option value="">SELECCIONAR</form:option>
							</form:select>
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="cobraISR">Realiza Retenci&oacute;n: </label>
						</td>
						<td>
							<form:select id="cobraISR" name="cobraISR" path="cobraISR" tabindex="3">
								<form:option value="">SELECCIONAR</form:option>
								<form:option value="S">SI</form:option>
								<form:option value="N">NO</form:option>
							</form:select>
						</td>
						<td class="separador"></td>
						<td class="label" id="divNombre">
							<label for="nombreInstitFon">Nombre: </label>
						</td>
						<td id="divDesc">
							<form:input id="nombreInstitFon" name="nombreInstitFon" path="nombreInstitFon" size="65" tabindex="4" onBlur=" ponerMayusculas(this)" />
						</td>
						<td class="label" id="divCliente">
							<label for="clienteID"><s:message code="safilocale.cliente" />: </label>
						</td>
						<td nowrap="nowrap" id="divNomCliente">
							<form:input id="clienteID" name="clienteID" path="clienteID" size="15" tabindex="5" type="text" />
							<form:input type="text" id="nombreCliente" name="nombreCliente" size="50" tabindex="6" path="nombreCliente" onBlur=" ponerMayusculas(this)" />
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="estatus">Estatus: </label>
						</td>
						<td>
							<form:select id="estatus" name="estatus" path="estatus" tabindex="7">
								<form:option value="">SELECCIONAR</form:option>
								<form:option value="A">ACTIVO</form:option>
								<form:option value="I">INACTIVO</form:option>
							</form:select>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="razonSocInstFo" id="razonSocial">Raz&oacute;n Social: </label>
						</td>
						<td>
							<form:input id="razonSocInstFo" name="razonSocInstFo" path="razonSocInstFo" size="65" tabindex="8" onBlur=" ponerMayusculas(this)" />
						</td>
					</tr>
					<tr id="divInstitucion">
						<td class="label">
							<label for="institucionID">Instituci&oacute;n: </label>
						</td>
						<td>
							<form:input id="institucionID" name="institucionID" path="institucionID" size="7" tabindex="9" />
							<input type="text" id="nombreInstitucion" name="nombreInstitucion" size="55" disabled="true" readOnly="true" />
						</td>
					</tr>
					<tr id="divRepLegal">
						<td class="label">
							<label for="repLegal">Representante Legal: </label>
						</td>
						<td>
							<form:input id="repLegal" name="repLegal" path="repLegal" size="63" tabindex="10" onBlur=" ponerMayusculas(this)" maxlength="100" />
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="RFCl"> RFC:</label>
						</td>
						<td>
							<form:input id="RFC" name="RFC" path="RFC" maxlength="13" tabindex="11" onBlur=" ponerMayusculas(this)" />
						</td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap">
							<label for="estado">Entidad Federativa: </label>
						</td>
						<td nowrap="nowrap">
							<form:input id="estadoID" name="estadoID" path="estadoID" size="6" tabindex="12" />
							<input type="text" id="nombreEstado" name="nombreEstado" size="43" tabindex="13" disabled="true" readonly="true" />
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="municipio">Municipio: </label>
						</td>
						<td nowrap="nowrap">
							<form:input id="municipioID" name="municipioID" path="municipioID" size="6" tabindex="14" />
							<input type="text" id="nombreMuni" name="nombreMuni" size="56" tabindex="15" disabled="true" readonly="true" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="calle">Localidad: </label>
						</td>
						<td nowrap="nowrap">
							<form:input id="localidadID" name="localidadID" path="localidadID" size="6" tabindex="16" autocomplete="off" />
							<input type="text" id="nombrelocalidad" name="nombrelocalidad" size="43" tabindex="17" disabled="true" onBlur=" ponerMayusculas(this)" readonly="true" />
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="calle">Colonia: </label>
						</td>
						<td nowrap="nowrap">
							<form:input id="coloniaID" name="coloniaID" path="coloniaID" size="6" tabindex="18" />
							<input type="text" id="nombreColonia" name="nombreColonia" size="56" tabindex="19" disabled="true" onBlur=" ponerMayusculas(this)" maxlength="200" readonly="true" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="calle">Calle: </label>
						</td>
						<td nowrap="nowrap">
							<form:input id="calle" name="calle" path="calle" size="50" tabindex="20" onBlur=" ponerMayusculas(this)" maxlength="50" />
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="numero">N&uacute;mero: </label>
						</td>
						<td nowrap="nowrap">
							<form:input id="numeroCasa" name="numeroCasa" path="numeroCasa" size="5" tabindex="21" onBlur=" ponerMayusculas(this)" maxlength="9" />
							<label for="exterior">Interior: </label>
							<form:input id="numInterior" name="numInterior" path="numInterior" size="5" tabindex="22" onBlur=" ponerMayusculas(this)" maxlength="9" />
							<label for="exterior">Piso: </label>
							<form:input id="piso" name="piso" path="piso" size="5" tabindex="23" onBlur=" ponerMayusculas(this)" maxlength="9" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="primEntreCalle">Primer Entre Calle: </label>
						</td>
						<td nowrap="nowrap">
							<form:input id="primEntreCalle" name="primEntreCalle" path="primEntreCalle" size="50" tabindex="24" onBlur=" ponerMayusculas(this)" maxlength="50" />
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="segEntreCalle">Segunda Entre Calle: </label>
						</td>
						<td nowrap="nowrap">
							<form:input id="segEntreCalle" name="segEntreCalle" path="segEntreCalle" size="50" tabindex="25" onBlur=" ponerMayusculas(this)" maxlength="50" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="CP">C&oacute;digo Postal: </label>
						</td>
						<td nowrap="nowrap">
							<form:input id="CP" name="CP" path="CP" size="15" maxlength="5" tabindex="26" />
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="lblBanco">Banco:</label>
						</td>
						<td nowrap="nowrap">
							<form:input id="institucionBanc" name="institucionBanc" path="institucionBanc" size="7" tabindex="27" />
							<form:input type="text" id="descripcionInstitucion" name="descripcionInstitucion" path="descripcionInstitucion" size="55" disabled="true" readOnly="true" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="lblNumCtaBancaria">Número de Cuenta Bancaria:</label>
						</td>
						<td>
							<form:input type="text" id="numCtaInstit" name="numCtaInstit" size="38" path="numCtaInstit" tabindex="28" maxlength="18" />
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="lblCtaClabe">Cuenta Clabe: </label>
						</td>
						<td>
							<form:input id="cuentaClabe" name="cuentaClabe" path="cuentaClabe" onkeypress="return IsNumber(event)" size="24" maxlength="18" tabindex="29" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="lblnomTitu">Nombre Titular: </label>
						</td>
						<td>
							<form:input id="nombreTitular" name="nombreTitular" path="nombreTitular" size="50" maxlength="50" tabindex="30" onBlur=" ponerMayusculas(this)" />
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="lblCentroCostos">C. Costos:</label>
						</td>
						<td>
							<form:input id="centroCostos" name="centroCostos" path="centroCostos" size="7" maxlenght="7" tabindex="31" />
							<form:input type="text" id="descripcionCenCostos" name="descripcionCenCostos" path="descripcionCenCostos" size="55" tabindex="32" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label>Captura Indicadores:</label>
						</td>
						<td>
							<select MULTIPLE id="capturaIndica" name="capturaIndica" path="capturaIndica" size="5" tabindex="33">
								<option value="A">ID DE ACREDITADO</option>
								<option value="C">ID DE CRÉDITO</option>
							</select>
						</td>
					</tr>
					<tr>
						<td colspan="5" align="right">
							<input type="submit" id="agrega" name="agrega" class="submit" value="Agrega" tabindex="34" /> <input type="submit" id="modifica" name="modifica" class="submit" value="Modifica" tabindex="34" /> <input type="hidden" id="tipoTransaccion" name="tipoTransaccion" /> </a>
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
<html>