<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/prospectosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/paramGuardaValoresServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/documentosGuardaValoresServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/catInstGuardaValoresServicio.js"></script>
		<script type="text/javascript" src="js/guardaValores/consultaDocumentosVista.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="documentosGuardaValoresBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Consulta de Documentos</legend>
					<br>
					<table width="100%">
						<tr>
							<td class="label">
								<label for="tipoInstrumento">Tipo Instrumento:</label>
							</td>
							<td>
								<select id="tipoInstrumento" name="tipoInstrumento" path="tipoInstrumento" tabindex="1">
									<option value="0">SELECCIONA</option>
								</select>
							</td>
						<tr>
						</tr>
							<td>
								<label for="numeroExpedienteID">N&#250;mero Participante:</label>
							</td>
							<td>
								<input id="numeroExpedienteID" name="numeroExpedienteID" path="numeroExpedienteID" size="15" tabindex="2"  type="text" iniforma="false"  autocomplete="off"/>
								<input id="nombreParticipante" name="nombreParticipante" size="75" maxlength="100" type="text" disabled="disabled" />
							</td>
						</tr>
					</table>
					<input type="hidden" id="sucursalID" name="sucursalID" size="11" maxlength="11"/>
					<input type="hidden" id="tipoPersona" name="tipoPersona" size="11" maxlength="11"/>
					<input type="hidden" id="tipoMensaje"  value="<s:message code='safilocale.cliente'/>" />
					<div id="expedientesRegistradosGridCliente"></div>
					<div id="expedientesRegistradosGridCuenta"></div>
					<div id="expedientesRegistradosGridCede"></div>
					<div id="expedientesRegistradosGridInversion"></div>
					<div id="expedientesRegistradosGridSolicitudCredito"></div>
					<div id="expedientesRegistradosGridCredito"></div>
					<div id="expedientesRegistradosGridProspecto"></div>
					<div id="expedientesRegistradosGridAportacion"></div>
					<br>
					<table align="right">
						<tr>
							<td align="right">
								<input type="button" id="consulta" name="consulta" class="submit" value="Consultar" tabindex="2" />
							</td>
							<td align="right">
								<a id="ligaGenerar" href="reporteDocumentosGrdValExcel.htm" target="_blank" >
									<input type="button" id="generar" name="generar" class="submit" value="Generar" tabindex="3" />
								</a>
							</td>
							<td align="right">
								<input type="button" id="cancelar" name="cancelar" class="submit" value="Cancelar" tabindex="4" />
							</td>
						</tr>
					</table>
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