<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="tipoLista" value="${listaResultado[0]}" />
<c:set var="campoLista" value="${listaResultado[1]}" />
<c:set var="cerraSesion" value="${listaResultado[2]}" />
<link rel="stylesheet" type="text/css" href="css/redmond/jquery-ui-1.8.13.custom.css" />
<link rel="shortcut icon" href="images/favicon.ico" type="image/x-icon" />
<html>
<head>
<title>SAFI</title>
<link rel="stylesheet" type="text/css" href="css/mensaje.css" media="all">
</head>
<body>
	<div id="contenedorMsg">
		<table>
			<tr id="encabezadoMsg">
				<td class="etiqueta">
					<label>Gracias</label>
				</td>
			</tr>
			<tr id="cuerpoMsg">
				<td colspan="2">
					<br> <label for="salir">Su sesi&oacute;n ha sido cerrada correctamente</label>
				</td>
			</tr>
		</table>
		<br>
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<table>
				<tr>
					<td class="label">
						<font size="3" color="#2E64FE"> En este momento ha abandonado la Aplicaci&oacute;n de SAFI.
							<p>
								Recuerde que para tener acceso a la Aplicaci&oacute;n otra vez, debe de proporcionar su usuario y contrase&ntilde;a en el acceso a la zona segura de <br>de la Aplicaci&oacute;n SAFI. <a href="entradaAplicacion.htm">Acceso al Sistema</a>.
							</p>
							<p>
								POR SU SEGURIDAD TENGA EN CUENTA: Si se aleja de su computadora, cierre la Sesi&oacute;n, haga clic en el &iacute;cono Salir en la parte superior <br>de la p&aacute;gina para salir de la zona segura.
							<p>Le recordamos que es responsable del buen uso del Nombre de Usuario y Contrase&ntilde;a que utiliza para los Servicios de la Aplicaci&oacute;n.</p>
						</font>
					</td>
				</tr>
			</table>
		</fieldset>
	</div>
	<form id="formaOculta">
		<input type="hidden" name="nombreControl" id="nombreControl" value="${mensaje.nombreControl}"> <input type="hidden" name="numeroMensaje" id="numeroMensaje" value="${mensaje.numero}"> <input type="hidden" name="consecutivo" id="consecutivo" value="${mensaje.consecutivoString}">
	</form>
</body>
</html>
