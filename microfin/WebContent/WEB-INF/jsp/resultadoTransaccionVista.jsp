<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	<link rel="stylesheet" type="text/css" href="css/mensaje.css" media="all"  >
</head>
<body>

<div id="contenedorMsg">
	<table>
		<tr id="encabezadoMsg">
			<td>
			<c:choose>
				<c:when test="${mensaje.numero == '0'}">
					<script type="text/javascript">
						$.unblockUI();
					</script>
					Mensaje:
				</c:when>
				<c:when test="${mensaje.numero == '999'}">
					Error: ${mensaje.numero}
				</c:when>
				<c:otherwise>
					Alerta: ${mensaje.numero}
		      </c:otherwise>
		  	</c:choose>
			</td>
			<td id="cerrarMsg">
				<div id="ligaCerrar">X</div >
			</td>
		</tr>
		<tr id="cuerpoMsg">
			<td colspan="2">
				${mensaje.descripcion}
			</td>
		</tr>
	</table>
</div >

<form id="formaOculta">
	<input type="hidden" name="nombreControl" id="nombreControl" value="${mensaje.nombreControl}">
	<input type="hidden" name="numeroMensaje" id="numeroMensaje" value="${mensaje.numero}">
	<input type="hidden" name="consecutivo" id="consecutivo" value="${mensaje.consecutivoString}">
	<input type="hidden" name="campoGenerico" id="campoGenerico" value="${mensaje.campoGenerico}">
</form>

</body>
</html>
<script type="text/javascript">
	$('#ligaCerrar').click(function() {
		var nunMensJQ;
		var controlJQ;

		$('#contenedorForma').unblock();

		if($('#nombreControl').val()!=null && $('#nombreControl').val()!=''){
			controlJQ = eval("'#" + $('#nombreControl').val() + "'");
			$(controlJQ).focus();
			$(controlJQ).select();
		}

		var control = $('#nombreControl').val();
		if(control == 'GridMonitor'){
			consultaGridRiesgos();
		}
	});
	$('#ligaCerrar').mouseover(function() {
		$("#ligaCerrar").removeClass("cerrarMsgOut");
		$("#ligaCerrar").addClass("cerrarMsghover");
	});
	$('#ligaCerrar').mouseout(function() {
		$("#ligaCerrar").removeClass("cerrarMsghover");
		$("#ligaCerrar").addClass("cerrarMsgOut");
	});
</script>