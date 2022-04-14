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
    <script type="text/javascript" src="js/pld/cargasListasFileUpload.js"></script> 
    
    <title>Adjuntar Archivo Carga de Listas PLD</title>
</head>
<body>

		  <div id="contenedorForma">
		<form method="post" id="formaGenerica" name="formaGenerica" enctype="multipart/form-data">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">			
		<legend class="ui-widget ui-widget-header ui-corner-all" ><label id="labelLegend">Adjuntar Archivo para Carga</label></legend>			
		<table border="0" width="650px">
   			<tr>
    			<td class="label"> 
        			<label for="file">Por favor seleccione un archivo: </label> 
				</td>
     			<td colspan = "3">
        			<input type="file" name="file" id="file" path="file" tabindex ="1" />
       			</td>	
			</tr>
		</table>
		<table align="right">
			<tr>
	   			<td>
	   			    <input type="submit" id="procesarArchivo" name="procesarArchivo" class="submit" value="Procesar" tabindex="2" />
      				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="tipoTransaccion" />
      				<input type="hidden" id="tipoLista" name="tipoLista" value="tipoLista" />
      				<input type="hidden" name="extarchivo" id="extarchivo" readOnly="readonly" />
      				<input type="hidden" id="rutaArchivos" name="rutaArchivos"/>
      				<input type="hidden" id="fechaCarga" name="fechaCarga"/>
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