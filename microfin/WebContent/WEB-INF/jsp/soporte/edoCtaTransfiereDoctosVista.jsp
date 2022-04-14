<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head> 
		<link rel="stylesheet" type="text/css" href="css/mensaje.css" media="all"  >
		
		<script type="text/javascript" src="js/soporte/edoCtaTransfiereDoctos.js"></script>    
		<script type="text/javascript" src="js/general.js"></script>
		
		<title>Transferencia de Estados de Cuenta</title>
	</head>
	<body>
		<div id="contenedorForma">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Transferencia de Estados de Cuenta</legend>
				<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="edoCtaEnvioCorreoBean" >
					Este proceso permite copiar los Estados de Cuenta del servidor de generación al servidor productivo.
					<br>
					El periodo que será importados es: <label id="lblAnioMes"></label>
					<br><br>

					Para continuar presione el Botón <strong>Procesar.</strong>
					<br><br>
					<input type="hidden" id="anioMes" name="anioMes" value=""/>
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" iniForma="false" value=""/>
					<input type="submit" class="submit" id="btnGuardar" name="btnGuardar" tabindex="1" value="Procesar" style="float: right;"/>
				</form:form>
			</fieldset>
		</div>
		
		<div id="cargando" style="display: none;"></div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"/></div>
		</div>
		<div id="ContenedorAyuda" style="display: none;">
			<div id="elemento"/>
		</div>
		<div id="mensaje" style="display: none;"/></div>		
	</body>
</html>
