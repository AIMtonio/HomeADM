<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<html>
<head>
<link rel="shortcut icon" href="images/favicon.ico" type="image/x-icon" />
<link type="text/css" href="css/redmond/jquery-ui-1.8.13.custom.css" rel="stylesheet" />
<link rel="stylesheet" type="text/css" href="css/forma.css" media="all">
<link rel="stylesheet" type="text/css" href="css/jquery.lightbox-0.5.css" media="screen" />
<script type="text/javascript" src="dwr/engine.js"></script>
<script type="text/javascript" src="dwr/util.js"></script>
<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/fileServicio.js"></script>
<script type="text/javascript" src="dwr/interface/tiposDocumentosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/clienteArchivosServicio.js"></script>
<script type='text/javascript' src='js/jquery-1.5.1.min.js'></script>
<script type='text/javascript' src='js/jquery.jmpopups-0.5.1.js'></script>
<script type="text/javascript" src="js/jquery.blockUI.js"></script>
<script type='text/javascript' src='js/jquery.validate.js'></script>
<script type="text/javascript" src="js/forma.js"></script>
<script type="text/javascript" src="js/general.js"></script>
<script type="text/javascript" src="js/soporte/cargaArchPlanosVista.js"></script>
<title></title>
</head>
<body>
	<c:set var="varFecha" value="<%= request.getParameter(\"fecha\") %>" />
	<c:set var="varArchivo" value="<%= request.getParameter(\"archivo\") %>" />
	<div id="contenedorForma" style="padding: 20px">
		<form:form id="formaGenerica2" name="formaGenerica2" method="POST" commandName="cargaArchPlanosBean" enctype="multipart/form-data">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend id="legend" class="ui-widget ui-widget-content ui-widget-header ui-corner-all"></legend>
				<table border="0" width="100%">
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="file">Archivo:</label>
						</td>
						<td>
							<form:input type="file" name="file" id="file" path="file" tabindex="1" />
						</td>
					</tr>
					<tr>
						<td align="right" colspan="5">
							<input type="submit" id="enviar" name="enviar" class="submit" tabindex="8" value="Subir Archivo" />
							<input type="hidden" name="extension" id="extension" value=""/>
							<input type="hidden" id="fecha" name="fecha" value="${varFecha}" />
							<input type="hidden" id="archivo" name="archivo" value="${varArchivo}" />
							<form:input type="hidden" id="rutaLocal" name="rutaLocal" path="" value="" />
							<form:input type="hidden" id="recurso" name="recurso" path="recurso" value=""/>
							<form:input type="hidden" id="tipo" name="tipo" path="tipo" value="<%= request.getParameter(\"tipo\") %>"/>
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
	<div id="mensaje" style="display: none;"></div>
	<script type="text/javascript">
	function decoding(cadena){
		return atob(cadena)
	}
	document.title = decoding("<%= request.getParameter("t1")%>");
	$("#legend").html(decoding("<%= request.getParameter("t2")%>"))
	
	</script>
</body>
</html>
