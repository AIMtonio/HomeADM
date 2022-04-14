<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/opIntPreocupantesServicio.js"></script>
		<script type="text/javascript" src="js/pld/pldOpeInternas.js"></script>
	</head>
<body>
<div id="contenedorForma">

<form:form id="formaGenerica" name="formaGenerica"    method="POST" commandName="opeInternas">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de Operaciones Internas Preocupantes</legend>
			<table border="0" width="100%">
				<tr>
					<td class="label">
						<label for="fechaActual">Fecha Actual: </label>
					 </td>
					<td class="label">
						<input id="fechaActual" name="fechaActual"  size="12" tabindex="1" disabled="true" />
					 </td>
				 </tr>
				<tr>
					 <td class="label">
						<label for="archivo">Nombre del archivo: </label>
					</td>
					<td class="label">
						<form:input id="nombreArchivo" name="nombreArchivo" path="nombreArchivo" size="40" tabindex="2" disabled="true"/>
					</td>
				</tr>
		</table>
	<input type="hidden"  id="rutaArchivosPLD" name="rutaArchivosPLD"  size="40" tabindex="2" disabled="true"/>
		<table align="right" id="botonesReporte">
			<tr>
				<td align="right">
					<input type="button" id="generarNombre" name="generarNombre" class="submit" tabindex="5" value="Generar Nombre"/>
					<input type="button" id="generarArchivo" name="generarArchivo" class="submit" tabindex="5" value="Generar Archivo"/>
					<input type="button" id="generarExcel" name="generarExcel" class="submit" tabindex="7" value="Generar Excel" />
					<input type="button" id="descargar" name="descargar" class="submit" tabindex="8" value="Descargar Archivo PLD" />
					<input type="hidden" id="tipoActualizacion" name="tipoActualizacion" value="0"/>
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"  value="0" />
					<input type="hidden" id="periodoInicio" name="periodoInicio" value="1900-01-01" />
					<input type="hidden" id="periodoFin" name="periodoFin" value="1900-01-01" />
				</td>
			</tr>
	  </table>
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