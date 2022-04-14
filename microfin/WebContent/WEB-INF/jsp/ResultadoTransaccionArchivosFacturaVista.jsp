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
</head>
<body>

<div id="contenedorMsgArchivo">
	<table align="center">
	  <tr id="encabezadoMsg">
			<td>
			<c:choose>
				<c:when test="${mensaje.numero == '0'}">
					Mensaje:
				</c:when>
				<c:otherwise>
					Error: ${mensaje.numero}
		      </c:otherwise>
		  	</c:choose>
			</td>
			<!-- <td id="cerrarMsg">
				<div id="ligaCerrar">X</div >
			</td>	 -->		
		</tr> 
		
		<tr id="cuerpoMsg">
		
			<td colspan="2">
				${mensaje.descripcion}
			</td>
			
		</tr>		
		<tr>
		<td align="center">
			<input onClick="javascript:devolverRutaArchivo()" type="button" value="CONTINUAR" class="submit" />
		</td>		
	</table>
</div >

<form id="formaOculta">
	<input type="hidden" name="nombreControl" id="nombreControl" value="${mensaje.nombreControl}">
	<input type="hidden" name="numeroMensaje" id="numeroMensaje" value="${mensaje.numero}">
	<input type="hidden" name="numeroconsecutivo" id="numeroconsecutivo" value="${mensaje.consecutivoString}">
	<input type="hidden" name="numeroconsecutivoInt" id="numeroconsecutivoInt" value="${mensaje.consecutivoInt}">
	<input type="hidden" name="folioUUIDfac" id="folioUUIDFac" value="${mensaje.campoGenerico}">
</form>

</body>
</html>
<script type="text/javascript">
function devolverRutaArchivo() {
	var tipo  =document.forms["formaOculta"].numeroconsecutivoInt.value
	if(tipo == 'I'){
		opener.document.forms["formaGenerica"].rutaImagenFact.value = document.forms["formaOculta"].numeroconsecutivo.value;
		self.close();
	}
	if(tipo == 'A'){
		opener.document.forms["formaGenerica"].rutaXMLFact.value = document.forms["formaOculta"].numeroconsecutivo.value;
		//folioUUID
		opener.document.forms["formaGenerica"].folioUUID.value = document.forms["formaOculta"].folioUUIDfac.value;
		self.close();
	}
	
}
</script>
