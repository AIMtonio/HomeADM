<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
	<link rel="stylesheet" type="text/css" href="css/mensaje.css" media="all"  >

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

			<td colspan="2">
				${mensaje.descripcion}

			</td>

		</tr>
		<tr>
		<td align="center">
			<input onClick="devolverMensajeArchivo()" type="button" value="CONTINUAR" class="submit" />
		</td>
	</table>
</div >

<form id="formaOculta">
	<input type="hidden" name="nombreControl" id="nombreControl" value="${mensaje.nombreControl}">
	<input type="hidden" name="numeroMensaje" id="numeroMensaje" value="${mensaje.numero}">
</form>

</body>
</html>
<script type="text/javascript">
	opener.focus();

	function devolverMensajeArchivo() {
		var lote = document.forms["formaOculta"].nombreControl.value;
		datos = lote.split('|');
		var consecutivo = datos[0];
		var control = datos[1];
		var archivo = datos[1]+datos[5]
		var tipoArch = datos[3];
		var conSI = "S";

		if(tipoArch == 1){
			var nomArchivo = eval("'nombreCartaLiq" + consecutivo + "'");
			var recurso = eval("'recurso" + consecutivo + "'");
			var extension = eval("'extension" + consecutivo + "'");
			var comentario = eval("'comentario" + consecutivo + "'");
			var modificaArchivo = eval("'modificaArchCarta" + consecutivo + "'");
			var rutafinal = eval("'recursoFinal" + consecutivo + "'");
			var rutaFocus = 'comproPago'  + consecutivo;
		}else if(tipoArch == 2){
			var nomArchivo = eval("'nombreComproPago" + consecutivo + "'");
			var recurso = eval("'recursoPago" + consecutivo + "'");
			var extension = eval("'extensionPago" + consecutivo + "'");
			var comentario = eval("'comentarioPago" + consecutivo + "'");
			var modificaArchivo = eval("'modificaArchPago" + consecutivo + "'");
			var rutafinal = eval("'recursoFinalPago" + consecutivo + "'");
			var rutaFocus = 'eliminar'  + consecutivo;
		}


		opener.document.forms["formaGenerica"].elements[nomArchivo].value=archivo;
		opener.document.forms["formaGenerica"].elements[recurso].value=datos[4];
		opener.document.forms["formaGenerica"].elements[extension].value=datos[5];
		opener.document.forms["formaGenerica"].elements[comentario].value=datos[6];
		opener.document.forms["formaGenerica"].elements[modificaArchivo].value=conSI;
		opener.document.forms["formaGenerica"].elements[rutafinal].value=datos[7];
		opener.document.forms["formaGenerica"].elements[rutaFocus].focus();




		self.close();
	}
	function devolverRutaArchivo() {
		opener.document.forms["formaGenerica"].resultadoArchivoTran.value = document.forms["formaOculta"].nombreControl.value;
		self.close();
	}

</script>