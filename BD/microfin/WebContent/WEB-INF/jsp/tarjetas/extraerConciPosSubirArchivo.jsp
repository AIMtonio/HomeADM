<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
	<head>
		<link type="text/css" href="css/redmond/jquery-ui-1.8.13.custom.css" rel="stylesheet" />
		<link rel="stylesheet" type="text/css" href="css/forma.css" media="all" />
	   	
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
		<script type="text/javascript" src="js/tarjetas/cargaConciliaPOSSubirArch.js"></script>
		<script type="text/javascript" src="js/tarjetas/cargaConciliaPOS.js"></script>
		<title>Cargar de Archivo de Tarjetas</title>
	</head>
	<body>
		<c:set var="varFec"  value="<%= request.getParameter(\"fecha\")  %>"/>
		<div id="contenedorForma">
			<form:form method="POST" commandName="cargaConciPOS" enctype="multipart/form-data" name="formaGenerica2" id="formaGenerica2">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Carga de Archivo de Tarjetas</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
						    <td class="label">
					         	<label for="lblNombreArch">Nombre Archivo:</label>
					    	</td>
					    	<td>
					         	<input type="file" id="file" name="file" tabindex="6" id="file" /> 
					         	<input type="hidden" name="extarchivo" id="extarchivo" readonly="true">
					    	</td>                                        
						</tr>
						<tr>
							<td align="right" colspan="2">									
								<input type="submit" id="procesarArchivo" name="procesarArchivo" class="submit" value="Adjuntar" tabindex="7" />
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="tipoTransaccion" />
							</td>
						</tr>
					</table>
				</fieldset>
			</form:form>
		</div>		
		<div id="cargando" style="display: none;"></div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"></div>
		</div>
	</body>
	<div id="mensaje" style="display: none;"></div>
</html>