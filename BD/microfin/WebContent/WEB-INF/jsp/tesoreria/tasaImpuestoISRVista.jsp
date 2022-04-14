<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/paisesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/tasaImpuestoISRServicio.js"></script>
<script type="text/javascript" src="js/tesoreria/tasaImpuestoISR.js"></script>
<script type="text/javascript" src="js/forma.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" target="_blank" commandName="tasaImpuestoISRBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">&nbsp;Tasa Impuesto ISR&nbsp;</legend>
				<table border="0" width="100%">
					<tr>
						<td class="label">
							<label for="tasaImpuestoID">Tasa: </label>
						</td>
						<td>
							<form:input id="tasaImpuestoID" name="tasaImpuestoID" path="tasaImpuestoID" size="4" tabindex="1" />
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="nombre">Nombre: </label>
						</td>
						<td>
							<form:input id="nombre" name="nombre" path="nombre"	size="25" tabindex="2" maxlength="45" onBlur=" ponerMayusculas(this)" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="descripcion">Descripci&oacute;n:</label>
						</td>
						<td>
							<form:input id="descripcion" name="descripcion" path="descripcion" size="45" tabindex="3" maxlength="100" onBlur=" ponerMayusculas(this)" />
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="tasaNacional">Tipo Tasa: </label>
						</td>
						<td class="label" nowrap="nowrap">
							<form:radiobutton id="tasaNacional" name="tipoTasa" path="tipoTasa" value="N" tabindex="4" checked="checked"/>
		 					<label for="tasaNacional">Nacional</label>
							<form:radiobutton id="tasaResExt" name="tipoTasa" path="tipoTasa" value="E" tabindex="4"/>
							<label for="tasaResExt">Residentes en el Extranjero</label>
 						</td>
						<td class="separador"></td>
						<td class="label tdPaisExt">
							<label for="paisID">Pa&iacute;s: </label>
						</td>
						<td class="tdPaisExt">
							<form:input type="text" id="paisID" name="paisID" path="paisID" size="6" tabindex="5" onBlur=" ponerMayusculas(this)" autocomplete="off" />
							<input type="text" id="nombrePais" name="nombrePais" size="38" disabled="true" readOnly="true" tabindex="15" />
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="valorAnt">Tasa Actual: </label>
						</td>
						<td>
							<form:input id="valorAnt" name="valorAnt" path="valorAnt" size="7" esMoneda="true" style="text-align: right;" readonly="true"  disabled="true"/>
						</td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap">
							<label for="valor">Nueva Tasa: </label>
						</td>
						<td>
							<form:input id="valor" name="valor" path="valor" size="7" esMoneda="true" style="text-align: right;" tabindex="6"/>
						</td>
					</tr>
					<tr><td class="label" nowrap="nowrap">
							<label for="fechaAnt">Fecha &Uacute;ltima Actualizaci&oacute;n:</label>
						</td>
						<td id="tdFechaAnt">
							<form:input id="fechaAnt" name="fechaAnt" path="fechaAnt" size="11" readonly="true"  disabled="true"/>
						</td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap">
							<label for="fechaValor">Inicio Nueva Vigencia:</label>
						</td>
						<td id="tdFechaValor">
							<form:input id="fechaValor" name="fechaValor" path="fechaValor" size="11" tabindex="7" esCalendario="true"/>
						</td>
					</tr>
					<tr>
						<td colspan="5">
							<table align="right">
								<tr>
									<td align="right">
										<input type="submit" id="graba" name="graba" class="submit" value="Grabar" tabindex="8" />
										<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="" />
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</fieldset>
		</form:form>
	</div>
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista" ></div>
	</div>
</body>
<div id="mensaje" style="display: none;" ></div>
</html>