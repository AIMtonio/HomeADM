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
<script type="text/javascript" src="js/fira/archOperacionesPLDUpload.js"></script>
<title>Adjuntar Archivo PLD</title>
</head>
<body>
	<c:set var="varProceso" value="<%=request.getParameter(\"proceso\")%>" />
	<c:set var="varOperacion" value="<%=request.getParameter(\"operacion\")%>" />
		<div id="contenedorForma" style="top:0px; padding:10px; left:0px; width: 98%; height: 90%; ">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="ArchAdjuntosPLDBean" enctype="multipart/form-data">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Archivos PLD</legend>
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
						<td class="label" nowrap="nowrap">
							<label for="observacion">Observaci&oacute;n:</label>
						</td>
						<td>
							<form:textarea id="observacion" name="observacion" path="observacion" cols="35" rows="4" tabindex="2" onBlur=" ponerMayusculas(this)" />
						</td>
					</tr>
					<tr>
						<td align="right" colspan="5">
							<input type="submit" id="enviar" name="enviar" class="submit" tabindex="8" value="Subir Archivo" />
							<input type="hidden" name="extarchivo" id="extarchivo" readOnly="readonly" />
							<input type="hidden" id="fecha" name="fecha" value="${varFecha}" />
							<input type="hidden" id="archivo" name="archivo" value="${varArchivo}" />
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="1" />
							<input type="hidden" id="tipoProceso" name="tipoProceso" value="${varProceso}" />
							<c:choose>
								<c:when test="${varProceso == '1'}">
									<form:input type="hidden" id="opeInusualID" name="opeInusualID" path="opeInusualID" value="${varOperacion}" />
									<form:input type="hidden" id="opeInterPreoID" name="opeInterPreoID" path="opeInterPreoID" value="" />
								</c:when>
								<c:when test="${varProceso == '2'}">
									<form:input type="hidden" id="opeInusualID" name="opeInusualID" path="opeInusualID" value="" />
									<form:input type="hidden" id="opeInterPreoID" name="opeInterPreoID" path="opeInterPreoID" value="${varOperacion}" />
								</c:when>
							</c:choose>
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
</body>
</html>
