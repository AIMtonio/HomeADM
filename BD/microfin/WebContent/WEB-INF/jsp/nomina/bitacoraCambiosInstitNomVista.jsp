<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
	<script type="text/javascript"	src="dwr/interface/institucionNomServicio.js"></script>
	<script type="text/javascript"	src="dwr/interface/conveniosNominaServicio.js"></script>
	<script type="text/javascript"	src="dwr/interface/bitacoraConveniosNominaServicio.js"></script>
	<script type="text/javascript" src="js/nomina/bitacoraCambiosInstitNom.js"></script>

	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="convenioNominaBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Bit&aacute;cora Cambios Par&aacute;metros Empresas N&oacute;mina</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="label">
								<label for="institNominaID">Empresa N&oacute;mina:</label>
							</td>
							<td>
	       		 				<input type="text" id="institNominaID" name="institNominaID" size="14" tabindex="1" maxlength="9" />
	       		 				<input type="text" id="nombreInstit" name="nombreInstit" onBlur=" ponerMayusculas(this)" size="40" maxlength="100" disabled="true" readonly="true" />
							</td>
								<td class="separador"></td>
							<td>
								<label for="convenioNominaID">No Convenio:</label>
							</td>
							<td>
								<select name="convenioNominaID" id="convenioNominaID" path="convenioNominaID" tabindex="3">
									<option value="">TODOS</option>
								</select>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="fechaInicio">Fecha Inicio:</label>
							</td>
							<td>
								<input type="text" id="fechaInicio" name="fechaInicio" esCalendario="true" size="14" tabindex="4"  maxlength="10"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="fechaFin">Fecha Fin:</label>
							</td>
							<td>
								<input type="text" id="fechaFin" name="fechaFin" esCalendario="true" size="14" tabindex="5"  maxlength="10" />
							</td>
						</tr>
					</table>
					<table align="right">
						<tr >
								<td align="right">
									<input type="button" id="consultar" name="consultar" class="submit" value="Consultar" tabindex="8" />
								</td>
						</tr>
					</table>
					<br>
					<div id="formaTabla" style="display: none;"></div>
			</fieldset>
		</form:form>
	</div>
	<div id="cargando" style="display: none;">
	</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>