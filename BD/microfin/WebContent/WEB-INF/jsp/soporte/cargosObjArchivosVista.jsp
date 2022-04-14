<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<link rel="shortcut icon" href="images/favicon.ico" type="image/x-icon" />
<link rel="stylesheet" type="text/css" href="css/loader.css" />
<link rel="stylesheet" type="text/css" href="css/offline.css" />
<link rel="stylesheet" type="text/css" href="css/template.css" media="screen,print" />
<link rel="stylesheet" type="text/css" href="css/menuTree.css" media="screen,print" />
<link rel="stylesheet" type="text/css" href="css/redmond/jquery-ui-1.8.13.custom.css" />
<link rel="stylesheet" type="text/css" href="css/forma.css" media="all" />
<script type="text/javascript" src="js/loader.js"></script>
<script type="text/javascript" src="js/offline.min.js"></script>
<script type="text/javascript" src="js/jquery-1.5.1.min.js"></script>
<script type="text/javascript" src="js/jquery.ui.datepicker-es.js"></script>
<script type="text/javascript" src="js/jquery-ui-1.8.13.custom.min.js"></script>
<script type="text/javascript" src="js/jquery-ui-1.8.13.min.js"></script>
<script type="text/javascript" src="js/jquery.validate.js"></script>
<script type='text/javascript' src='js/jquery.formatCurrency-1.4.0.min.js'></script>
<script type="text/javascript" src="js/jquery.jmpopups-0.5.1.js"></script>
<script type="text/javascript" src="js/jquery.blockUI.js"></script>
<script type='text/javascript' src='js/jquery.hoverIntent.minified.js'></script>
<script type="text/javascript" src="js/jquery.plugin.menuTree.js"></script>
<script type="text/javascript" src="js/jquery.plugin.tracer.js"></script>
<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/clienteArchivosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/tiposDocumentosServicio.js"></script>

<script type="text/javascript" src="dwr/engine.js"></script>
<script type="text/javascript" src="dwr/util.js"></script>
<script type="text/javascript" src="js/forma.js"></script>
<script type="text/javascript" src="js/utileria.js"></script>
<script type="text/javascript" src="js/general.js"></script>
<script type="text/javascript" src="js/soporte/cargosObjArchivos.js"></script>
</script>
<title>Adjuntar Archivos Objetados</title>
</head>
<body>

	<div id="contenedorForma" style="top:0px; padding:10px; left:0px; width: 98%; height: 90%; ">
		<form method="post" id="formaGenerica" name="formaGenerica" action="/microfin/cargosObjFileUploadVista.htm" enctype="multipart/form-data">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">
					Subida de Layout de Cargos Objetados en el Periodo 
				</legend>
			<table border="0" cellpadding="0" cellspacing="0" width="650px">
					
					<tr>
						<td class="label">
							<label for="fileUpload">Por favor seleccione un archivo: </label>
						</td>
						<td colspan="3">
							<input type="file" name="file" id="file" tabindex="1" /> <input type="hidden" name="nombreArchivo" id="nombreArchivo" readOnly="readonly" />
						   <input type="hidden" name="extension" id="extension" readOnly="readonly" />
						</td>
						
					</tr>
					
				</table>
				<table align="right">
					<tr>
						<td>
							<input type="submit" id="enviar" name="enviar" class="submit" tabindex="2" value="Adjuntar" />
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
						</td>
						<td>
				      		<input type="hidden" name="recurso" id="recurso" readOnly="readonly" value="" />
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
