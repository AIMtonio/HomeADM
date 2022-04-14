<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
<head>
		<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cajasVentanillaServicio.js"></script>
		<script type="text/javascript" src="js/ventanilla/cajasVentanillaApert.js"></script> 
</head>
<body>


<div id="contenedorForma">
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cajasVentanillaBean">
	<fieldset class="ui-widget ui-widget-content ui-corner-all" >
	<legend class="ui-widget ui-widget-header ui-corner-all">Apertura de Día de Caja</legend>
	<table border="0" cellpadding="0" cellspacing="0" width="100%">		
		<tr>
			<td class="label"><label for="lblFecha">Fecha:</label></td>
			<td><input type="text" id="fecha" name="fecha" tabindex="" path="fecha" size="10" disabled="true" tabindex="1"/></td>
			<td class="separador"></td>
	 		<td class="label">
	 			<label for="lblSucursal">Sucursal</label>
	 		</td>
	 		<td>
	 			<form:input type="text" id="sucursalID" name="sucursalID" path="sucursalID" size = "6" disabled="true" tabindex="2"/>
	 			<input type="text" id="dessucursal" name="dessucursal" size = "37" disabled="true" tabindex="3"/>
	 		</td>
		</tr>
		<tr>
	 		<td class="label"><label for="lblCaja">Caja</label></td>
	 		<td>
	 			<form:select id="cajaID" name="cajaID" path="cajaID" tabindex="4">
	 				<option value="0">Selecciona:</option>
				</form:select>
	 		</td>
		</tr>
	</table>
	<table align="right">
		<tr>
			<td >
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
				<input type="submit" id="apert" name="apert" class="submit" value="Aperturar Caja" tabindex="5"  />    
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