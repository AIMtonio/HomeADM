<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
	    <script type="text/javascript" src="dwr/interface/campaniasServicio.js"></script>
		<script type="text/javascript" src="js/sms/repActividadSms.js"></script>
	</head>
<body>

<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="resumenActividadSMS">
<fieldset class="ui-widget ui-widget-content ui-corner-all">
<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de Actividad de Env&iacute;o SMS</legend>
	<table >
		<tr>
			<td class="label">
				<label>Fecha Inicio: </label>
			</td>
			<td>
				<form:input id="fechaInicio" name="fechaInicio" path="fechaInicio" esCalendario="true" tabindex="1" size="12" />
			</td>
		</tr>
		<tr>
			<td class="label">
				<label>Fecha Fin: </label>
			</td>
			<td>
				<form:input id="fechaFin" name="fechaFin" path="fechaFin" esCalendario="true" tabindex="2" size="12" /> 
			</td>
		</tr>
	 	<tr>
	 		<td class="label">
				<label for="Campania">Número de Campa&ntilde;a: </label>
			</td>
			<td colspan="4">
				<form:input type="text" id="campaniaID" name="campaniaID" tabindex="3" path="campaniaID" size="8" autocomplete="off"/>
				<input type="text" id="nombreCampania" name="nombreCampania" size="45" disabled="true"/>
			</td>
		</tr>
		<tr>
			<td class="label">
				<label for="lblEstatus">Estatus:</label>
			</td>
			<td>
				<input type="radio" id="enviado" name="estatus" path="estatus" value="E" tabindex="4" /><label>Enviados</label>
				<input type="radio" id="noEnviado" name="estatus" path="estatus" value="N" tabindex="5" /><label>No Enviados</label>
				<input type="radio" id="cancelado" name="estatus" path="estatus" value="C" tabindex="6" /><label>Cancelados</label>
			</td>
		</tr>
	</table>
	<input type="hidden" id="tipoReporte" name="tipoReporte" />
	<input type="hidden" id="tipoLista" name="tipoLista" />
	<table align="right">
		<tr>
			<td align="right">
				<a id="ligaGenerar" href="RepActividadEnvioSMS.htm" target="_blank" >  		 
					 <input type="button" id="generar" name="generar" class="submit" tabindex="7" 
							 tabIndex="48" value="Generar" />
				</a>
			</td>
		</tr>
	</table>
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