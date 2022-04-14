<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<html>
<head>
<title>SAFI</title>
<meta name="viewport" content="initial-scale=1.0, width=device-width" />
<link rel="shortcut icon" href="images/favicon.ico" type="image/x-icon" />
<link rel="stylesheet" type="text/css" href="css/style.css" rel="stylesheet" />
<script type="text/javascript" src="dwr/engine.js"></script>
<script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>
<script type="text/javascript" src="dwr/interface/controlClaveServicio.js"></script>
<script type="text/javascript" src="dwr/interface/companiaServicio.js"></script>
<script type="text/javascript" src="dwr/interface/huellaDigitalServicio.js"></script>
<script type="text/javascript" src="js/soporte/ServerHuella.js"></script>
<script type="text/javascript" src="dwr/util.js"></script>
<script type="text/javascript" src="js/jquery-1.5.1.min.js"></script>
<script type="text/javascript" src="js/jquery.blockUI.js"></script>
<script type="text/javascript" src="js/forma.js"></script>
<script type="text/javascript" src="js/soporte/entrada_look.js"></script>
<style>
.submit {
	display: inline-block;
	-webkit-border-radius: 4px;
	-moz-border-radius: 4px;
	border-radius: 4px;
	vertical-align: middle;
	font-family: tahoma, geneva, sans-serif;
	font-size: 1.0em;
	font-weight: normal;
	border: solid 1px #056672;
	padding: 3px 5px 3px 5px !important;
	color: #fff !important;
	margin: 3px 1px !important;
	background: #05A1DB;
	white-space: nowrap;
	cursor: pointer;
}

.submit:hover {
	text-decoration: none !important;
	background: #00ADEE;
	border: solid 1px #0099bb;
}

.alertInfo, .alertInfoRetro {
	border: 1px solid #f5f5f5;
	background: #f3f5f6;
	display: block;
	position: absolute;
	z-index: 30000;
	min-width: 200px;
}

.cabecera {
	background: #166096;
	color: #fff;
	font-size: 1em;
	padding: 5px;
	text-align: center;
	font-weight: bold;
}

.cabeceraError {
	background: #1d4e77;
	color: #fff;
	font-size: 13px;
	padding: 5px;
	text-align: left;
	border-radius: 10px 10px 0px 0px;
}

.contenido {
	padding: 15px;
	font-size: 0.9em;
	text-align: center;
	color: black;
}

.contenidoError {
	padding: 15px;
	font-size: 1em;
	text-align: left;
}

.footer {
	text-align: center;
	background: #eaeaea;
	padding: 5px;
	border-radius: 0px 0px 10px 10px;
}

.botonAlertInfo {
	background: #1d4e77;
	padding: 5px 10px;
	border-radius: 8px;
	color: #fff;
	box-shadow: 0px 0px 0px #fff;
	border: 1px solid #01080e;
	margin-left: 10px;
}

#btnAlertCerrar {
	float: right;
	font-size: 0.9em;
	font-weight: bold;
	background: #134a73;
	padding: 3px 7px;
	border-radius: 5px;
	box-shadow: 0px 0px 6px #2975af;
	cursor: pointer;
}

#btnAlertCerrarError {
	float: right;
	font-family: monospace;
	font-size: 11px;
	font-weight: bold;
	background: #023056;
	padding: 3px 8px;
	border-radius: 5px;
}
</style>
</head>
<body onload="carga();">
	<div class="login_form" id="contenedorForma">
		<section class="login-wrapper">
		<div class="logo">
			<a target="_blank" rel="noopener">
				<img id="logoCte" src="images/logoClientePantalla.png" alt="" style="" /></a>
			<h3>
			</h3>
			<br />
			<div class="page-links">
				<a href="#" class="active" tabindex="1"> Login</a> <br />
			</div>
		</div>
		<form method="post" id="loginForm" name="loginForm" action="SAFI_SecurityCheck" autocomplete="off">
			<center>
				<input class="form-control" id="loginName" name="safi_username" type="text" placeholder="Clave de Usuario" autocomplete="off" tabindex="1" required autocapitalize="off" autocorrect="off" />
				<input class="form-control" id="contraseniaId" name="safi_password" type="password" placeholder="Password" autocomplete="off" tabindex="2" required />
				<input class="submit" type="submit" name="submit" id="submitBtn" value="Entrar" disabled="disabled" tabindex="3" />
				<br>
				<span id="statusSrvHuella" style="display: none;"></span>
				<br>
				<div id="mensajeBienvenida" class="other-links">
					<span> Por Seguridad de la Aplicaci&oacute;n, recuerda que cuentas con 3 oportunidades para teclear tu Usuario y Password correctamente, en caso contrario ser&aacute; bloqueado. <br>Powered by Efisys, Versi&oacute;n: <s:message code="safilocale.version" /></span> <br /> <br />
					<div id="mensajeLogin" style="display: none; font-size: 8;"></div>
					<br />
					<div id="nombreEmpresa" style="display: none;"></div>
				</div>

			</center>
		</form>
		</section>
	</div>
</body>
</html>