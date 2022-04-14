<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>

	<head>	
 		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
 		<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/inversionServicioScript.js"></script>
		 
        <script type="text/javascript" src="js/cliente/extravioDocs.js"></script>  
	</head>
<body>

<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="extravioDocsBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Extrav&iacute;o de Documentos</legend>			
<table border="0" cellpadding="0" cellspacing="0" width="100%">
 	<tr>
 		<td class="label">
 			<label for="tipoRep">Tipo:</label>
 		</td>
 		<td>
 			<input type="radio" id="inversion" name="tipoRep"  checked="checked" tabindex="1">
 			<label>Inversi&oacute;n</label>
 			<input type="radio" id="cuenta" name="tipoRep" tabindex="2">
 			<label>Cuenta de Ahorro</label>
 		</td>
 	</tr>
 	<tr id="repCuenta">
 		<td class="label">
 			<label for="cuentaID" >No. Cuenta:</label>
 		</td>
 		<td>
 			<input type="text" id="cuentaID" name="cuentaID" path="cuentaID" tabindex="3" />
 		</td>
 	</tr>
 	<tr id="repInversion">
 		<td class="label">
 			<label for="inversionID">No. Inversi&oacute;n:</label>
 		</td>
 		<td>
 			<input type="text" id="inversionID" name="inversionID" path="inversionID" tabindex="4" />
 		</td>
 	</tr>
 	<tr>
 		<td clas="label">
 			<label for="clienteID">Cliente:</label>
 		</td>
 		<td>
 			<input type="text" id="clienteID" name="clienteID" path="clienteID" readonly="true" size="20">
 			<input type="text" id="nombreCliente" readonly="true" size="35">
 		</td>
 	</tr>
 	<tr>	 
		<table align="right">
			<tr>
				<td align="right">
					<input type="button" id="imprimir" name="imprimir" class="submit" tabIndex = "10" value="Imprimir" />
				</td>
			</tr>
		</table>
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