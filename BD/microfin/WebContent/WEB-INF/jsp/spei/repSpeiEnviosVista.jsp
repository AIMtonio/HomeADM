<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
 <%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
		<script type="text/javascript" src="js/spei/repSpeiEnvios.js"></script>
	</head>

<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="repSpeiEnvios">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend class="ui-widget ui-widget-header ui-corner-all">Reporte SPEI Env&iacute;os</legend>
		<table border="0" cellpadding="0" cellspacing="0" width="600px">
			<tr>
				<td style="display: block;">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend><label>Par&aacute;metros</label></legend>
          				<table  border="0"  width="560px">
							<tr>
								<td class="label">
									<label for="fechaInicio">Fecha de Inicio: </label>
								</td>
								<td >
									<input id="fechaInicio" name="fechaInicio"  size="12" tabindex="1" type="text" esCalendario="true" />
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="fechaFin">Fecha de Fin: </label>
								</td>
								<td>
									<input id="fechaFin" name="fechaFin"  size="12" tabindex="2" type="text" esCalendario="true"/>
								</td>
							</tr>
						   	<tr>
								<td class="label">
						        	<label for="montoTransferIni">Rango de Montos de: </label>
							     </td>
							     <td nowrap= "nowrap">
									 <input id="montoTransferIni" name="montoTransferIni" size="12" tabindex="3"
									 		style="text-align: right" esMoneda="true"/>
							         <label for="montoTransferFin"> a&nbsp;</label>
									 <input id="montoTransferFin" name="montoTransferFin" size="12" tabindex="4"
									 		style="text-align: right" esMoneda="true"/>
							     </td>
							</tr>
							<tr>
								<td class="label">
									<label for="cuentaAhoID">Cuenta de Ahorro:</label>
								</td>
								<td nowrap= "nowrap">
									<input id="cuentaAhoID" name="cuentaAhoID" tabindex="5" size="14"/>
									<input type="text"id="nombreCliente" name="nombreCliente" size="40" readOnly="true" disabled="true"/>
								</td>
				        	</tr>
						</table>
					</fieldset>
				</td>

				<td>
					<table>
						<tr>
							<td>
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend><label>Presentaci&oacute;n</label></legend>
									<input type="radio" id="excel" name="tipoRpt" value="1" tabindex="6" />
									<label> Excel </label>
				            		<br>
								</fieldset>
							</td>
						</tr>
						<tr>
							<td>
								<br><br><br><br>
							</td>
						</tr>
						<tr>
							<td align="right">
								<input type="hidden" id="tipoLista" name="tipoLista" />
								<a id="ligaGenerar">
									 <input type="button" id="generar" name="generar" class="submit"
											 tabIndex = "7" value="Generar" />
								</a>
							</td>
						</tr>
					</table>

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