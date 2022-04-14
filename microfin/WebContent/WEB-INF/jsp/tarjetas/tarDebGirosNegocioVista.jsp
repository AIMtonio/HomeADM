<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>  
<html>
<head>
		<script type="text/javascript" src="dwr/interface/giroNegocioTarDebServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tipoTarjetaDebServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tarDebGirosAcepIndividualServicio.js"></script>
	 	<script type="text/javascript" src="dwr/interface/tarDebGirosNegocioServicio.js"></script> 
      <script type="text/javascript" src="js/tarjetas/tarDebGirosNegocio.js"></script>     
</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="girosNegociosTipoTarjeta">
<fieldset class="ui-widget ui-widget-content ui-corner-all">
<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Giros de Negocio No Permitidos por Tipo Tarjeta</legend>
	<table border="0" width="100%">
		<tr>
			<td class="label">
					<label for="lblTipoTarjeta">Tipo de Tarjeta:</label>
				</td>
				<td>
				   <input type="text" id="tipoTarjetaDebID" name="tipoTarjetaDebID" maxlength="10" size="10" tabindex="1" />
					<input type="text" id="nombreTarjeta" name="nombreTarjeta" onblur="ponerMayusculas(this)" size="50" readOnly="true" />
					<input type="text" id="tipo" name="tipo" onblur="ponerMayusculas(this)" size="10" readOnly="true" />
				</td>
		</tr>
	</table>
	<br>
	<div id="gridGiros">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Giros</legend>
			<input type="button" id="agregaGiros" name="agregaGiros" value="Agregar" class="botonGral" onClick="agregarGirosAceptados()" tabindex="2" />
			<div id="girosNegocioTipoTarjeta" style="display: none;"></div>	
	</fieldset>
	</div>
	<br>
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td align="right">
				<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="3" />
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/> 
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
<div id="mensaje" style="display: none;"></div>
</html>