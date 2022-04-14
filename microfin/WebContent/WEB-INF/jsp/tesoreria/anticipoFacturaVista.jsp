<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>  
<html>
<head>
	    <script type="text/javascript" src="dwr/interface/facturaProvServicio.js"></script> 
	  	<script type="text/javascript" src="dwr/interface/proveedoresServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/anticipoFacturaServicio.js"></script> 
      	<script type="text/javascript" src="js/tesoreria/anticipoFacturaVista.js"></script>     
</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="anticipoFacturaBean">

<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Anticipo a Proveedores</legend>
	<br> 	
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td class="label">
				<label for="lblProveedor">Proveedor:</label>
				</td>
					<td> 
						<form:input type="text" id="proveedorID" name="proveedorID" path="proveedorID" size="20" tabindex="1"/>
						<input type="text" id="nombreProv" name="nombreProv" size="80" readOnly="true" />
					</td>		
				</tr>
			<tr> 
				<td class="label">
				<label for="lblNoFactura">N&uacute;mero Factura:</label>
				</td>
					<td> 
						<form:input type="text" id="noFactura" name="noFactura" path="noFactura" size="20" tabindex="2"/>
					</td>		
			</tr>
			<tr>
				<td class="label">
				<label for="lblTotalFactura">Total:</label>
				</td>
					<td> 
					
						<input type="text" id="totalFactura" name="totalFactura" size="20" style="text-align:right;" esMoneda="true" readOnly="true" />
					</td>		
			</tr>
			<tr>
				<td class="label">
				<label for="lblSaldoFactura">Saldo:</label>
				</td>
					<td> 
						<input type="text" id="saldoFactura" name="saldoFactura" size="20" style="text-align:right;" esMoneda="true" readOnly="true" />
				</td>		
			</tr>
		</table>			
	<br> 
	<fieldset class="ui-widget ui-widget-content ui-corner-all">	
		<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Anticipo</legend>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td class="label">
					<label for="lblFormaPago">Forma de Pago:</label>
					<form:select id="formaPago" name="formaPago" path="formaPago" tabindex="3" >
					  <form:option value="">Seleccionar</form:option>
					  <form:option value="C">Cheque</form:option>
					  <form:option value="S">SPEI</form:option>
					  <form:option value="B">Banca Electrónica</form:option>
					  <form:option value="T">Tarjeta Empresarial</form:option>
					  </form:select>
				 </td>
				 <td class="separador"></td>
					<td class="label">
					<label for="lblMontoAnticipo">Monto de Anticipo:</label>
					<input type="text" id="montoAnticipo" name="montoAnticipo" esMoneda="true" style="text-align:right;" tabindex="4" size="20" />
					</td>
			</tr>
		</table>
	</fieldset>
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td class="label" align="right">
				<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar" tabindex="5"/>
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/> 
			</td>
		</tr>
	</table>
		<!-- Anticipo de facturas de proveedor -->
			<div id="gridAnticipoFactura"> 
			<br>
		 </div>
		<!-- Fin Anticipo de facturas de proveedor -->
	<br> 
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr id="divSaldoAnticipo"> 
				<td class="label">
				<label for="lblSaldoAnticipo">Saldo con Anticipos:</label>
						<input type="text" id="saldoAnticipo" name="saldoAnticipo" esMoneda="true" style="text-align:right;" size="20" readOnly="true" />
					</td>		
			</tr>
		</table>			
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td align="right">
				<input type="submit" id="cancela" name="cancela" class="submit" value="Cancelar" tabindex="6"/>
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/> 
				<input type="hidden" id="tipoActualizacion" name="tipoActualizacion"/> 
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

