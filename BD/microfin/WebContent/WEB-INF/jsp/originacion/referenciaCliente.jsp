<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	<script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/municipiosServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/localidadRepubServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/coloniaRepubServicio.js"></script>  
	<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/relacionClienteServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/solicitudCredServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/referenciaClienteServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/parentescosServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
	<script type="text/javascript" src="js/soporte/mascara.js"></script>
	<script type="text/javascript" src="js/originacion/referenciaCliente.js"></script> 
</head>
<body>
	<div id="contenedorForma">
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="referenciaClienteBean">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">		
		<legend class="ui-widget ui-widget-header ui-corner-all">Referencias Personales</legend>
		<table border="0" width="100%">
			<tr>
				<td class="label"> 
		        	<label for="solicitudCreditoID">Solicitud Cr&eacute;dito: </label> 
			   	</td>
			   	<td> 
			    	<form:input id="solicitudCreditoID" name="solicitudCreditoID" path="solicitudCreditoID" size="12" tabindex="1" maxlength="11"/>  
			   	</td>
			   	<td class="separador"></td>
			   	<td class="label">
					<label for="productoCreditoID">Tipo Cr&eacute;dito: </label>
				</td>
			  	<td nowrap="nowrap">
				  	<form:input type="text" id="productoCreditoID" name="productoCreditoID" path="productoCreditoID" size="12" readonly="true"  disabled="disabled"/>
					<input type="text" id="descripProducto" name="descripProducto"size="50" readonly="true"  disabled="disabled"/>
				</td>
				<td align="right" colspan="5">
					<input type="hidden" id="tipoClasificacion" name="tipoClasificacion" value=""/>
				</td>
			</tr>
			<tr>
				<td class="label">
					<label for="sucursalOrigen">Nombre: </label>
				</td>
				<td nowrap="nowrap"> 
					<form:input type="text" id="nombreCte" name="nombreCte" path="nombreCte" size="50" readonly="true"  disabled="disabled"/>
				</td>
				<td class="separador"></td>
			   	<td class="label">
					<label for="productoCreditoID">Fecha de Registro: </label>
				</td>
				<td nowrap="nowrap"> 
					<form:input type="text" id="fechaRegistro" name="fechaRegistro" path="fechaRegistro" size="12" readOnly = "true"  disabled="disabled"/>
				</td>
			</tr>
			<tr>
				<td colspan="5">
					<div id="gridDetalleDiv" style="width:100%;overflow-x:scroll; display: none;"></div>
				</td>
			</tr>
		</table>
		<br>
		<table border="0"  width="100%">
			<tr>
				<td align="right" colspan="5">
					<input type="button" id="grabaReferencias" name="grabaReferencias" class="submit" value="Grabar" tabindex="500"/>
					<input type="hidden" id="detalle" name="detalle"/>
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="1"/>
				</td>
			</tr>
		</table>
		</fieldset>
	</form:form>
	</div>
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;overflow:">
		<div id="elementoLista"></div>
	</div>
	<div id="cajaListaCte" style="display: none;overflow-y: scroll;height:200px;">
		<div id="elementoListaCte"></div>
	</div>
	<div id="mensaje" style="display: none;"></div>
</body>
</html>