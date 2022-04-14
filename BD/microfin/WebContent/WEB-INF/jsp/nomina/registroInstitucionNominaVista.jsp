<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript"	src="dwr/interface/TiposMovTesoServicioScript.js"></script>
		<script type="text/javascript"	src="dwr/interface/cuentasContablesServicio.js"></script>
		<script type="text/javascript"	src="dwr/interface/cuentaNostroServicio.js"></script>
		<script type="text/javascript"	src="dwr/interface/conveniosNominaServicio.js"></script>
		<script type="text/javascript"	src="dwr/interface/cuentaNostroServicio.js"></script>
		<script type="text/javascript"	src="dwr/interface/clienteServicio.js"></script>
		<script type="text/javascript"	src="dwr/interface/institucionesServicio.js"></script>
		<script type="text/javascript"	src="dwr/interface/institucionNomServicio.js"></script>
		<script type="text/javascript" src="js/soporte/mascara.js"></script>
		<script type="text/javascript" src="js/nomina/registroInstitucionNomina.js"></script>
		<script type="text/javascript" src="js/nomina/conveniosNomina.js"></script>

	</head>
	<body>
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Alta de Empresa de N&oacute;mina</legend>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="institucionNominaBean">
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="label">
								<label for="lblNumero">N&uacute;mero:</label>
							</td>
							<td>
	       		 				<input type="text" id="institNominaID" name="institNominaID" size="7" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="lblNumero">Empresa N&oacute;mina:</label>
							</td>
							<td>
								<input type="text" id="nombreInstit" name="nombreInstit" onBlur=" ponerMayusculas(this)" size="77" maxlength="100" />
							</td>

							<td class="separador"></td>
							<td class="lable">
								<label for="lblCorreo">Domicilio:</label>
							</td>
							<td>
								<input type="text" id="domicilio" name="domicilio" size="60"  onBlur="ponerMayusculas(this)"  maxlength="199"/>
							</td>

						</tr>

						<tr>
							<td class="label">
								<label for="lblCliente"><s:message code="safilocale.cliente"/>:</label>
							</td>
							<td>
								<input type="text" id="clienteID" name="clienteID" size="11" />
								<input type="text" id="nombreCliente" name="nombreCliente" readOnly="true" size="60" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="lblContacto">Nombre de Contacto:</label>
							</td>
							<td>
								<input type="text" id="contactoRH" name="contactoRH" onBlur="ponerMayusculas(this)" size="60" maxlength="100"/>
							</td>


						</tr>
						<tr>
							<td class="label">
								<label for="lblTelefono">Tel&eacute;fono de Contacto:</label>
							</td>
							<td>
								<input type="text" id="telContactoRH" name="telContactoRH" size="15" maxlength="10" />
								<label for="lblTelefono">Ext.:</label>
								<input type="text" id="extTelContacto" name="extTelContacto" size="10"  maxlength="6" />

							</td>
							<td class="separador"></td>
							<td class="lable">
								<label for="lblCorreo">Correo Electr&oacute;nico:</label>
							</td>
							<td>
								<input type="text" id="correo" name="correo" size="25"  maxlength="100"/>
							</td>
						</tr>

						<tr>
								<td class="label">
								<label for="lblInstitucion">Instituci&oacute;n Bancaria:</label>
							</td>
							<td>
								<form:input type="text" id="institucionID" name="institucionID" path="institucionID" size="11"/>
								<input type="text" id="nombreInstitucion" name="nombreInstitucion" readOnly="true" size="60"  />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="lblCuenta">Cuenta Bancaria:</label>
							</td>
							<td>
								<input type="text" id="numCtaInstit" name="numCtaInstit"  maxlength="18"  size="25" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="lblReqVerificacion">Requiere Verificaci&oacute;n:</label>
							</td>
							<td>
								<form:radiobutton id="reqVerificacion" name="reqVerificacion" path="reqVerificacion" value="S" />
								<label for="s">Si</label>
								<form:radiobutton id="reqVerificacion1" name="reqVerificacion1" path="reqVerificacion" value="N" />
								<label for="N">No</label>
							</td>
<td class="separador"></td>
							<td class="label">
								<label for="lblReqVerificacion">Especifica Cta. Contable en Tr&aacute;nsito:</label>
							</td>
							<td>
								<form:radiobutton id="espCtaConSi" name="espCtaConSi" path="espCtaCon" value="S" tabindex="12" />
								<label for="s">Si</label>
								<form:radiobutton id="espCtaConNo" name="espCtaConNo" path="espCtaCon" value="N" tabindex="13" />
								<label for="N">No</label>
							</td>		
						</tr>
						<tr id="cuentaMov">
							<td class="label">
								<label for="lblCuenta">Cuenta Contable:</label>
							</td>
							<td> 
								<input type="text" id="numCtaContable" name="numCtaContable"  maxlength="18"  size="73" tabindex="14" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="lblInstitucion">Tipo de Movimiento:</label>
							</td>
							<td> 
								<form:input type="text" id="tipoMovID" name="tipoMovID" path="tipoMovID" size="11" tabindex="15"/>
								<input type="text" id="descMovimiento" name="descMovimiento" readOnly="true" size="40"  />	
							</td>
						</tr>
						<tr id="aplicaTabla" style="display: none;">
							<td class="label">
								<label for="lblReqVerificacion">Aplica Tabla Real:</label>
							</td>
							<td>
								<form:radiobutton id="aplicaTablaSi" name="aplicaTablaSi" path="aplicaTabla" value="S" tabindex="16" />
								<label for="s">Si</label>
								<form:radiobutton id="aplicaTablaNo" name="aplicaTablaNo" path="aplicaTabla" value="N" tabindex="17" />
								<label for="N">No</label>
							</td>
						</tr>
					</table>
					<br>
				<table border="0" cellpadding="2" cellspacing="0" width="100%">
					<tr>
						<td align="right">
							<input type="submit" id="agregar" name="agregar" class="submit" value="Agregar"  />
							<input type="submit" id="modificar" name="modificar" class="submit" value="Modificar"  />
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
							<input type="hidden" id="tipoActualizacion" name="tipoActualizacion"/>
						</td>
					</tr>
				</table>
		</form:form>
		<form id="formaGenerica2" name="formaGenerica2" method="POST" action="/microfin/conveniosNominaVista.htm" commandName="convenioNominaBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend>Convenio de N&oacute;mina</legend>
				<table border="0" width="950px">
					<tbody>
						<tr>
							<td class="label">
								<label>No. Convenio:</label>
							</td>
							<td>
								<input type="hidden" id="empresaNomina" name="institNominaID" value="" />
								<input type="text" id="convenioNominaID" name="convenioNominaID" value="" size="5" maxlength="10">
								<input type="text" id="descripcion" name="descripcion" size="45" maxlength="150" onblur="ponerMayusculas(this);">
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="puesto">Fecha Registro:</label>
							</td>
							<td>
								<input type="text" id="fechaRegistro" name="fechaRegistro" size="10" maxlength="10" escalendario="true">
							</td>
						</tr>

						<tr>
							<td class="label">
								<label for="lblReqVerificacion">Maneja Vencimiento:</label>
							</td>
							<td>
								<input type="radio" id="manejaVencimiento" name="manejaVencimiento" value="S"/>
								<label>Sí</label>
								<input type="radio" id="manejaVencimiento1" name="manejaVencimiento" value="N"/>
								<label>No</label>
							</td>

							<td class="separador"></td>
							<td class="label" class="fechaVencimiento">
								<label for="puesto" class="fechaVencimiento">Fecha Vencimiento:</label>
							</td>
							<td class="fechaVencimiento">
								<input type="text" id="fechaVencimiento" name="fechaVencimiento" size="10" maxlength="10" escalendario="true">
							</td>
						</tr>

						<tr>
							<td class="label">
								<label for="lblReqVerificacion">Domiciliaci&oacute;n de pago:</label>
							</td>
							<td>
								<input type="radio" id="domiciliacionPagos" name="domiciliacionPagos" value="S"/>
								<label>Sí</label>
								<input type="radio" id="domiciliacionPagos1" name="domiciliacionPagos" value="N"/>
								<label>No</label>
							</td>
							<td class="separador"></td>
							<td class="noCuotasCobrar" class="label">
								<label for="noCuotasCobrar">No. Cuotas a Cobrar:</label>
							</td>
							<td class="noCuotasCobrar">
								<input type="text" id="noCuotasCobrar" name="noCuotasCobrar" path="noCuotasCobrar"  size="10"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="puesto">Clave Convenio:</label>
							</td>
							<td>
								<input type="text" id="claveConvenio" name="claveConvenio" size="20" maxlength="20">
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="lblReqVerificacion">Estatus:</label>
							</td>
							<td>
								<select name="estatus" id="estatus" path="estatus" tabindex="26">
									<option value="">SELECCIONAR</option>
									<option value="A">ACTIVO</option>
									<option value="S">SUSPENDIDO</option>
									<option value="V">VENCIDO</option>
								</select>
								<input type="hidden" id="estatusActual" name="estatusActual" value=""/>
							</td>
						</tr>

						<tr>
							<td class="label">
								<label for="puesto">Resguardo:</label>
							</td>
							<td>
								<input type="text" id="resguardo" name="resguardo"  size="15" esMoneda="true" maxlength="13">
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="lblReqVerificacion">No. Actualizaciones:</label>
							</td>
							<td>
								<input type="text" id="numActualizaciones" name="numActualizaciones"  size="5" maxlength="5">
							</td>							
						</tr>

						<tr>
							<td class="label" nowrap="nowrap">
								<label for="puesto">Maneja Capacidad de Pago:</label>
							</td>
							<td  class="label"  nowrap="nowrap">
								<input type="radio" id="manejaCapPagoSi" name="manejaCapPago" value="S"/>
								<label for="manejaCapPagoSi">Sí</label>
								<input type="radio" id="manejaCapPagoNo" name="manejaCapPago" value="N"/>
								<label for="manejaCapPagoNo">No</label>
							</td>
							<td class="separador"></td>
							<td class="label" nowrap="nowrap">
							</td>
							<td>
							</td>
						</tr>

						<tr id="trformulaCapacidadPag">
							<td class="label" nowrap="nowrap">
								<label for="lblFormCapPago">F&oacute;rmula Capacidad de pago:</label>
							</td>
							<td nowrap="nowrap">
								<input type="hidden" id="formCapPago" name="formCapPago" />
								<textarea id="desFormCapPago" name="desFormCapPago"  onblur="ponerMayusculas(this);" rows="4" maxlength="500" cols="50" readonly="true"></textarea>
								<input type="button" name="agregarFormCap" id="agregarFormCap"  class="btnEditarForm" onclick="crearFormula(this);"></input>
							</td>
							<td class="separador"></td>
							<td class="label" nowrap="nowrap">
								<label for="lblFormCapPagoRes">F&oacute;rmula Capacidad de Pago Renovaci&oacute;n, </br> Reestructura o Consolidaci&oacute;n:</label>
							</td>
							<td nowrap="nowrap">
								<input type="hidden" id="formCapPagoRes" name="formCapPagoRes" />
								<textarea id="desFormCapPagoRes" name="desFormCapPagoRes"   onblur="ponerMayusculas(this);" rows="4" maxlength="500" cols="50" readonly="true"></textarea>
								<input type="button" name="agregarFormCapRes" id="agregarFormCapRes"  class="btnEditarForm" onclick="crearFormula(this);"></input>
							</td>
						</tr>

						<tr>
							<td class="label">
								<label for="lblReqVerificacion">Requiere Folio:</label>
							</td>
							<td>
								<input type="radio" id="requiereFolio" name="requiereFolio" value="S"/>
								<label>Sí</label>
								<input type="radio" id="requiereFolio1" name="requiereFolio" value="N"/>
								<label>No</label>
							</td>
							<td class="separador"></td>
							<td class="label manejaQuinquenios">
								<label for="puesto" class="manejaQuinquenios">Maneja Quinquenios:</label>
							</td>
							<td class="manejaQuinquenios">
								<input type="radio" id="manejaQuinquenios" name="manejaQuinquenios" value="S"/>
								<label>Sí</label>
								<input type="radio" id="manejaQuinquenios1" name="manejaQuinquenios" value="N"/>
								<label>No</label>
							</td>
						</tr>

						<tr>
							<td class="label">
								<label for="lblReqVerificacion">Maneja Calendario:</label>
							</td>
							<td>
								<input type="radio" id="manejaCalendario" name="manejaCalendario" value="S"/>
								<label>Sí</label>
								<input type="radio" id="manejaCalendario1" name="manejaCalendario" value="N"/>
								<label>No</label>
							</td>
							<td class="separador"></td>
							<td class="label" class="menejaFechaIniCal">
								<label for="puesto" class="menejaFechaIniCal">Maneja Fecha de Inicio Calendario:</label>
							</td>
							<td class="menejaFechaIniCal">
								<input type="radio" id="manejaFechaIniCal" name="manejaFechaIniCal" value="S"/>
								<label>Sí</label>
								<input type="radio" id="manejaFechaIniCal1" name="manejaFechaIniCal" value="N"/>
								<label>No</label>
							</td>
						</tr>
						<tr>
							<td class="label" class="reportaIncidencia">
								<label for="puesto" class="reportaIncidencia">Reporta Incidencias:</label>
							</td>
							<td class="reportaIncidencia">
								<input type="radio" id="reportaIncidencia" name="reportaIncidencia" value="S"/>
								<label>Sí</label>
								<input type="radio" id="reportaIncidencia1" name="reportaIncidencia" value="N"/>
								<label>No</label>
							</td>
							<td class="separador"></td>
							<td class="label" nowrap="nowrap">
							</td>
							<td>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="lblCobraComisionApertura">Cobra Comisión por Apertura:</label>
							</td>
							<td>
								<input type="radio" id="cobraComisionApertSi" name="cobraComisionApert" value="S"/>
								<label>Sí</label>
								<input type="radio" id="cobraComisionApertNo" name="cobraComisionApert" value="N"/>
								<label>No</label>
							</td>
							<td class="separador"></td>
							<td class="label" class="cobraMora">
								<label for="lblCobraMora" class="cobraMora">Cobra Mora:</label>
							</td>
							<td class="cobraMora">
								<input type="radio" id="cobraMoraSi" name="cobraMora" value="S"/>
								<label>Sí</label>
								<input type="radio" id="cobraMoraNo" name="cobraMora" value="N"/>
								<label>No</label>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label>Ejecutivo:</label>
							</td>
							<td>
								<input type="text" id="usuarioID" name="usuarioID" value="" size="5" maxlength="10">
								<input type="text" id="nombreCompleto" name="nombreCompleto" size="35" disabled="true">
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="puesto">Correo Ejecutivo:</label>
							</td>
							<td>
								<input type="text" id="correoEjecutivo" name="correoEjecutivo" size="20" maxlength="200">
							</td>
						</tr>

						<tr>
			     			<td class="label">
								<label for="lblComentario">Comentarios: </label>
							</td>
			     			<td>
			      				<textarea id="comentario" name="comentario"  onblur="ponerMayusculas(this);" rows="4" maxlength="150" cols="50"></textarea>
			     			</td>
						</tr>
					</tbody>
				</table>

				<table border="0" cellpadding="2" cellspacing="0" width="100%">
					<tr>
						<td align="right">
							<input type="submit" id="grabarConv" name="grabarConv" class="submit" value="Grabar" tabindex="35"/>
							<input type="submit" id="modificarConv" name="modificarConv" class="submit" value="Modificar" tabindex="36"/>
							<input type="hidden" id="tipoTransaccionConv" name="tipoTransaccionConv"/>
						</td>
					</tr>
				</table>
			</fieldset>
		</form>
		</div>
		</fieldset>
	<div id="cargando" style="display: none;">
	</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>