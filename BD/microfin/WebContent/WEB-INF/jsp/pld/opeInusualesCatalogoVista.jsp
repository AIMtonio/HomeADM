<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
<script type="text/javascript" src="dwr/interface/motivosInuServicio.js"></script>
<script type="text/javascript" src="dwr/interface/procInternosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/motivosPreoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/empleadosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/puestosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/categoriasServicio.js"></script>
<script type="text/javascript" src="dwr/interface/estadosPreocupantesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/opeInusualesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/archAdjuntosPLDServicio.js"></script>
<script type="text/javascript" src="js/pld/opInusuales.js"></script>
<script type="text/javascript" src="js/pld/archivosAdjPLDGrid.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="opeInusuales">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Seguimiento de Operaciones Inusuales</legend>
				<table border="0" width="100%">
					<tr>
						<td class="label">
							<label for="consecutivo">N&uacute;mero: </label>
							<form:input id="opeInusualID" name="opeInusualID" path="opeInusualID" size="12" tabindex="1" />
						</td>
					</tr>
				</table>
				<br />
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Datos Generales del Registro de la Operaci&oacute;n</legend>
					<table border="0" width="100%">
						<tr>
							<td class="label" nowrap="nowrap">
								<label for="fecha">Fecha de Captura: </label>
							</td>
							<td>
								<form:input id="fecha" name="fecha" path="fecha" size="12" tabindex="2" disabled="true" />
							</td>
						</tr>
						<tr>
							<td class="label" nowrap="nowrap">
								<label for="fechaDeteccion">Fecha Detecci&oacute;n: </label>
							</td>
							<td>
								<form:input id="fechaDeteccion" name="fechaDeteccion" path="fechaDeteccion" size="12" tabindex="2" disabled="true" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="motivo">Motivo:</label>
							</td>
							<td nowrap="nowrap">
								<form:input id="catMotivInuID" name="catMotivInuID" path="catMotivInuID" size="15" tabindex="3" disabled="true" />
								<textarea id="descripcionMotivo" name="descripcionMotivo" cols="37" rows="2" tabindex="4" readonly="true"></textarea>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="procesoInterno">Proceso Interno:</label>
							</td>
							<td nowrap="nowrap">
								<form:input id="catProcedIntID" name="catProcedIntID" path="catProcedIntID" size="12" tabindex="5" disabled="true" />
								<textarea id="descripcionProceso" name="descripcionProceso" cols="37" rows="2" tabindex="6" readonly="true"></textarea>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="personaReportar">Persona a Reportar:</label>
							</td>
							<td nowrap="nowrap">
								<form:input id="clavePersonaInv" name="clavePersonaInv" path="clavePersonaInv" size="15" tabindex="11" disabled="true" />
								<input type="hidden" id="descripcionSucursal" name="descripcionSucural" size="40" tabindex="12" disabled="true" />
								<form:input id="nomPersonaInv" name="nomPersonaInv" path="nomPersonaInv" size="51" disabled="true" />
							</td>
						</tr>
						<tr nowrap="nowrap" class="trTipoPersInv">
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="label" nowrap="nowrap">
								<label for="tipoPersonaSAFI">Tipo de Pers. a Reportar:</label>
							</td>
							<td nowrap="nowrap">
								<form:input id="tipoPersonaSAFI" name="tipoPersonaSAFI" path="tipoPersonaSAFI" size="51" disabled="true" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="frecuencia">Existe Frecuencia:</label>
							</td>
							<td>
								<form:radiobutton id="frecuencia" name="frecuencia" tabindex="12" path="frecuencia" disabled="true" value="S" />
								<label for="frecuenciaS">Si</label>
								<form:radiobutton id="frecuencia2" name="frecuencia2" tabindex="13" path="frecuencia" disabled="true" value="N" checked="checked" />
								<label for="frecuenciaN">No</label>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="describirFrecuencia" id="descripcionF" style="display: none">Frecuencia:</label>
							</td>
							<td>
								<form:textarea id="desFrecuencia" name="desFrecuencia" cols="50" rows="2" path="desFrecuencia" tabindex="14" readonly="true" style="display: none" onBlur=" ponerMayusculas(this)" maxlength="150" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="InvolucraEmpleado">Involucra Empleado:</label>
							</td>
							<td nowrap="nowrap">
								<input id="involucraEmpleado" type="radio" name="involucraEmpleado" tabindex="15" value="S" iniforma="false" disabled="true" /> <label for="si">Si</label> <input id="involucraEmpleado2" type="radio" name="involucraEmpleado2" tabindex="16" value="N" disabled="true" checked="checked" /> <label for="no">No</label>
							</td>
							<td class="separador"></td>
							<td class="label" nowrap="nowrap">
								<label for="EmpleadoInvolucrado" id="empleadoInv" style="display: none">Nombre del Empleado:</label>
							</td>
							<td>
								<form:input id="empInvolucrado" name="empInvolucrado" path="empInvolucrado" size="51" tabindex="17" disabled="true" style="display: none" />
							</td>
						</tr>
						<tr>
							<td class="label" nowrap="nowrap">
								<label for="credito" id="credito" style="display: none">N&uacute;m. Cr&eacute;dito:</label>
							</td>
							<td>
								<form:input id="creditoID" name="creditoID" path="creditoID" size="15" tabindex="18" disabled="true" style="display: none" />
							</td>
							<td class="separador"></td>
							<td class="label" nowrap="nowrap">
								<label for="cuenta" id="cuenta" style="display: none">N&uacute;m. Cuenta:</label>
							</td>
							<td>
								<form:input id="cuentaAhoID" name="cuentaAhoID" path="cuentaAhoID" size="15" tabindex="19" disabled="true" style="display: none" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="transaccion" id="transaccion" style="display: none">N&uacute;m Transacci&oacute;n:</label>
							</td>
							<td>
								<form:input id="transaccionOpe" name="transaccionOpe" path="transaccionOpe" size="15" tabindex="19" disabled="true" style="display: none" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="naturaleza" id="naturaleza" style="display: none">Naturaleza:</label>
							</td>
							<td>
								<form:select id="naturaOperacion" name="naturaOperacion" path="naturaOperacion" tabindex="20" disabled="true" style="display: none">
									<form:option value="C">CARGO</form:option>
									<form:option value="A">ABONO</form:option>
								</form:select>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="monto" id="monto" style="display: none">Monto:</label>
							</td>
							<td>
								<form:input id="montoOperacion" name="montoOperacion" path="montoOperacion" size="15" tabindex="21" disabled="true" style="display: none" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="moneda" id="moneda" style="display: none">Moneda: </label>
							</td>
							<td nowrap="nowrap">
								<form:input id="monedaID" name="monedaID" path="monedaID" size="15" tabindex="22" disabled="true" style="display: none" />
								<input id="desMoneda" name="desMoneda" size="35" tabindex="22" readonly="true" onBlur=" ponerMayusculas(this)" style="display: none" />
							</td>
						</tr>
					</table>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="label">
								<label for="descripcion">Descripci&oacute;n:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;</label>
								<form:textarea id="desOperacion" name="desOperacion" cols="100" rows="5" path="desOperacion" tabindex="23" maxlength="300" readonly="true" onBlur=" ponerMayusculas(this)" />
							</td>
						</tr>
					</table>
					<br>
					<div id="ActividadesOC"></div>
				</fieldset>
				<br />
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Datos Adicionales</legend>
					<table>
						<tr>
							<td class="label" nowrap="nowrap">
								<label>Forma de Pago:</label>
							</td>
							<td>
								<select id="formaPago" name="formaPago" tabindex="24" disabled="true">
									<option value="">SELECCIONAR</option>
									<option value="E">EFECTIVO</option>
									<option value="H">CHEQUE</option>
									<option value="T">TRANSFERENCIA</option>
									<option value="C">CARGO A CUENTA</option>
								</select>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label>Edad:</label>
							</td>
							<td nowrap="nowrap">
								<input id="edad" name="edad" readonly="true" size="5" /> <label>&nbsp;años</label>
							</td>
						</tr>
						<tr>
							<td class="label" nowrap="nowrap">
								<label> Ocupaci&oacute;n del Cliente: </label>
							</td>
							<td>
								<textarea id="ocupacionCli" name="ocupacionCli" readonly="true" cols="45"></textarea>
							</td>
							<td class="separador"></td>
							<td class="label" nowrap="nowrap">
								<label>Fecha Nacimiento:</label>
							</td>
							<td>
								<input id="fechaNacimiento" name="fechaNacimiento" readonly="true" size="12" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label> Clasificaci&oacute;n del Cliente: </label>
							</td>
							<td>
								<input id="clasificacionCTE" name="clasificacionCTE" readonly="true" size="28" />
							</td>
							<td class="separador"></td>
							<td class="label" nowrap="nowrap">
								<label>Estado Civil:</label>
							</td>
							<td>
								<input id="estadoCivil" name="estadoCivil" readonly="true" size="40" />
							</td>
						</tr>
						<tr>
							<td class="label" nowrap="nowrap">
								<label>No. Sucursal Cliente:</label>
							</td>
							<td>
								<input id="sucursalIDCli" name="sucursalIDCli" readonly="true" size="12" />
							</td>
							<td class="separador"></td>
							<td class="label" nowrap="nowrap">
								<label>Localidad:</label>
							</td>
							<td>
								<textarea id="localidad" name="localidad" readonly="true"></textarea>
							</td>
						</tr>
						<tr>
							<td class="label" nowrap="nowrap">
								<label> Nombre Sucursal Cliente: </label>
							</td>
							<td>
								<input id="nombreSucursalCli" name="nombreSucursalCli" readonly="true" size="50" />
							</td>
						</tr>
						<tr>
							<td class="label" nowrap="nowrap">
								<label>Nivel de Estudios <br>del <s:message code="safilocale.cliente" />:
								</label>
							</td>
							<td>
								<input id="nivelEstudios" name="nivelEstudios" readonly="true" size="28" />
							</td>
							<td class="separador"></td>
							<td class="label" nowrap="nowrap">
								<label>Producto de Cr&eacute;dito:</label>
							</td>
							<td>
								<input id="productoCredito" name="productoCredito" readonly="true" size="70" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label>Ingreso Mensual en Conocimiento:</label>
							</td>
							<td>
								<input id="ingresoMensual" name="ingresoMensual" readonly="true" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="grupoNoSolidadario">Grupo No. Solidiario:</label>
							</td>
							<td>
								<input id="grupoNoSolidadario" name="grupoNoSolidadario" size="70" readonly="true" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="montoMenSocie">Ingreso Mensual <br>Socioecon&oacute;mico:
								</label>
							</td>
							<td>
								<input id="montoMenSocie" name="montoMenSocie" readonly="true" />
							</td>
							<td class="separador"></td>
							<td class="label"></td>
							<td></td>
						</tr>
					</table>
				</fieldset>
				<table style="width: 100%">
					<tr>
						<td>
							<div id="gridArchivos" style="width: 100%"></div>
						</td>
					</tr>
					<tr>
						<td class="label" style="text-align: right;" colspan="5">
							<input type="button" id="adjuntar" name="adjuntar" class="submit" tabindex="84" value="Adjuntar" />
						</td>
					</tr>
				</table>
				<div id="gridCredLiquidados" style="display: none;"></div>
				<br />
				<div id="gridMovimientosCuenta" style="display: none;"></div>
				<br />
				<div id="gridAhoCte" style="display: none;"></div>
				<br />
				<div id="gridInvCte" style="display: none;"></div>
				<br />
				<div id="gridCredCte" style="display: none;"></div>
				<div id="gridCreditosAvalados" style="display: none;"></div>
				<p>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<br>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="label">
								<label for="estatus">Estado del Registro:</label>
							</td>
							<td>
								<form:select id="estatus" name="estatus" path="estatus" tabindex="25" disabled="true">
									<form:option value="-1">SELECCIONAR</form:option>
								</form:select>
							</td>
							<td>
								<input type="hidden" id="estatusAux" name="statusAux" size="3" tabindex="26" />
							</td>
							<td></td>
							<td class="separador"></td>
							<td class="label">
								<label for="fechaCierre">Fecha de Cierre:</label>
								<form:input id="fechaCierre" name="fechaCierre" path="fechaCierre" tabindex="27" size="12" disabled="true" />
						</tr>
						<tr>
							<td class="label">
								<label for="comentarioOC">Comentario OC:</label>
							<td>
								<form:textarea id="comentarioOC" name="comentarioOC" cols="60" rows="2" path="comentarioOC" tabindex="28" readonly="true" onBlur=" ponerMayusculas(this)" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<br> <label for="personaReportar2" id="personaReportar2" style="display: none"> Confirmar Persona <br>a Reportar:
								</label>
							</td>
							<td>
								<br>
								<form:input id="clavePersonaInv2" name="clavePersonaInv2" path="auxClavePersonaInv" size="12" tabindex="29" style="display: none" />
								<form:input id="nomPersonaInv2" name="nomPersonaInv2" path="auxNomPersonaInv" size="51" style="display: none" readonly="true" />
							</td>
						</tr>
					</table>
				</fieldset>
				<table align="right">
					<tr>
						<td align="right">
							<input type="submit" id="grabar" name="grabar" class="submit" tabIndex="30" value="Actualizar" /> <input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
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
	<div id="imagenCte" style="display: none;"></div>
</body>
</html>