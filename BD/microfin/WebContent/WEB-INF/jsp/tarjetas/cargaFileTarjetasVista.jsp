<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%> 
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head> 
	<link rel="stylesheet" type="text/css" href="css/jquery.lightbox-0.5.css" media="screen" /> 
	<link type="text/css" href="css/redmond/jquery-ui-1.8.13.custom.css" rel="stylesheet" />     
	<link rel="stylesheet" type="text/css" href="css/forma.css" media="all"  >   
	<script type="text/javascript" src="dwr/engine.js"></script>
	<script type="text/javascript" src="dwr/util.js"></script>        
	<script type='text/javascript' src='js/jquery-1.5.1.min.js'></script>
	<script type='text/javascript' src='js/jquery.jmpopups-0.5.1.js'></script> 
    <script type="text/javascript" src="js/jquery.blockUI.js"></script>             		          
	<script type='text/javascript' src='js/jquery.validate.js'></script>
	<script type="text/javascript" src="js/forma.js"></script>
	<script type="text/javascript" src="js/general.js"></script>
	  <script type="text/javascript" src="js/tarjetas/cargaFileTarjetasVista.js"></script> 
</head> 

<body>
<c:set var="varTipo" value="<%= request.getParameter(\"tipoCarga\") %>"/>
<div id="contenedorForma">
<form method="POST" id="formaGenerica" name="formaGenerica" action="/microfin/cargaFileTarjetasVista.htm" enctype="multipart/form-data">
  <fieldset class="ui-widget ui-widget-content ui-corner-all">		
  <legend class="ui-widget ui-widget-header ui-corner-all">Carga de Transacciones Tarjetas de Crédito</legend>			
  <table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr>
      <td class="label" style="margin-top: 20px"> 
        <label for="fileUpload">Por favor seleccione un archivo: </label> 
      </td> 
      <td colspan = "3">
        <input type="file" name="file" id="file"tabindex ="5" />
        <input type="hidden" name="extension" id="extension" readOnly="readonly" />
      </td>
      <td>
        <input type="hidden" name="recurso" id="recurso" readOnly="readonly" value="" />
        <input type="hidden" name="nombreArchivo" id="nombreArchivo" readonly="readonly">
        <input type="hidden" name="fechaCarga" id="fechaCarga" readonly="readonly">
        <input type="hidden" name="tipoCarga" id="tipoCarga" readonly="readonly" value="${varTipo}">
      </td>
    </tr>  
  </table>

  <table align="right">
	  <tr>
    	<td class="label">
        <input type="submit" id="enviar" name="enviar" class="submit" tabindex="8" value="Cargar"   /> 
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