<?xml version="1.0" encoding="UTF-8"?>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
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
		<table align="center">
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
		<input type="hidden" name="tipoArchivo" id="tipoArchivo" value="${mensaje.consecutivoString}">
	</form>
</body>
</html>
<script type="text/javascript">
	function devolverRutaArchivo() {
		if(Number(document.forms["formaOculta"].tipoArchivo.value)==1){
			opener.document.forms["formaGenerica"].calCartFira.value = document.forms["formaOculta"].nombreControl.value;
			opener.document.forms["formaGenerica"].rutaFinalCalCartFira.value = document.forms["formaOculta"].nombreControl.value;
		} else {
			opener.document.forms["formaGenerica"].archivoRes.value = document.forms["formaOculta"].nombreControl.value;
			opener.document.forms["formaGenerica"].rutaFinalArchivoRes.value = document.forms["formaOculta"].nombreControl.value;
		}
		opener.document.forms["formaGenerica"].generar.focus();
		window.opener.habilitaGenera(); 
		self.close();
	}
</script>
