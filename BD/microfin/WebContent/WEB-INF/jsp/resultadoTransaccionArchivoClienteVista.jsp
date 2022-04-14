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
 	<script type="text/javascript"	src="js/tarjetas/aclaraFileUploadVista.js"></script>
	
	
	<title>Resultado</title>
</head>
<body>
<!--  Este jsp se utiliza en varias pantallas entre ellas SERVIFUN, proteccion al Ahorro y credito-->
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
			<input onclick="javascript:devolverMensajeArchivo()" type="button" value="CONTINUAR" class="submit" />
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
	
	function devolverMensajeArchivo() {
		window.opener.consultaArchivosCliente();
		self.close();		
	}
</script>