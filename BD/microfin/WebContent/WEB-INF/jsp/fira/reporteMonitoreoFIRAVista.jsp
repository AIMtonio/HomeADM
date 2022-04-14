<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/catReportesFIRAServicio.js"></script>
<script type="text/javascript" src="dwr/interface/monitorProyeccionServicio.js"></script>
<script type="text/javascript" src="dwr/interface/monitorExcedentesServicio.js"></script>
<script type="text/javascript" src="js/fira/repMonitoreoFIRA.js"></script>
<script type="text/javascript" src="js/utileria.js"></script>
<script type="text/javascript" src="js/gridviewscroll.js"></script>

</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="catReportesFIRABean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Archivos de Monitoreo FIRA</legend>
				<table border="0" width="100%">
					<tr>
						<td class="label">
							<label for="tipoReporteID">Tipo de Reporte:</label>
						</td>
						<td>
							<form:select id="tipoReporteID" name="tipoReporteID" path="tipoReporteID" tabindex="1">
								<form:option value="">SELECCIONAR</form:option>
							</form:select>
						</td>
						<td class="separador"></td>
						<td class="fechaReporte">
							<label for="fechaReporte">Fecha: </label>
						</td>
						<td class="fechaReporte">
							<form:input id="fechaReporte" name="fechaReporte" path="fechaReporte" size="12" tabindex="2" esCalendario="true" />
						</td>
						<td class="anio" style="display: none"> 
							<label for="anio">Año: </label> 
						</td> 
						<td class="anio" style="display: none">
							<select id="anio" name="anio" tabindex="1">
							</select>
						</td>
						<td>
							<input id="periodoReporte" name="periodoReporte" size="12" type="hidden" iniforma="false" />
						</td>
					</tr>
					<tr class="cargaArchivo" style="display: none">
						<td class="archivofira"><label for="calCartFira">Calificaci&oacute;n Cartera FIRA:</label></td>
						<td class="archivofira">
							<input type="text" id="calCartFira" name="calCartFira" disabled="disabled">
							<input type="hidden" id="rutaFinalCalCartFira" name="rutaFinalCalCartFira" disabled="disabled">
							<input type="button" id="adjuntarCaliCartFira" tabindex="80" name="adjuntarCaliCartFira" class="submit" value="Adjuntar" />
						</td>
						<td class="separador archivofira"></td>
						<td class="label">
							<label for="archivoRes">Archivo Reserva:</label>
						</td>
						<td>
							<input type="text" id="archivoRes" name="archivoRes" disabled="disabled">
							<input type="hidden" id="rutaFinalArchivoRes" name="rutaFinalArchivoRes" disabled="disabled">
							<input type="button" id="adjuntarArchReserva" tabindex="80" name="adjuntarArchReserva" class="submit" value="Adjuntar" />
						</td>
					</tr>					
													
				</table>

				<table >
					<tr class="cargaProyeccion" style="display: none">
								<td>
									<fieldset class="ui-widget ui-widget-content ui-corner-all" id="fieldsetLisProyeccion" >
									<legend >Proyecciones	</legend>	
									<div id="divGridProyeccion" style="width: 100%;"></div>	
									</fieldset>	
								</td>									
					</tr>
					<tr class="cargaExcedentes" style="display: none">
								<td>
									<fieldset class="ui-widget ui-widget-content ui-corner-all" id="fieldsetLisProyeccion" >
									<legend >Excedentes de Riesgo	</legend>	
									<div id="divGridExcedentes" style="width: 100%;"></div>	
									</fieldset>	
								</td>									
					</tr>
				</table>

				<table align="right">
					<tr>
						<td align="right">
						<input type="button" id="grabar" name="grabar" class="submit" tabindex="7" value="Grabar" />
						 <input type="button" id="modificar" name="modificar" class="submit" tabindex="8" value="Modificar" /> 
						<input type="button" id="generar" name="generar" class="submit" tabindex="9" value="Generar" />
						 <input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
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
</body>
<div id="mensaje" style="display: none; position: absolute; z-index: 999;"></div>
</html>