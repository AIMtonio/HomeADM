<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%> 
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head> 
	<link type="text/css" href="css/redmond/jquery-ui-1.8.13.custom.css" rel="stylesheet" />     
	<link rel="stylesheet" type="text/css" href="css/forma.css" media="all"  >   
    <link rel="stylesheet" type="text/css" href="css/jquery.lightbox-0.5.css" media="screen" />
     	 
   	<script type="text/javascript" src="dwr/interface/firmaRepresentLegalServicio.js"></script> 
	<script type="text/javascript" src="dwr/engine.js"></script>
	<script type="text/javascript" src="dwr/util.js"></script>        
	<script type='text/javascript' src='js/jquery-1.5.1.min.js'></script>
	<script type='text/javascript' src='js/jquery.jmpopups-0.5.1.js'></script> 
    <script type="text/javascript" src="js/jquery.blockUI.js"></script>             		          
	<script type='text/javascript' src='js/jquery.validate.js'></script>
	<script type="text/javascript" src="js/forma.js"></script>
	<script type="text/javascript" src="js/general.js"></script>

    <script type="text/javascript" src="js/soporte/firmaRepresentLegalArch.js"></script>
    <title>Adjuntar Firma Del Representante Legal</title>
</head>

<body>
<c:set var="varRP" value="<%= request.getParameter(\"representanteLegal\") %>"/>

<div id="contenedorForma">
<form method="post" id="formaGenerica" name="formaGenerica" action="/microfin/firmaRepresentLegalArchivo.htm" enctype="multipart/form-data">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Digitalización de la Firma del Representante Legal</legend>			
<table border="0" cellpadding="0" cellspacing="0" width="650px">
	<tr>
    	<td><input type="hidden" id="representLegal"	name="representLegal" iniforma='false' readOnly="readonly"  value="${varRP}"/></td> 
	</tr> 
   	<tr>
    	<td class="label"> 
        	<label for="fileUpload">Por favor seleccione un archivo: </label> 
		</td> 
     	<td colspan = "3">
        	<input type="file" name="file" id="file"tabindex ="5" />
        	<input type="hidden" name="extension" id="extension" readOnly="readonly" />
       	</td>
	</tr>
    <tr>
    	<td class="label"> 
        	<label for="observacion">Observaci&oacute;n: </label> 
     	</td>
      	<td colspan = "3">
      		<textarea id="observacion" name="observacion" cols="35" rows="3" tabindex="6" onBlur="ponerMayusculas(this)" maxlength="100"></textarea>
      	</td>
      	<td>
      		<input type="hidden" name="recurso" id="recurso" readOnly="readonly" value="" />
      	</td>
	</tr>
</table>
<table align="right">
	<tr>
	   	<td>
       		<input type="submit" id="adjunta" name="adjunta" class="submit" tabindex="8" value="Adjuntar"   /> 
      		<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
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

