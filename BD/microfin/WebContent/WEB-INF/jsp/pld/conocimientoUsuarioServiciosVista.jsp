<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>

<head>
	<script type="text/javascript" src="dwr/interface/usuarioServicios.js"></script>
	<script type="text/javascript" src="dwr/interface/conocimientoUsuarioServicios.js"></script>
	<script type="text/javascript" src="dwr/interface/parentescosServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/funcionesPubServicio.js"></script>

	<script type="text/javascript" src="js/pld/conocimientoUsuarioServicios.js"></script>
</head>

<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="conocimientoUsuarioBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Conocimiento del Usuario de Servicio</legend>

				<table width="100%" style="margin-top: .5em;">
					<tr>
						<td class="label">
							<label for="usuarioID">No. de Usuario: </label>
						</td>
						<td>
							<form:input id="usuarioID" name="usuarioID" path="usuarioID" size="12" autocomplete="off" tabindex="1"/>
							<input type="text" id="nombreUsuario" name="nombreUsuario" size="60" disabled="true" readonly="true"/>
						</td>
					</tr>
				</table>
				<br>

				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="label">En caso de pertenecer a una sociedad, grupo o filial</legend>

					<table width="100%">
						<tr>
							<td class="label">
								<label for="nombreGrupo">Nombre: </label>
							</td>
							<td>
								<form:input id="nombreGrupo" name="nombreGrupo" path="nombreGrupo" onBlur="ponerMayusculas(this)" size="50" maxlength="100" tabindex="2"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="RFC">RFC o Similar: </label>
							</td>
							<td>
								<form:input id="RFC" name="RFC" path="RFC" size="20" onBlur="ponerMayusculas(this)" maxlength="13" tabindex="3"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="participacion">Participaci&oacute;n: </label>
							</td>
							<td>
								<form:input id="participacion" name="participacion" path="participacion" size="15" esMoneda="true" style="text-align: right;" tabindex="4"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="nacionalidad">Nacionalidad: </label>
							</td>
							<td>
								<form:input id="nacionalidad" name="nacionalidad" path="nacionalidad" size="20" onBlur="ponerMayusculas(this)" maxlength="45" tabindex="5"/>
							</td>
						</tr>
					</table>
				</fieldset>
				<br>

				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="label">En caso de tener Actividad Empresarial</legend>
					<table width="100%" id="tablaActividadEmp">
						<tr>
							<td class="label">
								<label for="razonSocial">Raz&oacute;n Social: </label>
							</td>
							<td>
								<form:input id="razonSocial" name="razonSocial" path="razonSocial" onBlur="ponerMayusculas(this)" size="50" maxlength="150" tabindex="6"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="giro">Giro o Actividad Empresarial: </label>
							</td>
							<td>
								<form:input id="giro" name="giro" path="giro" size="45" onBlur="ponerMayusculas(this)" maxlength="150" tabindex="7"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="aniosOperacion">Años de Operaci&oacute;n: </label>
							</td>
							<td>
								<form:input id="aniosOperacion" name="aniosOperacion" path="aniosOperacion" size="5" style="text-align: right;" maxlength="2"
								onkeypress="return validaNumero(event, 'entero')" tabindex="8"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="aniosGiro">Años en el Giro: </label>
							</td>
							<td>
								<form:input id="aniosGiro" name="aniosGiro" path="aniosGiro" size="5" style="text-align: right;" maxlength="2"
								onkeypress="return validaNumero(event, 'entero')" tabindex="9"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="PEPsSI">PEP's: </label>
							</td>
							<td class="label" id="tdPEPs">
								<form:radiobutton id="PEPsSI" name="PEPs" path="PEPs" value="S" tabindex="10"/>
								<label for="PEPsSI">Si</label>&ensp;
								<form:radiobutton id="PEPsNO" name="PEPs" path="PEPs" value="N" checked="checked" tabindex="11"/>
								<label for="PEPsNO">No</label>&ensp;&emsp;
								<input type="button" id="btnDefinicionPEP" value="Definici&oacute;n PEP" class="submit" tabindex="12"/>
							</td>
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="separador"></td>
						</tr>
						<tr class="camposFuncion" style="display: none;">
							<td class="label">
								<label for="funcionID">Funci&oacute;n P&uacute;blica: </label>
							</td>
							<td>
								<form:input id="funcionID" name="funcionID" path="funcionID" size="5" tabindex="13" />
								<input type="text" id="funcionDescripcion" name="funcionDescripcion" size="60" disabled="true" readOnly="true" />
							</td>
						</tr>
						<tr class="camposFuncion" style="display: none;">
							<td class="label">
								<label for="fechaNombramiento">Fecha de nombramiento: </label>
							</td>
							<td>
								<form:input id="fechaNombramiento" name="fechaNombramiento" path="fechaNombramiento" esCalendario="true" maxlength="12" tabindex="14"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="porcentajeAcciones">Porcentaje de acciones (En %): </label>
							</td>
							<td>
								<form:input id="porcentajeAcciones" name="porcentajeAcciones" path="porcentajeAcciones" size="15" esMoneda="true" tabindex="15"
								style="text-align: right;" maxlength="6" onkeypress="return validaNumero(event, 'decimal')"/>
							</td>
						</tr>
						<tr class="camposFuncion" style="display: none;">
							<td class="label">
								<label for="periodoCargo">Periodo del cargo: </label>
							</td>
							<td>
								<form:input id="periodoCargo" name="periodoCargo" path="periodoCargo" size="60" maxlength="100" tabindex="16"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="montoAcciones">Monto de las acciones (En $): </label>
							</td>
							<td>
								<form:input id="montoAcciones" name="montoAcciones" path="montoAcciones" size="15" esMoneda="true" tabindex="17"
								style="text-align: right;" maxlength="15" onkeypress="return validaNumero(event, 'decimal')"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="parentescoPEPSI">Parentesco con PEP: </label>
							</td>
							<td class="label" id="tdParentescoPEP">
								<form:radiobutton id="parentescoPEPSI" name="parentescoPEP" path="parentescoPEP" value="S" tabindex="18"/>
								<label for="parentescoPEPSI">Si</label>&ensp;
								<form:radiobutton id="parentescoPEPNO" name="parentescoPEP" path="parentescoPEP" value="N" checked="checked" tabindex="19"/>
								<label for="parentescoPEPNO">No</label>
							</td>
						</tr>
						<tr class="camposDatosFamiliares" style="display: none;">
							<td class="label">
								<label for="nombreFamiliar">Nombre del Familiar: </label>
							</td>
							<td>
								<form:input id="nombreFamiliar" name="nombreFamiliar" path="nombreFamiliar" size="25" onBlur="ponerMayusculas(this)" maxlength="50" tabindex="20"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="aPaternoFamiliar">Apellido Paterno: </label>
							</td>
							<td>
								<form:input id="aPaternoFamiliar" name="aPaternoFamiliar" path="aPaternoFamiliar" size="25" onBlur="ponerMayusculas(this)" maxlength="50" tabindex="21"/>
							</td>
						</tr>
						<tr class="camposDatosFamiliares" style="display: none;">
							<td class="label">
								<label for="aMaternoFamiliar">Apellido Materno: </label>
							</td>
							<td>
								<form:input id="aMaternoFamiliar" name="aMaternoFamiliar" path="aMaternoFamiliar" size="25" onBlur="ponerMayusculas(this)" maxlength="50" tabindex="22"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="numeroEmpleados">No. Empleados: </label>
							</td>
							<td>
								<form:input id="numeroEmpleados" name="numeroEmpleados" path="numeroEmpleados" size="10" maxlength="5"
								onkeypress="return validaNumero(event, 'entero')" tabindex="23"/>
							</td>
							<td class="separador"></td>
							<td class="label" nowrap="nowrap">
								<label for="serviciosProductos">Principales Servicios o Productos: </label>
							</td>
							<td>
								<form:input id="serviciosProductos" name="serviciosProductos" path="serviciosProductos" size="45" onBlur="ponerMayusculas(this)" maxlength="50" tabindex="24"/>
							</td>
						</tr>
						<tr>
							<td class="label" style="vertical-align: text-top;">
								<label for="coberturaGeografica">Cobertura Geogr&aacute;fica: </label>
							</td>
							<td class="label" id="tdCobGeografica">
								<form:radiobutton id="coberturaGeografica1" name="coberturaGeografica" path="coberturaGeografica" value="L" checked="checked" tabindex="25"/>
								<label for="coberturaGeografica1">Local</label>&ensp;
								<form:radiobutton id="coberturaGeografica2" name="coberturaGeografica" path="coberturaGeografica" value="E" tabindex="26"/>
								<label for="coberturaGeografica2">Estatal</label>&ensp;
								<form:radiobutton id="coberturaGeografica3" name="coberturaGeografica" path="coberturaGeografica" value="R" tabindex="27"/>
								<label for="coberturaGeografica3">Regional</label> <br>
								<form:radiobutton id="coberturaGeografica4" name="coberturaGeografica" path="coberturaGeografica" value="N" style="margin-top: .7em;" tabindex="28"/>
								<label for="coberturaGeografica4">Nacional</label>&ensp;
								<form:radiobutton id="coberturaGeografica5" name="coberturaGeografica" path="coberturaGeografica" value="I" style="margin-top: .7em;" tabindex="29"/>
								<label for="coberturaGeografica5">Internacional</label>
							</td>
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="separador"></td>
						</tr>
						<tr>
							<td class="label" nowrap="nowrap">
								<label for="estadosPresencia">Estados con Presencia: </label>
							</td>
							<td>
								<form:input id="estadosPresencia" name="estadosPresencia" path="estadosPresencia" size="15" onBlur="ponerMayusculas(this)" maxlength="2"
								onkeypress="return validaNumero(event, 'entero')" tabindex="30"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="importeVentas">Importe de Ventas: </label>
							</td>
							<td>
								<form:input id="importeVentas" name="importeVentas" path="importeVentas" size="15" esMoneda="true" style="text-align: right;"
								onkeypress="return validaNumero(event, 'decimal')" tabindex="31"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="activos">Activos: </label>
							</td>
							<td>
								<form:input id="activos" name="activos" path="activos" size="15" esMoneda="true" style="text-align: right;" tabindex="32"
								onkeypress="return validaNumero(event, 'decimal')"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="pasivos">Pasivos: </label>
							</td>
							<td>
								<form:input id="pasivos" name="pasivos" path="pasivos" size="15" esMoneda="true" style="text-align: right;" tabindex="33"
								onkeypress="return validaNumero(event, 'decimal')" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="capitalContable">Capital Contable: </label>
							</td>
							<td>
								<form:input id="capitalContable" name="capitalContable" path="capitalContable" size="15" esMoneda="true" style="text-align: right;"
								onkeypress="return validaNumero(event, 'decimal')" tabindex="34"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="capitalNeto">Capital Neto: </label>
							</td>
							<td>
								<form:input id="capitalNeto" name="capitalNeto" path="capitalNeto" size="15" esMoneda="true" style="text-align: right;" tabindex="35"
								onkeypress="return validaNumero(event, 'decimal')"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="importaSI">Importa: </label>
							</td>
							<td class="label" id="tdImporta">
								<form:radiobutton id="importaSI" name="importa" path="importa" value="S" tabindex="36" />
								<label for="importaSI">Si</label>&ensp;
								<form:radiobutton id="importaNO" name="importa" path="importa" value="N" checked="checked" tabindex="37" />
								<label for="importaNO">No</label>
							</td>
							<td class="separador"></td>
							<td></td>
							<td></td>
						</tr>
						<tr id="camposImporta" style="display: none;">
							<td></td>
							<td></td>
							<td class="separador"></td>
							<td id="tdUSDImporta">
								<label for="">Dolares Mensuales </label> <br>
								<form:radiobutton id="dolaresImporta1" name="dolaresImporta" path="dolaresImporta" value="DImp1" style="margin-bottom: .7em;" tabindex="38"/>
								<label for="dolaresImporta1">Menos de 1000</label> <br>
								<form:radiobutton id="dolaresImporta2" name="dolaresImporta" path="dolaresImporta" value="DImp2" style="margin-bottom: .7em;" tabindex="40"/>
								<label for="dolaresImporta2">1,001 a 5,000</label> <br>
								<form:radiobutton id="dolaresImporta3" name="dolaresImporta" path="dolaresImporta" value="DImp3" style="margin-bottom: .7em;" tabindex="42"/>
								<label for="dolaresImporta3">5,001 a 10,000</label> <br>
								<form:radiobutton id="dolaresImporta4" name="dolaresImporta" path="dolaresImporta" value="DImp4" style="margin-bottom: .5em;" tabindex="44"/>
								<label for="dolaresImporta4">Mayores de 10,001</label>
							</td>
							<td>
								<label for="">Principales Paises </label> <br>
								<form:input id="paisesImporta1" name="paisesImporta" path="paisesImporta1" size="20" onBlur="ponerMayusculas(this)" tabindex="39"
								maxlength="50" style="margin-bottom: .4em; margin-top: .3em;"/> <br>
								<form:input id="paisesImporta2" name="paisesImporta" path="paisesImporta2" size="20" onBlur="ponerMayusculas(this)" tabindex="41"
								maxlength="50" style="margin-bottom: .4em;"/> <br>
								<form:input id="paisesImporta3" name="paisesImporta" path="paisesImporta3" size="20" onBlur="ponerMayusculas(this)" tabindex="43"
								maxlength="50"  style="margin-bottom: .8em;"/> <br> <br>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="exportaSI">Exporta: </label>
							</td>
							<td class="label" id="tdExporta">
								<form:radiobutton id="exportaSI" name="exporta" path="exporta" value="S" tabindex="45"/>
								<label for="exportaSI">Si</label>&ensp;
								<form:radiobutton id="exportaNO" name="exporta" path="exporta" value="N" checked="checked" tabindex="46"/>
								<label for="exportaNO">No</label>
							</td>
						</tr>
						<tr id="camposExporta" style="display: none;">
							<td></td>
							<td></td>
							<td class="separador"></td>
							<td id="tdUSDExporta">
								<label for="">Dolares Mensuales </label> <br>
								<form:radiobutton id="dolaresExporta1" name="dolaresExporta" path="dolaresExporta" value="DEmp1" style="margin-bottom: .7em;" tabindex="47"/>
								<label for="dolaresExporta1">Menos de 1000</label> <br>
								<form:radiobutton id="dolaresExporta2" name="dolaresExporta" path="dolaresExporta" value="DEmp2" style="margin-bottom: .7em;" tabindex="49"/>
								<label for="dolaresExporta2">1,001 a 5,000</label> <br>
								<form:radiobutton id="dolaresExporta3" name="dolaresExporta" path="dolaresExporta" value="DEmp3" style="margin-bottom: .7em;" tabindex="51"/>
								<label for="dolaresExporta3">5,001 a 10,000</label> <br>
								<form:radiobutton id="dolaresExporta4" name="dolaresExporta" path="dolaresExporta" value="DEmp4" style="margin-bottom: .5em;" tabindex="53"/>
								<label for="dolaresExporta4">Mayores de 10,001</label>
							</td>
							<td>
								<label for="">Principales Paises </label> <br>
								<form:input id="paisesExporta1" name="paisesExporta" path="paisesExporta1" size="20" onBlur="ponerMayusculas(this)" tabindex="48"
								maxlength="50" style="margin-bottom: .4em; margin-top: .3em;"/> <br>
								<form:input id="paisesExporta2" name="paisesExporta" path="paisesExporta2" size="20" onBlur="ponerMayusculas(this)" tabindex="50"
								maxlength="50" style="margin-bottom: .4em;"/> <br>
								<form:input id="paisesExporta3" name="paisesExporta" path="paisesExporta3" size="20" onBlur="ponerMayusculas(this)" tabindex="52"
								maxlength="50"  style="margin-bottom: .8em;"/> <br> <br>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="tiposClientes">Tipos de Clientes: </label>
							</td>
							<td>
								<form:select id="tiposClientes" name="tiposClientes" path="tiposClientes" tabindex="54" >
									<form:option value="">SELECCIONAR</form:option>
									<form:option value="F">PERSONA FISICA</form:option>
									<form:option value="M">PERSONA MORAL</form:option>
								</form:select>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="instrMonetarios">Instrumentos Monetarios: </label>
							</td>
							<td>
								<form:select id="instrMonetarios" name="instrMonetarios" path="instrMonetarios" tabindex="55" >
									<form:option value="">SELECCIONAR</form:option>
									<form:option value="E">EFECTIVO</form:option>
									<form:option value="C">CHEQUE</form:option>
									<form:option value="T">TRASFERENCIA</form:option>
								</form:select>
							</td>
						</tr>
					</table>
				</fieldset>
				<br>

				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="label">Referencias Comerciales (Clientes/Proveedores)</legend>
					<table width="100%">
						<tr>
							<td class="label">
								<label for="nombreRefCom1">Nombre: </label>
							</td>
							<td>
								<form:input id="nombreRefCom1" name="nombreRefCom1" path="nombreRefCom1" size="45" onBlur="ponerMayusculas(this)" maxlength="150" tabindex="56"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="noCuentaRefCom1">No. de Cuenta: </label>
							</td>
							<td>
								<form:input id="noCuentaRefCom1" name="noCuentaRefCom1" path="noCuentaRefCom1" size="18" maxlength="15" onBlur="ponerMayusculas(this)" tabindex="57"
								onkeypress="return validaNumero(event, 'entero')"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="direccionRefCom1">Direcci&oacute;n: </label>
							</td>
							<td>
								<form:input id="direccionRefCom1" name="direccionRefCom1" path="direccionRefCom1" size="45" onBlur="ponerMayusculas(this)" maxlength="500" tabindex="58"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="telefonoRefCom1">Tel&eacute;fono: </label>
							</td>
							<td>
								<form:input id="telefonoRefCom1" name="telefonoRefCom1" path="telefonoRefCom1" size="18" maxlength="16" tabindex="59"
								onkeypress="return validaNumero(event, 'telefono')"/>
								<label for="extTelefonoRefCom1">Ext.:</label>
								<form:input id="extTelefonoRefCom1" name="extTelefonoRefCom1" path="extTelefonoRefCom1" size="10" maxlength="6" tabindex="60"
								onkeypress="return validaNumero(event, 'entero')"/>
							</td>
						</tr>

						<tr>
							<td class="label">
								<label for="nombreRefCom2">Nombre: </label>
							</td>
							<td>
								<form:input id="nombreRefCom2" name="nombreRefCom2" path="nombreRefCom2" size="45" onBlur="ponerMayusculas(this)" maxlength="150" tabindex="61"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="noCuentaRefCom2">No. de Cuenta: </label>
							</td>
							<td>
								<form:input id="noCuentaRefCom2" name="noCuentaRefCom2" path="noCuentaRefCom2" size="18" maxlength="15" onBlur="ponerMayusculas(this)" tabindex="62"
								onkeypress="return validaNumero(event, 'entero')"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="direccionRefCom2">Direcci&oacute;n: </label>
							</td>
							<td>
								<form:input id="direccionRefCom2" name="direccionRefCom2" path="direccionRefCom2" size="45" onBlur="ponerMayusculas(this)" maxlength="500" tabindex="63"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="telefonoRefCom2">Tel&eacute;fono: </label>
							</td>
							<td>
								<form:input id="telefonoRefCom2" name="telefonoRefCom2" path="telefonoRefCom2" size="18" maxlength="16" tabindex="64"
								onkeypress="return validaNumero(event, 'telefono')"/>
								<label for="extTelefonoRefCom2">Ext.:</label>
								<form:input id="extTelefonoRefCom2" name="extTelefonoRefCom2" path="extTelefonoRefCom2" size="10" maxlength="6" tabindex="65"
								onkeypress="return validaNumero(event, 'entero')"/>
							</td>
						</tr>
					</table>
				</fieldset>
				<br>

				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="label">Referencias Bancarias</legend>
					<table width="100%">
						<tr>
							<td class="label">
								<label for="bancoRefBanc1">Banco: </label>
							</td>
							<td>
								<form:input id="bancoRefBanc1" name="bancoRefBanc1" path="bancoRefBanc1" size="45" onBlur="ponerMayusculas(this)" maxlength="50" tabindex="66"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="tipoCuentaRefBanc1">Tipo de Cuenta: </label>
							</td>
							<td>
								<form:input id="tipoCuentaRefBanc1" name="tipoCuentaRefBanc1" path="tipoCuentaRefBanc1" size="20" onBlur="ponerMayusculas(this)" maxlength="50" tabindex="67"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="noCuentaRefBanc1">No. de Cuenta: </label>
							</td>
							<td>
								<form:input id="noCuentaRefBanc1" name="noCuentaRefBanc1" path="noCuentaRefBanc1" size="20" onBlur="ponerMayusculas(this)" maxlength="15" tabindex="68"
								onkeypress="return validaNumero(event, 'entero')"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="sucursalRefBanc1">Sucursal: </label>
							</td>
							<td>
								<form:input id="sucursalRefBanc1" name="sucursalRefBanc1" path="sucursalRefBanc1" size="45" onBlur="ponerMayusculas(this)" maxlength="50" tabindex="69"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="noTarjetaRefBanc1">Tarjeta de Cr&eacute;dito No.: </label>
							</td>
							<td>
								<form:input id="noTarjetaRefBanc1" name="noTarjetaRefBanc1" path="noTarjetaRefBanc1" size="20" onBlur="ponerMayusculas(this)" maxlength="16" tabindex="70"
								onkeypress="return validaNumero(event, 'entero')"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="institucionRefBanc1">Instituci&oacute;n: </label>
							</td>
							<td>
								<form:input id="institucionRefBanc1" name="institucionRefBanc1" path="institucionRefBanc1" size="45" onBlur="ponerMayusculas(this)" maxlength="50" tabindex="71"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="credOtraEntRefBanc1SI">Cr&eacute;dito con Otra Entidad: </label>
							</td>
							<td id="tdOtraEnt1">
								<form:radiobutton id="credOtraEntRefBanc1SI" name="credOtraEntRefBanc1" path="" value="S" tabindex="72"/>
								<label for="credOtraEntRefBanc1SI">Si</label>&ensp;
								<form:radiobutton id="credOtraEntRefBanc1NO" name="credOtraEntRefBanc1" path="" value="N" tabindex="73"/>
								<label for="credOtraEntRefBanc1NO">No</label>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="institucionEntRefBanc1">Instituci&oacute;n: </label>
							</td>
							<td>
								<form:input id="institucionEntRefBanc1" name="institucionEntRefBanc1" path="institucionEntRefBanc1" size="45" onBlur="ponerMayusculas(this)" maxlength="50" tabindex="74"/>
							</td>
						</tr>

						<tr>
							<td class="label">
								<label for="bancoRefBanc2">Banco: </label>
							</td>
							<td>
								<form:input id="bancoRefBanc2" name="bancoRefBanc2" path="bancoRefBanc2" size="45" onBlur="ponerMayusculas(this)" maxlength="50" tabindex="75"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="tipoCuentaRefBanc2">Tipo de Cuenta: </label>
							</td>
							<td>
								<form:input id="tipoCuentaRefBanc2" name="tipoCuentaRefBanc2" path="tipoCuentaRefBanc2" size="20" onBlur="ponerMayusculas(this)" maxlength="50" tabindex="76"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="noCuentaRefBanc2">No. de Cuenta: </label>
							</td>
							<td>
								<form:input id="noCuentaRefBanc2" name="noCuentaRefBanc2" path="noCuentaRefBanc2" size="20" onBlur="ponerMayusculas(this)" maxlength="15" tabindex="77"
								onkeypress="return validaNumero(event, 'entero')"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="sucursalRefBanc2">Sucursal: </label>
							</td>
							<td>
								<form:input id="sucursalRefBanc2" name="sucursalRefBanc2" path="sucursalRefBanc2" size="45" onBlur="ponerMayusculas(this)" maxlength="50" tabindex="78"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="noTarjetaRefBanc2">Tarjeta de Cr&eacute;dito No.: </label>
							</td>
							<td>
								<form:input id="noTarjetaRefBanc2" name="noTarjetaRefBanc2" path="noTarjetaRefBanc2" size="20" onBlur="ponerMayusculas(this)" maxlength="16" tabindex="79"
								onkeypress="return validaNumero(event, 'entero')"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="institucionRefBanc2">Instituci&oacute;n: </label>
							</td>
							<td>
								<form:input id="institucionRefBanc2" name="institucionRefBanc2" path="institucionRefBanc2" size="45" onBlur="ponerMayusculas(this)" maxlength="50" tabindex="80"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="credOtraEntRefBanc2SI">Cr&eacute;dito con Otra Entidad: </label>
							</td>
							<td id="tdOtraEnt2">
								<form:radiobutton id="credOtraEntRefBanc2SI" name="credOtraEntRefBanc2" path="" value="S" tabindex="81"/>
								<label for="credOtraEntRefBanc2SI">Si</label>&ensp;
								<form:radiobutton id="credOtraEntRefBanc2NO" name="credOtraEntRefBanc2" path="" value="N" tabindex="82"/>
								<label for="credOtraEntRefBanc2NO">No</label>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="institucionEntRefBanc2">Instituci&oacute;n: </label>
							</td>
							<td>
								<form:input id="institucionEntRefBanc2" name="institucionEntRefBanc2" path="institucionEntRefBanc2" size="45" onBlur="ponerMayusculas(this)" maxlength="63" tabindex="83"/>
							</td>
						</tr>
					</table>
				</fieldset>
				<br>

				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="label">Referencias que no vivan en su domicilio</legend>
					<table width="100%">
						<tr>
							<td class="label">
								<label for="nombreRefPers1">Nombre: </label>
							</td>
							<td>
								<form:input id="nombreRefPers1" name="nombreRefPers1" path="nombreRefPers1" size="45" onBlur="ponerMayusculas(this)" maxlength="150" tabindex="84"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="domicilioRefPers1">Domicilio: </label>
							</td>
							<td>
								<form:input id="domicilioRefPers1" name="domicilioRefPers1" path="domicilioRefPers1" size="50" onBlur="ponerMayusculas(this)" maxlength="500" tabindex="85"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="telefonoRefPers1">Tel&eacute;fono: </label>
							</td>
							<td>
								<form:input name="telefonoRefPers1" id="telefonoRefPers1" path="telefonoRefPers1" size="18" maxlength="16" tabindex="86"
								onkeypress="return validaNumero(event, 'telefono')"/>
								<label for="extTelefonoRefPers1">Ext.: </label>
								<form:input path="extTelefonoRefPers1" id="extTelefonoRefPers1" name="extTelefonoRefPers1" size="10" maxlength="5" tabindex="87"
								onkeypress="return validaNumero(event, 'entero')"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="tipoRelacionRefPers1">Tipo Relaci&oacute;n: </label>
							</td>
							<td>
								<form:input id="tipoRelacionRefPers1" name="tipoRelacionRefPers1" path="tipoRelacionRefPers1" size="5" tabindex="88"/>
								<input type="text" id="tipoRelacion1Desc" name="tipoRelacion1Desc" size="40" disabled="true" readonly="true"/>
							</td>
						</tr>

						<tr>
							<td class="label">
								<label for="nombreRefPers2">Nombre: </label>
							</td>
							<td>
								<form:input id="nombreRefPers2" name="nombreRefPers2" path="nombreRefPers2" size="45" onBlur="ponerMayusculas(this)" maxlength="150" tabindex="89"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="domicilioRefPers2">Domicilio: </label>
							</td>
							<td>
								<form:input id="domicilioRefPers2" name="domicilioRefPers2" path="domicilioRefPers2" size="50" onBlur="ponerMayusculas(this)" maxlength="500" tabindex="90"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="telefonoRefPers2">Tel&eacute;fono: </label>
							</td>
							<td>
								<form:input name="telefonoRefPers2" id="telefonoRefPers2" path="telefonoRefPers2" size="18" maxlength="16" tabindex="91"
								onkeypress="return validaNumero(event, 'telefono')"/>
								<label for="extTelefonoRefPers2">Ext.: </label>
								<form:input path="extTelefonoRefPers2" id="extTelefonoRefPers2" name="extTelefonoRefPers2" size="10" maxlength="5" tabindex="92"
								onkeypress="return validaNumero(event, 'entero')"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="tipoRelacionRefPers2">Tipo Relaci&oacute;n: </label>
							</td>
							<td>
								<form:input id="tipoRelacionRefPers2" name="tipoRelacionRefPers2" path="tipoRelacionRefPers2" size="5" tabindex="93"/>
								<input type="text" id="tipoRelacion2Desc" name="tipoRelacion2Desc" size="40" disabled="true" readonly="true"/>
							</td>
						</tr>
					</table>
				</fieldset>
				<br>
				<div id="camposUsuarioAltoRiesgo" style="display: none;">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend class="label">
							Informaci&oacute;n adicional al usuario de servicios.
						</legend>
						<table width="100%">
							<tr>
								<td class="label">
									<label for="preguntaUsuario1">Pregunta 1.-&nbsp;</label>
								</td>
								<td>
									<textarea rows="2" cols="50" name="preguntaUsuario1" id="preguntaUsuario1" autocomplete="off" onBlur="ponerMayusculas(this)" maxlength="100" tabindex="94"></textarea>
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="respuestaUsuario1">Respuesta 1.-&nbsp;</label>
								</td>
								<td>
									<textarea rows="2" cols="50" name="respuestaUsuario1" id="respuestaUsuario1" autocomplete="off" onBlur="ponerMayusculas(this)" maxlength="200" tabindex="95"></textarea>
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="preguntaUsuario2">Pregunta 2.-&nbsp;</label>
								</td>
								<td>
									<textarea rows="2" cols="50" name="preguntaUsuario2" id="preguntaUsuario2" autocomplete="off" onBlur="ponerMayusculas(this)" maxlength="100" tabindex="96"></textarea>
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="respuestaUsuario2">Respuesta 2.-&nbsp;</label>
								</td>
								<td>
									<textarea rows="2" cols="50" name="respuestaUsuario2" id="respuestaUsuario2" autocomplete="off" onBlur="ponerMayusculas(this)" maxlength="200" tabindex="97"></textarea>
							</tr>
							<tr>
								<td class="label">
									<label for="preguntaUsuario3">Pregunta 3.-&nbsp;</label>
								</td>
								<td>
									<textarea rows="2" cols="50" name="preguntaUsuario3" id="preguntaUsuario3" autocomplete="off" onBlur="ponerMayusculas(this)" maxlength="100" tabindex="98"></textarea>
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="respuestaUsuario3">Respuesta 3.-&nbsp;</label>
								</td>
								<td>
									<textarea rows="2" cols="50" name="respuestaUsuario3" id="respuestaUsuario3" autocomplete="off" onBlur="ponerMayusculas(this)" maxlength="200" tabindex="99"></textarea>
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="preguntaUsuario4">Pregunta 4.-&nbsp;</label>
								</td>
								<td>
									<textarea rows="2" cols="50" name="preguntaUsuario4" id="preguntaUsuario4" autocomplete="off" onBlur="ponerMayusculas(this)" maxlength="100" tabindex="100"></textarea>
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="respuestaUsuario4">Respuesta 4.-&nbsp;</label>
								</td>
								<td>
									<textarea rows="2" cols="50" name="respuestaUsuario4" id="respuestaUsuario4" autocomplete="off" onBlur="ponerMayusculas(this)" maxlength="200" tabindex="101"></textarea>
								</td>
							</tr>
						</table>
					</fieldset>
					<br>
				</div>
				<table>
					<tr style="vertical-align: text-top;">
						<td class="label" nowrap="nowrap">
							<label for="principalFuenteIng">Principal Fuente de Ingresos: </label>
						</td>
						<td>
							<form:input id="principalFuenteIng" name="principalFuenteIng" path="principalFuenteIng" size="45" onBlur="ponerMayusculas(this)" maxlength="100" tabindex="102"/>
						</td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap">
							<label for="ingAproxPorMes">Ing. aprox por mes: </label>
						</td>
						<td class="label" id="tdIngAprox">
							<form:radiobutton id="ingAproxPorMes1" name="ingAproxPorMes" path="ingAproxPorMes" value="Ing1" checked="checked" tabindex="103"/>
							<label for="ingAproxPorMes1">Menos de 20,000</label><br>
							<form:radiobutton id="ingAproxPorMes2" name="ingAproxPorMes" path="ingAproxPorMes" value="Ing2" style="margin-top: .7em;" tabindex="104"/>
							<label for="ingAproxPorMes2">20,001 a 50,000</label><br>
							<form:radiobutton id="ingAproxPorMes3" name="ingAproxPorMes" path="ingAproxPorMes" value="Ing3" style="margin-top: .7em;" tabindex="105"/>
							<label for="ingAproxPorMes3">50,001 a 100,000</label><br>
							<form:radiobutton id="ingAproxPorMes4" name="ingAproxPorMes" path="ingAproxPorMes" value="Ing4" style="margin-top: .7em;" tabindex="106"/>
							<label for="ingAproxPorMes4">Mayor a 100,000</label><br>
						</td>
					</tr>
					<tr class="mostrarOC" style="display: none">
						<td class="label">
							<label for="nivelRiesgo">Nivel de Riesgo:</label>
						</td>
						<td>
							<form:select id="nivelRiesgo" name="nivelRiesgo" path="nivelRiesgo" tabindex="107">
								<form:option value="">SELECCIONAR</form:option>
								<form:option value="A">ALTO</form:option>
								<form:option value="M">MEDIO</form:option>
								<form:option value="B">BAJO</form:option>
							</form:select>
						</td>
						<td class="separado"></td>
						<td class="label">
							<label for="nivelRiesgo">EvaluaXMatriz:</label>
						</td>
						<td nowrap="nowrap" id="tdEvalMatriz">
							<form:radiobutton id="evaluaXMatrizSI" name="evaluaXMatriz" path="evaluaXMatriz" value="S" checked="checked"  tabindex="108" />
							<label for="evaluaXMatrizSI"> Si</label> &emsp;
							<form:radiobutton id="evaluaXMatrizNO" name="evaluaXMatriz" path="evaluaXMatriz" value="N" tabindex="109"/>
							<label for="evaluaXMatrizNO"> No</label>
						</td>
					</tr>
					<tr class="mostrarOC" style="display: none">
						<td class="label">
							<label for="comentarioNivel">Comentario:</label>
						</td>
						<td>
							<form:textarea id="comentarioNivel" name="comentarioNivel" path="comentarioNivel" rows="4" cols="20" maxlength="100" value="" tabindex="110"></form:textarea>
						</td>
					</tr>
					<tr>
						<td style="text-align: right;" colspan="5">
							<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar" tabindex="111"/>
							<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar" tabindex="112"/>
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
							<input type="hidden" id="ctrlUsuarioID" name="ctrlUsuarioID">
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
	<div id="modalDefinicionPEP" style="display: none;">
		<table>
			<tr>
				<th style="text-align: center;" id="encabezadoLista">
					Definici&oacute;n Persona Politicamente Expuesta(PEPs):
				</th>
			</tr>
			<tr>
				<td style="text-align: justify; padding: 0 1em; font-family: 'Times New Roman'; font-size: 1.1em; color: #2E2E2E;">
					<p>
						De acuerdo a las Disposiciones de Car&aacute;cter General a que se refiere el art&iacute;culo 115 de
						la Ley de Instituciones de Cr&eacute;dito se consider&oacute; que una Persona Pol&iacute;ticamente
						Expuesta ser&iacute;a aquel individuo que desempe&ntilde;ase o hubiese desempe&ntilde;ado
						funciones p&uacute;blicas destacadas en un pa&iacute;s extranjero o en territorio nacional.<br>
						Para ello fueron considerados, entre otros puestos, a los jefes de estado o de gobierno, l&iacute;deres
						pol&iacute;ticos, funcionarios gubernamentales, judiciales o militares de alta jerarqu&iacute;a, altos
						ejecutivos de empresas estatales o funcionarios miembros importantes de los partidos pol&iacute;ticos.
					</p>
					<p>
						Los c&oacute;nyuges de estas, o las personas con las que se mantuviese parentesco por consanguinidad
						o afinidad hasta el segundo grado.
					</p>
				</td>
			</tr>
		</table>
	</div>

</body>
</html>