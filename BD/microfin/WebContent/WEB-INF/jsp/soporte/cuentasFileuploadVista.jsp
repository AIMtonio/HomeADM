 <%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%> 
 <%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
 <%@page contentType="text/html"%> 
 <%@page pageEncoding="UTF-8"%>
 
<html>
    <head>
		<link type="text/css" href="css/redmond/jquery-ui-1.8.13.custom.css" rel="stylesheet" />     
		<link rel="stylesheet" type="text/css" href="css/forma.css" media="all"  >   
      	<link rel="stylesheet" type="text/css" href="css/jquery.lightbox-0.5.css" media="screen" /> 
      	
      	<script type="text/javascript" src="dwr/interface/solicitudArchivoServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
      	<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/tiposDocumentosServicio.js"></script> 
      	<script type="text/javascript" src="dwr/interface/fileServicio.js"></script> 
		<script type="text/javascript" src="dwr/engine.js"></script>
      	<script type="text/javascript" src="dwr/util.js"></script>         
      	<script type='text/javascript' src='js/jquery-1.5.1.min.js'></script>
		<script type='text/javascript' src='js/jquery.jmpopups-0.5.1.js'></script> 
      	<script type="text/javascript" src="js/jquery.blockUI.js"></script>             		          
		<script type='text/javascript' src='js/jquery.validate.js'></script>
      	<script type="text/javascript" src="js/forma.js"></script> 
		<script type="text/javascript" src="js/general.js"></script>
		
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/fileServicio.js"></script>  
      	<script type="text/javascript" src="js/soporte/cuentasFileUploadCatalogoVista.js"></script>  
      	<title>Adjuntar Archivos de la Cuenta</title>
      	
    </head>
    <body>
    <c:set var="varCta" value="<%= request.getParameter(\"Cta\") %>"/>
	<c:set var="varTd" value="<%= request.getParameter(\"td\") %>"/>
<div id="contenedorForma">
<form method="post" id="formaGenerica" name="formaGenerica" action="/microfin/cuentasFileUpload.htm"
enctype="multipart/form-data">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Digitalización de Documentos de Cuentas</legend>			
<table border="0" cellpadding="0" cellspacing="0" width="950px">
	<tr>
    	<td> 
     		<input type="hidden" id="cuentaAhoID" name="cuentaAhoID" size="13" tabindex="1" iniforma="false"  value="${varCta}"/>    
     	</td> 
     	<td>
        	<input type="hidden" id="tipoDocumento" name="tipoDocumento" size="13" tabindex="2" iniforma='false' readOnly="readonly" value="${varTd}" />
        </td>   
 	</tr> 
 	<tr>
 		<td class="label"> 
        	<label for="fileUpload">Seleccione un archivo: </label> 
     	</td> 
      	<td colspan ="3">
        	<input type="file" name="file" id=file tabindex="4"/>
        	<input type="hidden" name="extarchivo" id="extarchivo" readOnly="readonly" />
      	</td>
      	<td>
        	<input id="archivoCuentaID" name="archivoCuentaID" size="10" tabindex="5" 
        		type="hidden"  readOnly="readonly"/>
        </td>  
   	</tr>
   	<tr>
      	<td class="label"> 
        	<label for="observacion">Observación: </label> 
     	</td>
      	<td colspan = "3">
      		<textarea id="observacion" name="observacion" COLS=35 ROWS=3 tabindex="6"></textarea>
      	</td>
      	<td>
      		<input type="hidden" name="recurso" id="recurso" readOnly="readonly" value="" tabindex="7" />
      	</td>
	</tr>
 </table>
 
 <div id="gridArchivosCta" style="display: none;">	</div> 

 <table align="right">
 	<tr>
      	<td>
     		<input type="submit" id="enviar" name="enviar" class="submit" value="Adjuntar" tabindex="9"/>
    	 	<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" tabindex="10"/>
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
<div id="mensaje" style="display: none;"></div>
</html>