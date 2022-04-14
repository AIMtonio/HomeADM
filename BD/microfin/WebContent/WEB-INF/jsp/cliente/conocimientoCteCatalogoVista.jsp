<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/conocimientoCteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/funcionesPubServicio.js"></script>
<script type="text/javascript" src="dwr/interface/parentescosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/actividadesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/referenciaClienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
<script type="text/javascript" src="js/soporte/mascara.js"></script>
<script type="text/javascript" src="js/cliente/conocimientoCte.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="ConocimientoCte">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">
					Formato Conocimiento del
					<s:message code="safilocale.cliente" />
				</legend>
				<table border="0" width="100%">
					<tr>
						<td class="label">
							<label for="clienteID">No. de <s:message code="safilocale.cliente" />:
							</label>
						</td>
						<td>
							<form:input id="clienteID" name="clienteID" path="clienteID" size="12" tabindex="1" iniforma='false' />
							<input type="text" id="nombreCliente" name="nombreCliente" size="60" readonly="true" readOnly="true" iniForma="false" />
						</td>
					</tr>
				</table>
				<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="label">En caso de pertenecer a una sociedad, grupo o filial</legend>
					<table border="0" width="100%">
						<tr>
							<td class="label">
								<label for="nombreGrupo">Nombre: </label>
							</td>
							<td>
								<form:input id="nomGrupo" name="nomGrupo" path="nomGrupo" onBlur=" ponerMayusculas(this)" size="50" tabindex="4" maxlength="100" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="RFC">RFC o similar: </label>
							</td>
							<td>
								<form:input id="RFC" name="RFC" path="RFC" size="20" onBlur=" ponerMayusculas(this)" tabindex="5" maxlength="13" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="participacion">Participaci&oacute;n: </label>
							</td>
							<td>
								<form:input id="participacion" name="participacion" path="participacion" size="15" tabindex="6" esMoneda="true" style="text-align: right;" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="nacionalidad">Nacionalidad: </label>
							</td>
							<td>
								<form:input id="nacionalidad" name="nacionalidad" path="nacionalidad" size="20" onBlur=" ponerMayusculas(this)" tabindex="7" maxlength="45" />
							</td>
						</tr>
					</table>
				</fieldset>
				<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="label">En caso de tener Actividad Empresarial</legend>
					<table border="0" width="100%">
						<tr>
							<td class="label">
								<label for="razonSocial">Raz&oacute;n Social: </label>
							</td>
							<td>
								<form:input id="razonSocial" name="razonSocial" path="razonSocial" onBlur=" ponerMayusculas(this)" size="50" tabindex="8" maxlength="100" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="giro">Giro o Actividad Empresarial: </label>
							</td>
							<td>
								<form:input id="giro" name="giro" path="giro" size="45" onBlur=" ponerMayusculas(this)" tabindex="9" maxlength="100" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label>Años de Operaci&oacute;n: </label>
							</td>
							<td>
								<form:input id="operacionAnios" name="operacionAnios" path="operacionAnios" size="3" tabindex="9" style="text-align: right;" maxlength="2"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label>Años en el Giro: </label>
							</td>
							<td>
								<form:input id="giroAnios" name="giroAnios" path="giroAnios" size="3" tabindex="9" style="text-align: right;" maxlength="2"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="PEPs">PEP's: </label>
							</td>
							<td class="label">
								<form:radiobutton id="PEPs" name="PEPs" path="PEPs" value="S" tabindex="10" />
								<label for="si">Si</label>&nbsp;&nbsp;
								<form:radiobutton id="PEPs2" name="PEPs" path="PEPs" value="N" tabindex="11" checked="checked" />
								<label for="no">No</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <input type="button" id="definicion" name="definicion" value="Definici&oacute;n PEP" class="submit" />
								<div id="definicionPEP" style="display: none;"></div>
							</td>
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="separador"></td>
						</tr>
						<tr>
							<td class="label" id="tdLabelFuncion">
								<label for="funcionID">Funci&oacute;n P&uacute;blica: </label>
							</td>
							<td id="tdFuncionID">
								<form:input id="funcionID" name="funcionID" path="funcionID" size="5" tabindex="12" />
								<input type="text" id="descripcion" name="descripcion" size="60" tabindex="13" disabled="true" readOnly="true" />
							</td>
						</tr>
						<tr id="trNombramientoPorcen">
							<td class="label">
								<label for="fechaNombramiento">Fecha de nombramiento: </label>
							</td>
							<td>
								<form:input id="fechaNombramiento" name="fechaNombramiento" path="fechaNombramiento" esCalendario="true" tabindex="14" maxlength="12"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="porcentajeAcciones">Porcentaje de las acciones (En %): </label>
							</td>
							<td>
								<form:input id="porcentajeAcciones" name="porcentajeAcciones" path="porcentajeAcciones" tabindex="15" size="15" esMoneda="true" style="text-align: right;" maxlength="15" />
							</td>
						</tr>
						<tr id="trPeriodoMonto">
							<td class="label">
								<label for="periodoCargo">Periodo del cargo: </label>
							</td>
							<td>
								<form:input id="periodoCargo" name="periodoCargo" path="periodoCargo" tabindex="16" size="60" maxlength="100"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="montoAcciones">Monto de las acciones (En $): </label>
							</td>
							<td>
								<form:input id="montoAcciones" name="montoAcciones" path="montoAcciones" tabindex="17" size="15" esMoneda="true" style="text-align: right;" maxlength="15"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="parentescoPEP">Parentesco con PEP: </label>
							</td>
							<td class="label">
								<form:radiobutton id="parentescoPEP" name="parentescoPEP" path="parentescoPEP" value="S" tabindex="18" />
								<label for="si">Si</label>&nbsp;&nbsp;
								<form:radiobutton id="parentescoPEP2" name="parentescoPEP" path="parentescoPEP" value="N" tabindex="19" checked="checked" />
								<label for="no">No</label>
							</td>
						</tr>
						<tr id="trFamiliar">
							<td class="label">
								<label for="nombFamiliar">Nombre del Familiar: </label>
							</td>
							<td>
								<form:input id="nombFamiliar" name="nombFamiliar" path="nombFamiliar" size="25" tabindex="20" onBlur=" ponerMayusculas(this)" maxlength="50" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="aPaternoFam">Apellido Paterno: </label>
							</td>
							<td>
								<form:input id="aPaternoFam" name="aPaternoFam" path="aPaternoFam" size="25" tabindex="21" onBlur=" ponerMayusculas(this)" maxlength="50" />
							</td>
						</tr>
						<tr>
							<td class="label" id="tdLabelApellidoMaterno">
								<label for="aMaternoFam">Apellido Materno: </label>
							</td>
							<td id="tdApellidoMaterno">
								<form:input id="aMaternoFam" name="aMaternoFam" path="aMaternoFam" size="25" tabindex="22" onBlur=" ponerMayusculas(this)" maxlength="50" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="noEmpleados">No. Empleados: </label>
							</td>
							<td>
								<form:input id="noEmpleados" name="noEmpleados" path="noEmpleados" size="10" tabindex="23" maxlength="10" />
							</td>
							<td class="separador"></td>
							<td class="label" nowrap="nowrap">
								<label for="serv_Produc">Principales Servicios o Productos: </label>
							</td>
							<td>
								<form:input id="serv_Produc" name="serv_Produc" path="serv_Produc" size="45" onBlur=" ponerMayusculas(this)" tabindex="24" maxlength="50" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="cober_Geograf">Cobertura Geogr&aacute;fica: </label>
							</td>
							<td class="label">
								<form:radiobutton id="cober_Geograf" name="cober_Geograf" path="cober_Geograf" value="L" tabindex="25" checked="checked" />
								<label for="cober_Geograf">Local</label>&nbsp;&nbsp;
								<form:radiobutton id="cober_Geograf2" name="cober_Geograf" path="cober_Geograf" value="E" tabindex="26" />
								<label for="cober_Geograf2">Estatal</label>&nbsp;&nbsp;
								<form:radiobutton id="cober_Geograf3" name="cober_Geograf" path="cober_Geograf" value="R" tabindex="27" />
								<label for="cober_Geograf3">Regional</label>
							</td>
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="separador"></td>
						</tr>
						<tr>
							<td class="separador"></td>
							<td class="label">
								<form:radiobutton id="cober_Geograf4" name="cober_Geograf" path="cober_Geograf" value="N" tabindex="28" />
								<label for="cober_Geograf4">Nacional</label>&nbsp;&nbsp;
								<form:radiobutton id="cober_Geograf5" name="cober_Geograf" path="cober_Geograf" value="I" tabindex="29" />
								<label for="cober_Geograf5">Internacional</label>
							</td>
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="separador"></td>
						<tr>
							<td class="label" nowrap="nowrap">
								<label for="estados_Presen">Estados con Presencia: </label>
							</td>
							<td>
								<form:input id="estados_Presen" name="estados_Presen" path="estados_Presen" size="15" onBlur=" ponerMayusculas(this)" tabindex="30" maxlength="45" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="importeVta">Importe de Ventas: </label>
							</td>
							<td>
								<form:input id="importeVta" name="importeVta" path="importeVta" size="15" tabindex="31" esMoneda="true" style="text-align: right;" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="activos">Activos: </label>
							</td>
							<td>
								<form:input id="activos" name="activos" path="activos" size="15" tabindex="32" esMoneda="true" style="text-align: right;" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="pasivos">Pasivos: </label>
							</td>
							<td>
								<form:input id="pasivos" name="pasivos" path="pasivos" size="15" tabindex="33" esMoneda="true" style="text-align: right;" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="capitalContable">Capital Contable: </label>
							</td>
							<td>
								<form:input id="capitalContable" name="capitalContable" path="capitalContable" size="15" tabindex="34" esMoneda="true" style="text-align: right;" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="capital">Capital Neto: </label>
							</td>
							<td>
								<form:input id="capital" name="capital" path="capital" size="15" tabindex="35" esMoneda="true" style="text-align: right;" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="importa">Importa: </label>
							</td>
							<td class="label">
								<form:radiobutton id="importa" name="importa" path="importa" value="S" tabindex="36" />
								<label for="si">Si</label>&nbsp;&nbsp;
								<form:radiobutton id="importa2" name="importa" path="importa" value="N" tabindex="37" checked="checked" />
								<label for="no">No</label>
							</td>
						</tr>
						<tr id="trImporta">
							<td class="label">
								<label>&nbsp;</label>
							</td>
							<td>
								<label>&nbsp;</label>
							</td>
							<td class="separador"></td>
							<td class="label" nowrap="nowrap">
								<label for="dolares">Dolares Mensuales </label>
							</td>
							<td class="label">
								<label for="paises">Principales Paises </label>
							</td>
						</tr>
						<tr>
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="label" id="tdImporta1">
								<form:radiobutton id="dolaresImport" name="dolaresImport" path="dolaresImport" value="DImp" tabindex="38" checked="checked" />
								<label for="menos1000">Menos de 1000</label>
							</td>
							<td id="tdImporta2">
								<form:input id="paisesImport" name="paisesImport" path="paisesImport" size="20" onBlur=" ponerMayusculas(this)" tabindex="39" maxlength="50" />
							</td>
						</tr>
						<tr>
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="label" id="tdImporta3">
								<form:radiobutton id="dolaresImport2" name="dolaresImport" path="dolaresImport" value="DImp2" tabindex="40" />
								<label for="1001">1,001 a 5,000</label>
							</td>
							<td id="tdImporta4">
								<form:input id="paisesImport2" name="paisesImport2" path="paisesImport2" size="20" onBlur=" ponerMayusculas(this)" tabindex="41" maxlength="50" />
							</td>
						</tr>
						<tr>
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="label" id="tdImporta5">
								<form:radiobutton id="dolaresImport3" name="dolaresImport" path="dolaresImport" value="DImp3" tabindex="42" />
								<label for="dolaresImport3">5,001 a 10,000</label>
							</td>
							<td id="tdImporta6">
								<form:input id="paisesImport3" name="paisesImport3" path="paisesImport3" onBlur=" ponerMayusculas(this)" size="20" tabindex="43" maxlength="50" />
							</td>
						</tr>
						<tr>
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="label" id="tdImporta7">
								<form:radiobutton id="dolaresImport4" name="dolaresImport" path="dolaresImport" value="DImp4" tabindex="44" />
								<label for="mayor10001">Mayores de 10,001</label>
							</td>
							<td class="separador"></td>
						</tr>
						<tr>
							<td class="label">
								<label for="lblExt">Exporta: </label>
							</td>
							<td class="label">
								<form:radiobutton id="exporta" name="exporta" path="exporta" value="S" tabindex="45" />
								<label for="si">Si</label>&nbsp;&nbsp;
								<form:radiobutton id="exporta2" name="exporta" path="exporta" value="N" tabindex="46" checked="checked" />
								<label for="no">No</label>
							</td>
							<td class="separador"></td>
							<td class="label"></td>
							<td></td>
						</tr>
						<tr>
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="label" nowrap="nowrap" id="tdExportaDolar">
								<label for="lbldol">Dolares Mensuales </label>
							</td>
							<td class="label" id="tdExportaPais">
								<label for="lblpaises">Principales Paises </label>
							</td>
						</tr>
						<tr id="trExporta1">
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="label">
								<form:radiobutton id="dolaresExport" name="dolaresExport" path="dolaresExport" value="DExp" tabindex="47" checked="checked" />
								<label for="menos1000">Menos de 1000</label>
							</td>
							<td>
								<form:input id="paisesExport" name="paisesExport" path="paisesExport" size="20" onBlur=" ponerMayusculas(this)" tabindex="48" maxlength="50" />
							</td>
						</tr>
						<tr id="trExporta2">
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="label">
								<form:radiobutton id="dolaresExport2" name="dolaresExport" path="dolaresExport" value="DExp2" tabindex="49" />
								<label for="dolaresExport2">1,001 a 5,000</label>
							</td>
							<td>
								<form:input id="paisesExport2" name="paisesExport2" path="paisesExport2" size="20" onBlur=" ponerMayusculas(this)" tabindex="50" maxlength="50" />
							</td>
						</tr>
						<tr id="trExporta3">
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="label">
								<form:radiobutton id="dolaresExport3" name="dolaresExport" path="dolaresExport" value="DExp3" tabindex="51" />
								<label for="dolaresExport3">5,001 a 10,000</label>
							</td>
							<td>
								<form:input id="paisesExport3" name="paisesExport3" path="paisesExport3" size="20" onBlur=" ponerMayusculas(this)" tabindex="52" maxlength="50" />
							</td>
						</tr>
						<tr id="trExporta4">
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="label">
								<form:radiobutton id="dolaresExport4" name="dolaresExport" path="dolaresExport" value="DExp4" tabindex="53" />
								<label for="dolaresExport4">Mayores de 10,001</label>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="tiposClientes">Tipos de clientes: </label>
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
								<label for="instrumentosMonetarios">Instrumentos monetarios: </label>
							</td>
							<td>
								<form:select id="instrumentosMonetarios" name="instrumentosMonetarios" path="instrumentosMonetarios" tabindex="55" >
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
					<table border="0" width="100%">
						<tr>
							<td class="label">
								<label for="nombRefCom">Nombre: </label>
							</td>
							<td>
								<form:input id="nombRefCom" name="nombRefCom" path="nombRefCom" size="45" onBlur=" ponerMayusculas(this)" tabindex="56" maxlength="50" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="noCuentaRefCom">No. de Cuenta: </label>
							</td>
							<td>
								<form:input id="noCuentaRefCom" name="noCuentaRefCom" path="noCuentaRefCom" size="15" maxlength="50" onBlur=" ponerMayusculas(this)" tabindex="57" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="direccionRefCom">Direcci&oacute;n: </label>
							</td>
							<td>
								<form:input id="direccionRefCom" name="direccionRefCom" path="direccionRefCom" size="45" onBlur=" ponerMayusculas(this)" tabindex="58" maxlength="500" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="telRefCom">Tel&eacute;fono: </label>
							</td>
							<td>
								<form:input id="telRefCom" name="telRefCom" path="telRefCom" size="15" maxlength="10" onBlur=" ponerMayusculas(this)" tabindex="59" />
								<label for="lbltelRefCom">Ext.:</label>
								<form:input id="extTelRefCom" name="extTelRefCom" path="extTelRefCom" size="10" maxlength="6" tabindex="60" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="nombRefCom2">Nombre: </label>
							</td>
							<td>
								<form:input id="nombRefCom2" name="nombRefCom2" path="nombRefCom2" size="45" onBlur=" ponerMayusculas(this)" tabindex="61" maxlength="50" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="noCuentaRefCom2">No. de Cuenta: </label>
							</td>
							<td>
								<form:input id="noCuentaRefCom2" name="noCuentaRefCom2" path="noCuentaRefCom2" size="15" maxlength="50" onBlur=" ponerMayusculas(this)" tabindex="62" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="direccionRefCom2">Direcci&oacute;n: </label>
							</td>
							<td>
								<form:input id="direccionRefCom2" name="direccionRefCom2" path="direccionRefCom2" size="45" onBlur=" ponerMayusculas(this)" tabindex="63" maxlength="500" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="telRefCom2">Tel&eacute;fono: </label>
							</td>
							<td>
								<form:input id="telRefCom2" name="telRefCom2" path="telRefCom2" size="15" maxlength="10" onBlur=" ponerMayusculas(this)" tabindex="64" />
								<label for="lbltelRefCom">Ext.:</label>
								<form:input id="extTelRefCom2" name="extTelRefCom2" path="extTelRefCom2" size="10" maxlength="6" tabindex="65" />
							</td>
						</tr>
					</table>
				</fieldset>
				<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="label">Referencias Bancarias</legend>
					<table border="0" width="100%">
						<tr>
							<td class="label">
								<label for="bancoRef">Banco: </label>
							</td>
							<td>
								<form:input id="bancoRef" name="bancoRef" path="bancoRef" size="45" onBlur=" ponerMayusculas(this)" tabindex="66" maxlength="45" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="banTipoCuentaRef">Tipo de Cuenta: </label>
							</td>
							<td>
								<form:input id="banTipoCuentaRef" name="banTipoCuentaRef" path="banTipoCuentaRef" size="20" onBlur=" ponerMayusculas(this)" tabindex="67" maxlength="50" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="noCuentaRef">No. de Cuenta: </label>
							</td>
							<td>
								<form:input id="noCuentaRef" name="noCuentaRef" path="noCuentaRef" size="20" onBlur=" ponerMayusculas(this)" tabindex="68" maxlength="30" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="banSucursalRef">Sucursal: </label>
							</td>
							<td>
								<form:input id="banSucursalRef" name="banSucursalRef" path="banSucursalRef" size="45" onBlur=" ponerMayusculas(this)" tabindex="69" maxlength="50" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="banNoTarjetaRef">Tarjeta de Cr&eacute;dito No.: </label>
							</td>
							<td>
								<form:input id="banNoTarjetaRef" name="banNoTarjetaRef" path="banNoTarjetaRef" size="20" tabindex="70" onBlur=" ponerMayusculas(this)" maxlength="50" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="banTarjetaInsRef">Instituci&oacute;n: </label>
							</td>
							<td>
								<form:input id="banTarjetaInsRef" name="banTarjetaInsRef" path="banTarjetaInsRef" size="45" onBlur=" ponerMayusculas(this)" tabindex="71" maxlength="50" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="banCredOtraEnt">Cr&eacute;dito con Otra Entidad: </label>
							</td>
							<td>
								<form:radiobutton id="banCredOtraEnt1" name="banCredOtraEnt1" path="" value="S" tabindex="72" />
								<label for="si">Si</label>&nbsp;&nbsp;
								<form:radiobutton id="banCredOtraEnt12" name="banCredOtraEnt1" path="" value="N" tabindex="73" />
								<label for="no">No</label>
								<form:radiobutton type="hidden" id="banCredOtraEnt" name="banCredOtraEnt" path="banCredOtraEnt" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="banInsOtraEnt">Instituci&oacute;n: </label>
							</td>
							<td>
								<form:input id="banInsOtraEnt" name="banInsOtraEnt" path="banInsOtraEnt" size="45" onBlur=" ponerMayusculas(this)" tabindex="74" maxlength="50" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="bancoRef2">Banco: </label>
							</td>
							<td>
								<form:input id="bancoRef2" name="bancoRef2" path="bancoRef2" size="45" onBlur=" ponerMayusculas(this)" tabindex="75" maxlength="45" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for=banTipoCuentaRef2>Tipo de Cuenta: </label>
							</td>
							<td>
								<form:input id="banTipoCuentaRef2" name="banTipoCuentaRef2" path="banTipoCuentaRef2" size="20" onBlur=" ponerMayusculas(this)" tabindex="76" maxlength="50" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="noCuentaRef2">No. de Cuenta: </label>
							</td>
							<td>
								<form:input id="noCuentaRef2" name="noCuentaRef2" path="noCuentaRef2" size="20" tabindex="77" onBlur=" ponerMayusculas(this)" maxlength="30" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="banSucursalRef2">Sucursal: </label>
							</td>
							<td>
								<form:input id="banSucursalRef2" name="banSucursalRef2" path="banSucursalRef2" size="45" onBlur=" ponerMayusculas(this)" tabindex="78" maxlength="50" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="banNoTarjetaRef2">Tarjeta de Cr&eacute;dito No.: </label>
							</td>
							<td>
								<form:input id="banNoTarjetaRef2" name="banNoTarjetaRef2" path="banNoTarjetaRef2" size="20" onBlur=" ponerMayusculas(this)" tabindex="79" maxlength="50" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="banTarjetaInsRef2">Instituci&oacute;n: </label>
							</td>
							<td>
								<form:input id="banTarjetaInsRef2" name="banTarjetaInsRef2" path="banTarjetaInsRef2" size="45" onBlur=" ponerMayusculas(this)" tabindex="80" maxlength="50" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="banCredOtraEnt2">Cr&eacute;dito con Otra Entidad: </label>
							</td>
							<td>
								<form:radiobutton id="banCredOtraEnt21" name="banCredOtraEnt21" path="" value="S" tabindex="81" />
								<label for="si">Si</label>&nbsp;&nbsp;
								<form:radiobutton id="banCredOtraEnt22" name="banCredOtraEnt21" path="" value="N" tabindex="82" />
								<label for="no">No</label>
								<form:radiobutton type="hidden" id="banCredOtraEnt2" name="banCredOtraEnt2" path="banCredOtraEnt2"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="banInsOtraEnt2">Instituci&oacute;n: </label>
							</td>
							<td>
								<form:input id="banInsOtraEnt2" name="banInsOtraEnt2" path="banInsOtraEnt2" size="45" onBlur=" ponerMayusculas(this)" tabindex="83" maxlength="50" />
							</td>
						</tr>
					</table>
				</fieldset>
				<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="label">Referencias que no vivan en su domicilio</legend>
					<table border="0" width="100%">
						<tr>
							<td class="label">
								<label for="NombreRef">Nombre: </label>
							</td>
							<td>
								<form:input id="nombreRef" name="nombreRef" path="nombreRef" size="45" onBlur=" ponerMayusculas(this)" tabindex="84" maxlength="50" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="domicilioRef">Domicilio: </label>
							</td>
							<td>
								<form:input id="domicilioRef" name="domicilioRef" path="domicilioRef" size="50" onBlur=" ponerMayusculas(this)" tabindex="85" maxlength="150" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="telefonoRef">Tel&eacute;fono: </label>
							</td>
							<td>
								<form:input id="telefonoRef" name="telefonoRef" path="telefonoRef" size="15" tabindex="86" />
								<label for="lblEXtRef">Ext.:</label>
								<form:input path="extTelefonoRefUno" id="extTelefonoRefUno" name="extTelefonoRefUno" size="10" maxlength="6" tabindex="87" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label>Tipo Relaci&oacute;n:</label>
							</td>
							<td>
								<form:input id="tipoRelacion1" name="tipoRelacion1" path="tipoRelacion1" size="5" tabindex="88" />
								<input type="text" id="descRelacion1" name="descRelacion1" size="40" readonly="true" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="NombreRef2">Nombre: </label>
							</td>
							<td>
								<form:input id="nombreRef2" name="nombreRef2" path="nombreRef2" size="45" onBlur=" ponerMayusculas(this)" tabindex="89" maxlength="50" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="domicilioRef2">Domicilio: </label>
							</td>
							<td>
								<form:input id="domicilioRef2" name="domicilioRef2" path="domicilioRef2" size="50" onBlur=" ponerMayusculas(this)" tabindex="90" maxlength="150" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="telefonoRef2">Tel&eacute;fono: </label>
							</td>
							<td>
								<form:input id="telefonoRef2" name="telefonoRef2" path="telefonoRef2" size="15" tabindex="91" maxlength="10" />
								<label for="lblextTelefonoRefDos">Ext.:</label>
								<form:input path="extTelefonoRefDos" id="extTelefonoRefDos" name="extTelefonoRefDos" size="10" maxlength="6" tabindex="92" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="tipoRelacion2">Tipo Relaci&oacute;n:</label>
							</td>
							<td>
								<form:input id="tipoRelacion2" name="tipoRelacion2" path="tipoRelacion2" size="5" tabindex="93" />
								<input type="text" id="descRelacion2" name="descRelacion2" size="40" readonly="true" />
							</td>
						</tr>
					</table>
				</fieldset>
				<br>
				<div id="datosAdicionalesCteAltoRiesgo">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend class="label">
							Informaci&oacute;n Adicional al
							<s:message code="safilocale.cliente" />
						</legend>
						<table border="0" width="100%">
							<tr>
								<td class="label">
									<label for="preguntaCte1">Pregunta 1.-&nbsp;</label>
								</td>
								<td>
									<textarea rows="2" cols="50" name="preguntaCte1" id="preguntaCte1" autocomplete="off" onBlur="ponerMayusculas(this)" maxlength="100" tabindex="94"></textarea>
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="respuestaCte1">Respuesta 1.-&nbsp;</label>
								</td>
								<td>
									<textarea rows="2" cols="50" name="respuestaCte1" id="respuestaCte1" autocomplete="off" onBlur="ponerMayusculas(this)" maxlength="200" tabindex="95"></textarea>
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="preguntaCte2">Pregunta 2.-&nbsp;</label>
								</td>
								<td>
									<textarea rows="2" cols="50" name="preguntaCte2" id="preguntaCte2" autocomplete="off" onBlur="ponerMayusculas(this)" maxlength="100" tabindex="96"></textarea>
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="respuestaCte2">Respuesta 2.-&nbsp;</label>
								</td>
								<td>
									<textarea rows="2" cols="50" name="respuestaCte2" id="respuestaCte2" autocomplete="off" onBlur="ponerMayusculas(this)" maxlength="200" tabindex="97"></textarea>
							</tr>
							<tr>
								<td class="label">
									<label for="preguntaCte3">Pregunta 3.-&nbsp;</label>
								</td>
								<td>
									<textarea rows="2" cols="50" name="preguntaCte3" id="preguntaCte3" autocomplete="off" onBlur="ponerMayusculas(this)" maxlength="100" tabindex="98"></textarea>
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="respuestaCte3">Respuesta 3.-&nbsp;</label>
								</td>
								<td>
									<textarea rows="2" cols="50" name="respuestaCte3" id="respuestaCte3" autocomplete="off" onBlur="ponerMayusculas(this)" maxlength="200" tabindex="99"></textarea>
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="preguntaCte4">Pregunta 4.-&nbsp;</label>
								</td>
								<td>
									<textarea rows="2" cols="50" name="preguntaCte4" id="preguntaCte4" autocomplete="off" onBlur="ponerMayusculas(this)" maxlength="100" tabindex="100"></textarea>
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="respuestaCte4">Respuesta 4.-&nbsp;</label>
								</td>
								<td>
									<textarea rows="2" cols="50" name="respuestaCte4" id="respuestaCte4" autocomplete="off" onBlur="ponerMayusculas(this)" maxlength="200" tabindex="101"></textarea>
								</td>
							</tr>
						</table>
					</fieldset>
					<br>
				</div>
				<table>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="pFuenteIng">Principal Fuente de Ingresos: </label>
						</td>
						<td>
							<form:input id="pFuenteIng" name="pFuenteIng" path="pFuenteIng" size="45" onBlur="ponerMayusculas(this)" tabindex="102" maxlength="102" />
						</td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap">
							<label for="ingAproxMes">Ing. aprox por mes: </label>
						</td>
						<td class="label">
							<form:radiobutton id="ingAproxMes" name="ingAproxMes" path="ingAproxMes" value="Ing1" tabindex="103" checked="checked" />
							<label for="ing1">Menos de 20,000</label>&nbsp;&nbsp;
						</td>
					</tr>
					<tr>
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="separador"></td>
						<td>
							<form:radiobutton id="ingAproxMes2" name="ingAproxMes" path="ingAproxMes" value="Ing2" tabindex="104" />
							<label for="ing2">20,001 a 50,000</label>&nbsp;&nbsp;
						</td>
					</tr>
					<tr>
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="separador"></td>
						<td>
							<form:radiobutton id="ingAproxMes3" name="ingAproxMes" path="ingAproxMes" value="Ing3" tabindex="105" />
							<label for="ing3">50,001 a 100,000</label>&nbsp;&nbsp;
						</td>
					</tr>
					<tr>
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="separador"></td>
						<td>
							<form:radiobutton id="ingAproxMes4" name="ingAproxMes" path="ingAproxMes" value="Ing4" tabindex="106" />
							<label for="ing3">Mayor a 100,000</label>&nbsp;&nbsp;
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
						<td nowrap="nowrap">
							<form:radiobutton id="evaluaXMatriz1" name="evaluaXMatriz" path="evaluaXMatriz" value="S" checked="checked"  tabindex="108" />
							<label for="evaluaXMatriz"> Si</label> &nbsp;&nbsp;&nbsp;&nbsp;
							<form:radiobutton id="evaluaXMatriz2" name="evaluaXMatriz" path="evaluaXMatriz" value="N" tabindex="109"/>
							<label for="evaluaXMatriz"> No</label>
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
						<td align="right" colspan="5">
							<input type="submit" id="agrega" tabindex="111" name="agrega" class="submit" value="Agregar" />
							<input type="submit" id="modifica" tabindex="112" name="modifica" class="submit" value="Modificar" />
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
							<input type="hidden" id="alertSocio" name="alertSocio" value="<s:message code="safilocale.cliente"/>" />
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
</html>