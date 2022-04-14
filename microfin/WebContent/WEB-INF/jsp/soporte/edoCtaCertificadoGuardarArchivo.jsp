<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%> 
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
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
    <script type="text/javascript" src="js/soporte/edoCtaCertificadoGuardarArchivo.js"></script>
    <title>Adjuntar Archivo </title>
</head>
<body>
		<c:set var="extension" value="<%= request.getParameter(\"tipoExtension\") %>"/>
	<div id="contenedorForma">
		<form method="post" id="formaGenerica" name="formaGenerica" enctype="multipart/form-data">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">		
		<legend class="ui-widget ui-widget-header ui-corner-all">Seleccione Archivo</legend>			
		<table border="0" cellpadding="0" cellspacing="0" width="650px">
			<tr>	
    			<td>
        			<input type="hidden" id="ext" name="ext" size="13" tabindex="1" iniforma='false' readOnly="readonly"  value="${extension}"/>  
      			</td>
     			<td></td>
			</tr> 			
   			<tr>
    			<td class="label"> 
        			<label for="fileUpload">Por favor, seleccione un archivo: </label> 
				</td>
     			<td colspan = "3">
     				<script type="text/javascript">     							
     							var esKey=1;     	
     							if(document.getElementById("ext").value==esKey){     								
     								document.write('<input type="file" name="archivoKey" id="archivoKey" tabindex ="5" />');     								
     							}else{     								
     								document.write('<input type="file" name="archivoCer" id="archivoCer" tabindex ="5" />');
     							}
     				</script>
        			
        			<input type="hidden" name="extarchivo" id="extarchivo" readOnly="readonly" />
       			</td>       			
			</tr>
		</table>
		<table align="right">
			<tr>
	   			<td>
       				<input type="submit" id="enviar" name="enviar" class="submit" tabindex="8" value="Adjuntar" />       				
      				<input type="hidden" id="pathAdjuntar" name="pathAdjuntar" readOnly="readonly"/>
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