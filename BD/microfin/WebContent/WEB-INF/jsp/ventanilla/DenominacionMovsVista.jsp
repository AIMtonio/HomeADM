<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cajasVentanillaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/denominacionMovsServicio.js"></script>
		<script type="text/javascript" src="js/ventanilla/denominacionMovs.js"></script>
	</head>
<body>

<div id="contenedorForma">
<form:form method="post" id="formaGenerica" name="formaGenerica" commandName="denominacionMovsBean" >
<fieldset class="ui-widget ui-widget-content ui-corner-all">
<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de Denominaciones</legend>			
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
	 	<tr>
	 		<td class="label">
				<label for="lblFecha">Fecha:</label>
			</td>
			<td>
				<input type="text" id="fecha" name="fecha" tabindex="1" path="fecha" size="10"  autocomplete="off" esCalendario="true" />
			</td>
			<td>
				<label>Sucursal:</label>
			</td>
			<td>
				<input type="text" id="nomSucursal" name="nomSucursal" disabled="true" style="display:none">
				<form:select id="sucursalID" name="sucursalID" path="sucursalID" tabindex="5">
					<form:option value="0">Selecciona:</form:option>
				</form:select>
			</td>
		</tr>
		<tr>
			<td>
				<label>Moneda:</label>
			</td>
			<td>
				<form:select id="monedaID" name="monedaID" path="monedaID" tabindex="6" disabled="true">
					<form:option value="0">Selecciona:</form:option>
				</form:select>
			</td>
			<td class="label">
				<label>Caja:</label>
			</td>
			<td>
				<form:input id="cajaID" name="cajaID" path="cajaID" size="12" tabindex="" />
				<input type="text" id="descripcionCaja" name="descripcionCaja" size="35" disabled="true" />
			</td>
		</tr>
	</table>
	<table align="right">
			<tr>
				<td align="right">
				  	<button type="button" class="submit" id="generar" style="">Imprimir</button>
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
					<input type="hidden" id="nombreInstitucion" name="nombreInstitucion"/>					
					<input type="hidden" id="numUsuario" name="numUsuario"/>
					<input type="hidden" id="nomUsuario" name="nomUsuario"/>
					<input type="hidden" id="fechaSistemaP" name="fechaSistemaP"/>
					<input type="hidden" id="hora" name="hora"/>
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