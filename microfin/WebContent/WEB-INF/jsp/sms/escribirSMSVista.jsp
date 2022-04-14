<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>   
  	    <script type="text/javascript" src="dwr/interface/parametrosSMSServicio.js"></script>
  	    <script type="text/javascript" src="dwr/interface/campaniasServicio.js"></script> 
  	    <script type="text/javascript" src="dwr/interface/smsPlantillaServicio.js"></script>
  	    <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
		<script type="text/javascript" src="js/sms/enviarsms.js"></script>  
	</head>
<body>

<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="smsEnvioMensajeBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Escribir SMS</legend>			
	<table >
	 	<tr>
	 		<td class="label">
				<label for="Campania">Número de Campa&ntilde;a: </label>
			</td> 
			<td >		
				<form:input type="text" id="campaniaID" name="campaniaID" tabindex="1" path="campaniaID" size="6" autocomplete="off" maxlength="10"/>
				<input type="text" id="nombreCampania" name="nombreCampania" size="60" disabled="true"/> 
			</td>
		</tr>
	 	<tr>
			<td>
				<form:input id="remitente" name="remitente" path="remitente"  onBlur="" value="1" size="20" disabled="true" style="display: none;"/> 
			</td>
		</tr>
		<tr>
			<td class="label">
				<label for="lblDestinatario">Destinatario:</label>
			</td>
			<td>
				<form:input id="receptor" name="receptor" path="receptor" tabindex="2" onBlur=""  size="20" maxlength="10"/> 
			</td>		
								
		</tr>
		<tr>
			<td class="label">
				<label>Cargar Plantilla</label>
			</td>
			<td>
				<select id="listaPlantilla" name="listaPlantilla"	tabindex="3" ></select>
			</td>
		</tr>
		<tr>   
			<td class="label">
				<label for="lblTexto"> Texto a enviar: </label>
			</td>
			<td>
				<form:textarea id="msjenviar" name="msjenviar" path="msjenviar"  class="contador" tabindex="4" cols="30" rows="5" maxlength="160" onblur="ponerMayusculas(this)"/>
				 <div>
				<label for="longitud_textarea" id="longitud_textarea" name="longitud_textarea"></label>
				</div>
			
			</td>
		</tr>
		<tr>
			<td></td>
			
		</tr>
			<input type="hidden" id="codigosRespuesta" name="codigosRespuesta" size="100" />	
			<div id="gridCodigosResp" style="display: none;" />	
										
	</table>
		<table align="right">
			<tr>
				<td align="right">
					<input type="submit" id="enviar" name="enviar" class="submit" value="Enviar" tabindex="6"/>
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
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