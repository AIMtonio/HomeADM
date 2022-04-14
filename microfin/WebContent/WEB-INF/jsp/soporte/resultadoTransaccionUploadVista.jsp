<?xml version="1.0" encoding="UTF-8"?>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<link rel="shortcut icon" href="images/favicon.ico" type="image/x-icon" />
<link rel="stylesheet" type="text/css" href="css/mensaje.css" media="all">
<script type="text/javascript" src="dwr/engine.js"></script>
<script type="text/javascript" src="dwr/util.js"></script>
<script type='text/javascript' src='js/jquery-1.5.1.min.js'></script>
<script type='text/javascript' src='js/jquery.jmpopups-0.5.1.js'></script>
<script type="text/javascript" src="js/jquery.blockUI.js"></script>
<script type='text/javascript' src='js/jquery.validate.js'></script>
<script type="text/javascript" src="js/forma.js"></script>
<script type="text/javascript" src="js/general.js"></script>
<title>Resultado</title>
</head>
<body onbeforeunload="javascript:devolverRutaArchivo()">
	<div id="contenedorMsgArchivo">
		<table align="center" style="width: auto;">
			<tr id="encabezadoMsg">
				<td>
					<c:choose>
						<c:when test="${mensaje.numero == '0'}">
							Mensaje: ${mensaje.numero}
						</c:when>
						<c:otherwise>
							Error: ${mensaje.numero}
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
			<tr id="cuerpoMsg">
				<td colspan="2">${mensaje.descripcion}</td>
			</tr>
			<tr>
				<td align="center">
					<input onClick="javascript:devolverRutaArchivo()" type="button" value="CONTINUAR" class="submit" />
				</td>
		</table>
	</div>
	<form id="formaOculta">
		<input type="hidden" name="nombreControl" id="nombreControl" value="${mensaje.nombreControl}">
		<input type="hidden" name="numeroMensaje" id="numeroMensaje" value="${mensaje.numero}">
		<input type="hidden" name="rutaArchivoFinal" id="rutaArchivoFinal" value="${mensaje.consecutivoString}">
		<input type="hidden" name="rutaArchivoLocal" id="rutaArchivoLocal" value="${mensaje.nombreControl}">
	</form>
</body>
</html>
<script type="text/javascript">
	function devolverRutaArchivo() {
		opener.document.forms["formaGenerica"].rutaArchivoFinal.value = document.forms["formaOculta"].rutaArchivoFinal.value;
		opener.document.forms["formaGenerica"].procesar.focus();
		if($('#numeroMensaje').val() == 0){
			window.opener.exitoAdjunta();
		}
		self.close();
	}
</script>
