<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>  
<html>
<head>
		<script type="text/javascript" src="dwr/interface/giroNegocioTarDebServicio.js"></script>
	 	<script type="text/javascript"	src="dwr/interface/tarjetaDebitoServicio.js"></script>
	 	<script type="text/javascript" src="dwr/interface/tarjetaCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
	 	<script type="text/javascript" src="dwr/interface/tarDebGirosAcepIndividualServicio.js"></script>
	 	<script type="text/javascript" src="dwr/interface/tarCredGirosAcepIndividualServicio.js"></script> 
      <script type="text/javascript" src="js/tarjetas/tarDebGirosAceptadosIndividual.js"></script>     
</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="girosAceptadosTarjetaIndividual">

<fieldset class="ui-widget ui-widget-content ui-corner-all">
<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Giros de Negocio No Permitidos por Tarjeta</legend>
	<table border="0" width="100%">
		<tr>
			<input type="hidden" name="tipoTarjeta" id="tipoTarjeta" value="1">
			
			<td class="label">
				<label> Tipo de Tarjeta</label>
				<input type="radio" id="tipoTarjetaDeb" name="tipoTarjetaDeb">
				<label> D&eacute;bito</label>
				<input type="radio" id="tipoTarjetaCred" name="tipoTarjetaCred">
				<label> Cr&eacute;dito </label>
			</td>
		</tr>
		<tr>
			<td class="label" colspan="2">
				<label for="lblTarjetaDebID">N&uacute;mero Tarjeta:</label>
				<input type="text" id="tarjetaID" name="tarjetaID" size="20" maxlength="16" tabindex="1"/>
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="lblEstatus">Estatus:</label>
				<input type="text" id="estatus" name="estatus" size="35" readOnly="true" />
			</td>	
		</tr>
	</table>
	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">	
		<legend>Datos Tarjeta</legend>
		<table border="0" width="100%">
			<tr>
				<td class="label">
					<label for="lblClienteID">Tarjetahabiente:</label>
				</td>
				<td>
				   <input type="text" id="clienteID" name="clienteID" size="15" readOnly="true" />
				   <input type="text" id="nombreCompleto" name="nombreCompleto" size="50" readOnly="true" />
				</td>		
			</tr>
			<tr id="cteCorpTr">
				<td class="label">
					<label for="lblCoorporativo">Corporativo (Contrato):</label>
				</td>
				<td>
				   <input type="text" id="coorporativo" name="coorporativo" size="15" readOnly="true" />
				   <input type="text" id="nombreCoorp" name="nombreCoorp" size="50" readOnly="true" />
				</td>		
			</tr>
			<tr id="cuentaAhorro">
				<td class="label">
					<label for="lblCuentaAho" id="ctaDebito">Cuenta Asociada:</label>
				</td>
				<td>
				    <input type="text" id="cuentaAho" name="cuentaAho" size="15" readOnly="true" />
				    <label for="lblTipoCuenta" id="tipoCuenta">Tipo Cuenta:</label>
					<input type="text" id="nombreTipoCuenta" name="nombreTipoCuenta" size="34" readOnly="true" />
				</td>				
			</tr>
			<tr id="lineaCredito">
				<td class="label">
					<label for="lblLineaCred">Producto</label>
					
				</td>
				<td>
					<input type="text" id="productoID" name="productoID" size="15" readOnly="true" />
					<input type="text" id="descripcionProd" name="descripcionProd" size="50" readOnly="true" />
				</td>				
			</tr>
			<tr>
				<td class="label">
					<label for="lblTipoTarjetaID">Tipo Tarjeta:</label>
				</td>
				<td>
				    <input type="text" id="tipoTarjetaID" name="tipoTarjetaID" path="tipoTarjetaID" size="15" readOnly="true" />
					<input type="text" id="nombreTarjeta" name="nombreTarjeta" size="50" readOnly="true" />
				</td>
			</tr>

			

		</table>
	</fieldset>
	<br>
			<div id="gridGiros">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">	
					<legend>Giros</legend>
					<input type="button" id="agregaGiros" name="agregaGiros" value="Agregar" class="botonGral" onClick="agregarGirosAceptados()" tabindex="2" />
					<div id="girosTarjetasIndividual" style="display: none;"></div>	
				</fieldset>
			</div>
			<br>				
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td align="right">
						<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="3"/>
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