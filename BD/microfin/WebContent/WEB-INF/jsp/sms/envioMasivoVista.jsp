<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>   
  	    <script type="text/javascript" src="dwr/interface/SmsEnvioMensajeServicio.js"></script>
  	    <script type="text/javascript" src="dwr/interface/parametrosSMSServicio.js"></script>
  	    <script type="text/javascript" src="dwr/interface/campaniasServicio.js"></script>
  	    <script type="text/javascript" src="dwr/interface/smsCondiciCargaServicio.js"></script>
  	    <script type="text/javascript" src="dwr/interface/smsPlantillaServicio.js"></script>
  	     <script type="text/javascript" src="js/jquery.maskedinput-1.3.min.js" ></script>
		<script type="text/javascript" src="js/sms/enviomasivo.js"></script>
	</head>
<body>

<div id="contenedorForma">
<form:form method="post" id="formaGenerica" name="formaGenerica"
commandName="smsEnvioMensajeBean" enctype="multipart/form-data">
<fieldset class="ui-widget ui-widget-content ui-corner-all">
<legend class="ui-widget ui-widget-header ui-corner-all">Env&iacute;o Masivo de SMS</legend>			
	<table >
	 	<tr>
	 		<td class="label">
				<label for="Campania">Número de Campa&ntilde;a: </label>
			</td>
			<td>
				<form:input type="text" id="campaniaID" name="campaniaID" tabindex="1" path="campaniaID" size="6" autocomplete="off" maxlength="10"/>
				<input type="text" id="nombreCampania" name="nombreCampania" size="60" disabled="true"/> 
			</td>
		</tr>
	 	<tr>
			<td>
				<form:input id="remitente" name="remitente" path="remitente" value="1" onBlur=""  size="20" disabled="true" style="display: none;"/> 
			</td>
		</tr>
		
		<tr>
			<td class="label">
				<label for="lblArchivo">Subir Destinatarios (.CSV)</label>
			</td>
			<td>
				<input type="button" id="adjuntar" name="adjuntar" class="submit" tabindex="2" value="Adjuntar" />
				<input type="hidden" id="rutahidden" name="rutahidden"/>
			</td>
		</tr>
		
		 <tr>
			<td align="right"><input type="checkbox" id="txtgeneral" name="txtgeneral"  tabindex="3"/></td>	
			<td class="label">
				<label  for="lblTxt"> Enviar Texto General </label>
			</td>
		</tr>
		<tr>
			<td class="label">
				<label  id="lbPlantilla" style="display:none">Cargar Plantilla</label>
			</td>
			<td>
				<select id="listaPlantilla" name="listaPlantilla"  style="display:none"></select>
			</td>
		</tr>
		<tr>
			<td class="label">
				<label id="lblTexto" for="lblTexto" style="display:none"> Texto a enviar: </label>
			</td>
			<td>
				<form:textarea id="msjenviar" name="msjenviar"  class="contador" path="msjenviar" tabindex="4" cols="30" rows="5" maxlength="160"  style="display:none"  onblur="ponerMayusculas(this)"/>
				 <div>
				<label for="longitud_textarea" id="longitud_textarea" name="longitud_textarea" style="display:none" ></label>
				</div>
			</td>
		</tr>
		
		<tr>
			<td class="label">
				<label for="lblOpcion">Opci&oacute;n de Envio:</label>
			</td>
			<td class="label" colspan="">
				<input type="radio" id="opcEnvio" name="opcEnvio" value="1" tabindex="5" /><label for="opc1">Ahora</label>
				<input type="radio" id="opcEnvio" name="opcEnvio" value="2" tabindex="6" /><label for="opc2">Horario</label>
				<input type="radio" id="opcEnvio" name="opcEnvio" value="3" tabindex="7" /><label for="opc3">Calendario</label>
			</td>
		</tr>
		<tr>
			<td></td>
			<td id="tdFecha" style="display:none">
				<label for="lblFecha">Fecha:</label>
				<input type="text" name="fechaEnvio" id="fechaEnvio" autocomplete="off" esCalendario="true" size="12" readonly="true" tabindex="8" />				
				<label for="lblHora">Hora:</label>
				<input type="text" name="horaEnvio" id="horaEnvio" size="5" tabindex="9" maxlength="5"/><label>HH:MM</label>
				<form:input type="hidden" id="fechaProgEnvio" name="fechaProgEnvio" path="fechaProgEnvio" />
			</td>
		</tr>
		<tr id="calendario1" class="trCalendar" style="display:none">
			<td></td>
			<td>
				<label for="lblFechaInicio">Fecha Inicio:</label>
				<input type="text" name="fechaInicio" id="fechaInicio" autocomplete="off" esCalendario="true" size="12" readonly="true" tabindex="10" />
				<label for="lblFechaFin">Fecha Fin:</label>
				<input type="text" id="fechaFin" name="fechaFin" autocomplete="off" esCalendario="true" size="12" readonly="true" tabindex="11" />
			</td>
		</tr>
		<tr id="calendario2" class="trCalendar" style="display:none">
			<td></td>
			<td>
				<label for="lblPeriodicidad">Periodicidad:</label>
				<select id="periodicidad" name="periodicidad">
					<option value="D">Diario</option>
					<option value="S">Semanal</option>
					<option value="Q">Quincenal</option>
					<option value="M">Mensual</option>
					<option value="B">Bimestral</option>
					<option value="A">Anual</option>
				</select>
				<label for="lblHoraPeriodicidad">Hora:</label>
				<input type="text" id="horaPeriodicidad" name="horaPeriodicidad" size="5" maxlength="5"  /><label>HH:MM:</label>
				<input type="button" id="simular" name="simular" class="submit" value="Simular" />
			</td>
		</tr>
		<tr class="trTipoEnvio">
			<td >
				<label for="lblTipo">Tipo de Env&iacute;o:</label>
			</td>
			<td class="label">
				<input type="radio" id="tipoEnvio" name="tipoEnvio" value="U" tabindex="9" /><label for="opc1">Una Vez</label>
				<input type="radio" id="tipoEnvio" name="tipoEnvio" value="R" tabindex="10" /><label for="opc2">Repetido</label>
			</td>
		</tr>
		<tr class="trTipoEnvio">
			<td></td>
			<td id="tipoPro" style="display:none">
				<label for="lblNoVeces">No. Veces:</label>
				<input type="text" id="noVeces" name="noVeces" tabindex="11" size="3"/>
				<label for="lblTiempoDistancia">Tiempo de distancia:</label>
				<input type="text" id="distancia" name="distancia" tabindex="12" size="5"/>
			</td>
		</tr>
	</table>
	<div id="gridCalendarioSMS" style="display: none;">	</div>
	<div id="gridCodigosResp" style="display: none;" />					
	<input type="hidden" id="listaFechas" name="listaFechas" size="100" />
	<table align="right">
			<tr>
				<td align="right">
					<input type="submit" id="aceptar" name="aceptar" class="submit" value="Enviar" tabindex="13"/>
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
					<input type="hidden" id="tipoLista" name="tipoLista"/>
					<input type="hidden" id="numTrans" name="numTrans"/>
					<input type="hidden" id="numFilas" name="numFilas"/>
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