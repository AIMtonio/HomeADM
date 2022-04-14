<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/solicitudCredServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
		<script type="text/javascript" src="js/buroCredito/consultaSolicitudBC.js"></script>
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="solicitudCreditoBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all" id="legendtext">Consulta por Solicitud Bur&oacute; Cr&eacute;dito</legend>		
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
	 		<td class="label">
	 			<label for="solicitudCreditoID">Solicitud de Cr&eacute;dito:</label>
	 		</td>
	 		<td>
	 			<form:input type="text" id="solicitudCreditoID" name="solicitudCreditoID" path="solicitudCreditoID" size="5" tabindex="1"/>
	 		</td>
	 		<td class="separador"></td>
	 		<td class="label">
	 			<label for="lblSolicitud">Producto de Cr&eacute;dito:</label>
	 		</td>
	 		<td>
	 			<form:input type="text" id="productoCreditoID" name="productoCreditoID" path="productoCreditoID" tabindex="2" disabled="true" readonly="true"/>
	 			<input type="text" id="descripProducto" name="descripProducto" size="40" disabled="true" readonly="true" />
	 		</td>
		</tr>
		<tr>
	 		<td class="label">
	 			<label for="lblMontoSolicitado">Monto Solicitado:</label>
	 		</td>
	 		<td>
	 			<form:input type="text" id="montoSolici" name="montoSolici" path="montoSolici" tabindex="3" disabled="true"/>
	 		</td>
	 		<td class="separador"></td>
	 		<td class="label">
	 			<label for="lblFecha">Fecha:</label>
	 		</td>
	 		<td>
	 			<form:input type="text" id="fechaRegistro" name="fechaRegistro" path="fechaRegistro" tabindex="4" disabled="true"/>
	 		</td>
		</tr>
		<tr>
	 		<td class="label">
	 			<label for="lblEstatus">Estatus:</label>
	 		</td>
	 		<td>
	 			<form:select id="estatus" name="estatus" path="estatus"  tabindex="5" disabled= "true">
			    	<form:option value="I">INACTIVO</form:option>
					<form:option value="A">AUTORIZADO</form:option>
					<form:option value="C">CANCELADO</form:option>
					<form:option value="R">RECHAZADO</form:option>
					<form:option value="D">DESEMBOLSADO</form:option>
					<form:option value="L">LIBERADA</form:option>
				</form:select>
	 		</td>
	 		<td class="separador"></td>
	 		<td class="label">
	 			<label for="lblMontoAutorizado">Monto Autorizado:</label>
	 		</td>
	 		<td>
	 			<form:input type="text" id="montoAutorizado" name="montoAutorizado" path="montoAutorizado" tabindex="6" disabled="true" style="text-align: right;"/>
	 		</td>
		</tr>
		<tr>
			<td><br></td>
		</tr>
	</table>
	<div id="gridConsultas"></div>
	<table style="width: 100%">
		<tr>
			<td align="right">
				<input type="submit" id="generar" name="generar" class="submit" value="Consultar" tabindex="7"/>
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
				<input type="hidden" id="tipoConsulta" name="tipoConsulta" />
				<input type="hidden" id="listaRegistros" name="listaRegistros" />
				<input type="hidden" id="usuarioCirculo" name="usuarioCirculo"/>
				<input type="hidden" id="contrasenaCirculo" name="contrasenaCirculo"/>			  		
				<input type="hidden" id="abreviaturaCirculo" name="abreviaturaCirculo" value=""/>
				<input type="hidden" id="origenDatos" name="origenDatos" />
				<input type="hidden" id="realizaConsultasBC" name="realizaConsultasBC"/>
				<input type="hidden" id="usuarioBuroCredito" name="usuarioBuroCredito" />
				<input type="hidden" id="contraseniaBuroCredito" name="contraseniaBuroCredito" />
				<input type="hidden" id="sol" name="sol"/>
			</td>
		</tr>
	</table>
</fieldset>	
</form:form>
</div>
<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>