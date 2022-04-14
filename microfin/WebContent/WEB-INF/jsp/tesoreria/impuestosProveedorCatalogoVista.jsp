<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
	<head>
		<script type="text/javascript" src="dwr/interface/tipoProvServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/impuestoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tipoprovimpServicio.js"></script> 
	  	<script type="text/javascript" src="js/soporte/mascara.js"></script>
		<script type="text/javascript" src="js/tesoreria/impuestosProveedorVista.js"></script>  
	</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="tipoproveimpues">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">		
			<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Impuestos por Tipo de Proveedor</legend>
			<br> 		
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td class="label">
						<label for="lblTipoProveedorID">Tipo Proveedor:</label>
						<form:input id="tipoProveedorID" name="tipoProveedorID" path="tipoProveedorID" size="10" tabindex="1"/>
						<textarea id="descripcion" name="descripcion" path="descripcion" cols =70 rows=3 readonly="true" ></textarea>  
					</td>
					
				</tr>
				</table>
				<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Impuestos</legend>
						<input type="hidden" id="datosGrid" name="datosGrid" size="100" />	
						<div id="divImpuestosProveedor" style="display: none;"></div>
				</fieldset>				
				<br>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td align="right">
						<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="3" />
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="1"/>						
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