<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cedesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/inversionServicioScript.js"></script>
		<script type="text/javascript" src="dwr/interface/solicitudCredServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/prospectosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/aportacionesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/catOrigenesDocumentosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/catInstGuardaValoresServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/paramGuardaValoresServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clasificaGrpDoctosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/grupoDocumentosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tiposDocumentosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/solicitudCheckListServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/creditoDocEntServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/documentosGuardaValoresServicio.js"></script>
		<script type="text/javascript" src="js/guardaValores/documentosGuardaValores.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="documentosGuardaValoresBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Registro Documentos</legend>
					<br>
					<table width="100%">
						<tr>
							<td>
									<label for="numeroExpedienteID">No. Expediente:</label>
							</td>
							<td>
								<form:input id="numeroExpedienteID" name="numeroExpedienteID" path="numeroExpedienteID" size="12" tabindex="1"  type="text" iniforma="false" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="fechaRegistro">Fecha Registro: </label>
							</td>
							<td>
								<form:input id="fechaRegistro" name="fechaRegistro" path="fechaRegistro" size="12" tabindex="2" type="text" disabled="disabled"  />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="sucursalID">Sucursal:</label>
							</td>
							<td>
								<form:input id="sucursalID" name="sucursalID" size="12" path="sucursalID" tabindex="3" type="text" iniforma="false" />
								<input id="nombreSucursal" name="nombreSucursal" size="50" type="text" disabled="disabled" />
							</td>
							<td class="separador"></td>
							<td>
								<label for="origenDocumento">Tipo Instrumento:</label>
							</td>
							<td>
								<form:select id="tipoInstrumento" name="tipoInstrumento" path="tipoInstrumento" tabindex="4">
									<form:option value="0">TODOS</form:option>
								</form:select>
							</td>
						</tr>
						<tr>
							<td>
								<label for="numeroInstrumento">No. Instrumento:</label>
							</td>
							<td>
								<form:input id="numeroInstrumento" name="numeroInstrumento" path="numeroInstrumento" size="12" tabindex="5"  type="text" iniforma="false" />
								<input id="nombreNumeroInstrumento" name="nombreNumeroInstrumento" size="50" maxlength="200" type="text" disabled="disabled" />
							</td>
						</tr>
					</table>
					<input type="hidden" id="manejaCheckList" name="manejaCheckList" size="50" />
					<input type="hidden" id="manejaDigitalizacion" name="manejaDigitalizacion" size="50" />
					<input type="hidden" id="tipoPersona" name="tipoPersona" size="50" />
					<input type="hidden" id="productoCreditoID" name="productoCreditoID" size="50" />
					<input type="hidden" id="tipoMensaje"  value="<s:message code='safilocale.cliente'/>" />
					<br>
					<div id="registradosExpedienteGrid"></div>
					<div id="documentosRegistradosGrid"></div>
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
					<input type="hidden" id="numeroDetalle" name="numeroDetalle" value="0"/>
					<div id="guardar">
						<table align="right">
							<tr>
								<td align="right">
									<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar"  />
								</td>
								<td align="right">
									<input type="button" id="cancelar" name="cancelar" class="submit" value="Cancelar"/>
								</td>
							</tr>
						</table>
					</div>
				</fieldset>
			</form:form>
		</div>

		<div id="cargando" style="display: none;">
		</div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"/>
		</div>
	</body>
	<div id="mensaje" style="display: none;"/>
</html>