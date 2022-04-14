<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%> 
<html>
    <head>
	<link rel="stylesheet" type="text/css" href="css/jquery.lightbox-0.5.css" media="screen" /> 
      	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
      	<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/checkListCedesServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/tiposDocumentosServicio.js"></script> 	
      	<script type="text/javascript" src="dwr/interface/cedesFileServicio.js"></script>  
      	<script type="text/javascript" src="dwr/interface/cedesServicio.js"></script>
      	<script type="text/javascript" src="js/jquery.lightbox-0.5.pack.js"></script>
      	<script type="text/javascript" src="js/cedes/cedesFileUploadCatalogo.js"></script> 
   
		<script>
			$(function() {
        		$('#imagenCte a').lightBox();
    		});   
    	</script>  
	</head> 
	<body>
		<div id="contenedorForma">
			<form method="post" id="formaGenerica" name="formaGenerica" action="/microfin/cedesFileUpload.htm" enctype="multipart/form-data">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">		
					<legend class="ui-widget ui-widget-header ui-corner-all">Digitalización de Documentos de CEDES</legend>			
					<table border="0" cellpadding="0" cellspacing="0" width="950px">
						<tr>
    						<td class="label"> 
        						<label for="lblcuenta">No. de CEDE: </label> 
     						</td>
     						<td>
        						<input id="cedeID" name="cedeID" size="13" tabindex="1" iniforma="false" />  
         						<input type="text" id="nombreCliente" name="nombreCliente" size="55" disabled= "true" readOnly="true"/>  
      						</td> 
   							<td class="separador"></td> 
							<td class="label"> 
        						<label for="lbltipoDocumento">Tipo de Documento: </label> 
     						</td> 
     						<td> 
								<select id="tipoDocumento" name="tipoDocumento" tabindex="2">
									<option value="-1">SELECCIONAR</option>
								</select>     
     						</td> 
 						</tr> 
 					</table>
 					<div id="gridArchivosCta" style="display: none;">	</div> 
					<table align="right">
	 					<tr>
    						<td class="label">
		    						<input type="button" class="submit" id="pdf" value="Reporte PDF"/>	
							</td> 
      						<td>
     							<input type="button" id="adjuntar" name="adjuntar" class="submit" value="Adjuntar" tabindex="4"/>
    	 						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
      						</td>
						</tr>
						<tr>
							<td>
			 					<div id="imagenCte" style="display: none;">
			 						<IMG id= "imgCliente" SRC="images/user.jpg" WIDTH="100%" HEIGHT="100%" BORDER=0 ALT="Foto cliente"/> 
								</div> 
       						</td> 
						</tr>
					</table>
				</fieldset>	 
			</form> 
		</div>
		<div id="cargando" style="display: none;"></div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"></div>
		</div>
	</body>
	<div id="mensaje" style="display: none;"></div>
</html>