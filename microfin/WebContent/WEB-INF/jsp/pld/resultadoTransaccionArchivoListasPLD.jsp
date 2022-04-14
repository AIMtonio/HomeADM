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
</head>
<body>
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
					<input onClick="javascript:devolverMensajeArchivo()" type="button" value="CONTINUAR" class="submit" />
				</td>
		</table>
	</div>
	<form id="formaOculta">
		<input type="hidden" name="numeroconsecutivo" id="numeroconsecutivo" value="${mensaje.numero}">
	</form>
</body>
</html>
<script type="text/javascript">
function devolverMensajeArchivo() {
	opener.document.forms["formaGenerica"].numError.value = document.forms["formaOculta"].numeroconsecutivo.value;
	window.opener.resultadoPopUp();
	self.close();
}
</script>