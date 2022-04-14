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
<body onload="javascript:devolverFormula()">

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
			<input onClick="javascript:self.close()" type="button" value="CONTINUAR" class="submit" />
		</td>
	</table>
</div >
 
<form id="formaOculta">
	<input type="hidden" name="nombreControl" id="nombreControl" value="${mensaje.nombreControl}">
	<input type="hidden" name="numeroMensaje" id="numeroMensaje" value="${mensaje.numero}">
	<input type="hidden" name="descMensaje" id="descMensaje" value="${mensaje.descripcion}">
	<input type="hidden" name="formula" id="formula" value="${mensaje.recursoOrigen}">
	<input type="hidden" name="desFormula" id="desFormula" value="${mensaje.consecutivoString}">
</form>

</body>
</html>
<script type="text/javascript">
	
	function devolverFormula() {
		var nombreControl = document.forms["formaOculta"].nombreControl.value;
		var numeroMensaje = document.forms["formaOculta"].numeroMensaje.value;
		var descMensaje = document.forms["formaOculta"].descMensaje.value;
		var formula = document.forms["formaOculta"].formula.value;
		var desFormula = document.forms["formaOculta"].desFormula.value;

		var resultadoFormulaBean = {
			"nombreControl":nombreControl,
			"numeroMensaje":numeroMensaje,
			"descMensaje":descMensaje,
			"formula": formula,
			"desFormula":desFormula
		}
		console.log(resultadoFormulaBean);
		window.opener.resultadoFormula(resultadoFormulaBean);
	}

</script> 

