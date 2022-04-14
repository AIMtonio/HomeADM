<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%> 
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>	
<html>
<head>
	<link type="text/css" href="css/redmond/jquery-ui-1.8.13.custom.css" rel="stylesheet" />     
	<link rel="stylesheet" type="text/css" href="css/forma.css" media="all"  >   
    <link rel="stylesheet" type="text/css" href="css/jquery.lightbox-0.5.css" media="screen" />
    
	<script type="text/javascript" src="dwr/engine.js"></script>
	<script type="text/javascript" src="dwr/util.js"></script>        
	<script type='text/javascript' src='js/jquery-1.5.1.min.js'></script>
	<script type='text/javascript' src='js/jquery.jmpopups-0.5.1.js'></script> 
    <script type="text/javascript" src="js/jquery.blockUI.js"></script>             		          
	<script type='text/javascript' src='js/jquery.validate.js'></script>
	<script type="text/javascript" src="js/forma.js"></script>
	<script type="text/javascript" src="js/general.js"></script>
    <script type="text/javascript" src="js/tesoreria/facturaFileUpload.js"></script>
    <title>Adjuntar Archivo </title>
</head>
<body>
	<c:set var="proveedor" value="<%= request.getParameter(\"proveedorID\") %>"/>
	<c:set var="noFactura" value="<%= request.getParameter(\"noFactura\") %>"/>
	<c:set var="tipoArchivo" value="<%= request.getParameter(\"tipoArchivo\") %>"/>
	<c:set var="actualiza" value="<%= request.getParameter(\"actualiza\") %>"/>
	<c:set var="rutaImagenFact" value="<%= request.getParameter(\"rutaImagenFact\") %>"/>
	<c:set var="rutaXMLFact" value="<%= request.getParameter(\"rutaXMLFact\") %>"/>

	<div id="contenedorForma">
		<form method="post" id="formaGenerica" name="formaGenerica" 
			enctype="multipart/form-data">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">		
		<legend class="ui-widget ui-widget-header ui-corner-all">Digitalización de Facturas </legend>			
		<table border="0" cellpadding="0" cellspacing="0" width="650px">
			<tr>	
    			<td>
        			<input type="hidden" id="proveedorID" name="proveedorID" size="13" tabindex="1" iniforma='false'  value="${proveedor}"/>
        			<input type="hidden" id="noFactura" name="noFactura" size="13" tabindex="1" iniforma='false'  value="${noFactura}"/>
        			<input type="hidden" id="tipoArchivo" name="tipoArchivo" size="13" tabindex="1" iniforma='false'  value="${tipoArchivo}"/>
        			<input type="hidden" id="actualiza" name="actualiza" size="13" tabindex="1" iniforma='false'  value="${actualiza}"/> 
        			<input type="hidden" id="rutaImagenFact" name="rutaImagenFact" size="13" tabindex="1" iniforma='false'  value="${rutaImagenFact}"/>
        			<input type="hidden" id="rutaXMLFact" name="rutaXMLFact" size="13" tabindex="1" iniforma='false'  value="${rutaXMLFact}"/>    
      			</td>
     			<td></td>
			</tr> 
   			<tr>
    			<td class="label"> 
        			<label for="fileUpload">Por favor seleccione un archivo: </label> 
				</td>
     			<td colspan = "3">
        			<input type="file" name="file" id="file" tabindex ="5" />
        			
        			<input type="hidden" name="extarchivo" id="extarchivo" readOnly="readonly" />
       			</td>
			</tr>
		</table>
		<table align="right">
			<tr>
	   			<td>
       				<input type="submit" id="enviar" name="enviar" class="submit" tabindex="8" value="Adjuntar" /> 
      				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
						<input type="hidden" id="tipoActualizacion" name="tipoActualizacion"/>
      			</td> 
			</tr>
		</table>
		</fieldset>	 
		</form> 
	</div>
	
	
	<div id="cargando" style="display: none;">	
	</div>
	<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
	</div>
</body>
<div id="mensaje" style="display:none;"></div>
</html>