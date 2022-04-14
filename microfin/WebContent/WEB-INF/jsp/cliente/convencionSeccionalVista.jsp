<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>  
<html>
<head>
	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/convencionSeccionalServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/convenSecPreinsServicio.js"></script> 
	 <script type="text/javascript" src="js/cliente/convencionSeccional.js"></script>

</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="convencionSeccional">
<fieldset class="ui-widget ui-widget-content ui-corner-all">
<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Fechas para Convenciones Seccionales</legend>
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td class="label">
					<label for="lblFechaSis">Fecha del Sistema:</label>
					<input type="text" id="fechaSis" name="fechaSis" readOnly="true" disabled = "true"/>
				</td>
		</tr>
	</table>
	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Fechas</legend>
			<input type="hidden" id="datosGrid" name="datosGrid" size="100" />	
			<input type="button" id="agregarConve" name="agregarConve" value="Agregar" class="submit" onClick="agregarConvencionSeccional()" tabindex="1" />
			<div id="divConvencionesSeccionales" style="display: none;"></div>	
	</fieldset>

	<br>
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td align="right">
				<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="2" />
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