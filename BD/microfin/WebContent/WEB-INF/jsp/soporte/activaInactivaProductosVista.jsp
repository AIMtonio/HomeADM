<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
       <script type="text/javascript" src="dwr/interface/tipoInstrumentosServicio.js"></script>
       <script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
       <script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js"></script>
       <script type="text/javascript" src="dwr/interface/tiposCedesServicio.js"></script>
       <script type="text/javascript" src="dwr/interface/tipoInversionesServicio.js"></script>
       <script type="text/javascript" src="dwr/interface/tipoFondeadorServicio.js"></script>

       <script type="text/javascript" src="js/soporte/activaInactivaProductos.js"></script>
       
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="activaDesacProduc">
<fieldset class="ui-widget ui-widget-content ui-corner-all">
<legend class="ui-widget ui-widget-header ui-corner-all">Activo / Inactivo de Productos SAFI</legend>
<table cellpadding="1" cellspacing="1" border="0" width="100%">
	<tr>
		<td class="label" nowrap="nowrap">
			<label for="tipoProducto">Tipo Producto </label>
		</td>

		<td nowrap="nowrap">
			<form:select id="tipoProducto" name="tipoProducto" path="tipoProducto" tabindex="1">
				<form:option value="0">SELECCIONAR</form:option>
			</form:select>
		</td>
	</tr>
	<tr>
		<td class="label" nowrap="nowrap">
			<label for="numProducto">N&uacute;mero:</label>
		</td>
		<td nowrap="nowrap">
			<form:input  type="text"  id="numProducto" name="numProducto" path="numProducto" tabindex="2" size="12" autocomplete="off"/>
		</td>
		<td class="separador"></td>
		<td class="label" nowrap="nowrap">
			<label for="nombre">Nombre: </label>
		</td>
		<td nowrap="nowrap">
			<form:input  type="text"  id="nombre" name="nombre" path="nombre" disabled="true"
			size="50"/>
		</td>
	</tr>
	<tr>
		<td class="label" nowrap="nowrap">
			<label for="nombreCorto">Nombre Corto:</label>
		</td>
		<td nowrap="nowrap">
			<form:input  type="text"  id="nombreCorto" name="nombreCorto" path="nombreCorto" size="30"
			disabled="true"/>
		</td>
		<td class="separador"></td>
		<td class="label" nowrap="nowrap">
			<label for="estatus">Estatus</label>
		</td>
		<td nowrap="nowrap">
			<form:select id="estatus" name="estatus" path="estatus" tabindex="3">
				<form:option value="A">ACTIVO</form:option>
			   	<form:option value="I">INACTIVO</form:option>
			</form:select>
		</td>
	</tr>
	<tr>
		<td align="right" colspan="5">
			<input type="submit" id="actualiza" name="actualiza" class="submit" value="Actualizar" tabindex="4" />
			<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
			<input type="hidden" id="tipoActualizacion" name="tipoActualizacion"/>
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