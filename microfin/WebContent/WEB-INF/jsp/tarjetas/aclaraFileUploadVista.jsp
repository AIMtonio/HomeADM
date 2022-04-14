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
    <script type="text/javascript" src="js/tarjetas/aclaraFileUploadVista.js"></script>
    <title>Adjuntar Archivo </title>
</head>
<body>
	<c:set var="reporteID" value="<%= request.getParameter(\"reporteID\") %>"/>
	<c:set var="consecutivo" value="<%= request.getParameter(\"consecutivo\") %>"/>
	
	
	<div id="contenedorForma">
		<form method="post" id="formaGenerica" name="formaGenerica" enctype="multipart/form-data">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend class="ui-widget ui-widget-header ui-corner-all">Adjuntar Documento</legend>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
		
   			<tr>
    			<td class="label"> 
        			<label for="fileUpload">Seleccione un Archivo: </label> 
				</td>
     			<td colspan = "3">
        			<input type="file" name="file" id="file" path="file" tabindex ="5" />
       		</td>
			</tr>
				<tr>
				<td class="label" nowrap="nowrap">
					<label for="ldocumento">Tipo de Documento:</label>
				</td>
				<td>
				    <input type="text" id="tipoArchivo" name="tipoArchivo" path="tipoArchivo" tabindex="8" size="95"/>
				</td>		
			</tr>
			<tr>
				<td class="label"> 
					<label for="fecha">Fecha de Sistema: </label> 
				</td>
				<td class="label"> 
					<input id="fechaRegistro" name="fechaRegistro"  size="15"  path="fechaRegistro" tabindex="9" disabled="true" />	
				</td>
			</tr>
		</table>
		<table align="right">
			<tr>
	   		<td>
       			<input type="submit" id="adjuntar" name="adjuntar" class="submit" value="Adjuntar" /> 
      			<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
      			<input type="hidden" name="extarchivo" id="extarchivo" readOnly="readonly" />
      			<input type="hidden" id="folioID" name="folioID" size="13" tabindex="1" iniforma='false' readOnly="readonly"  value="${reporteID}"/>
      			<input type="hidden" id="consecutivo" name="consecutivo" size="13" tabindex="1" iniforma='false' readOnly="readonly"  value="${consecutivo}"/>
      			<input type="hidden" id="fechaRegistro" name="fechaRegistro"/>
      			<input type="hidden" id="ruta" name="ruta"/>
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