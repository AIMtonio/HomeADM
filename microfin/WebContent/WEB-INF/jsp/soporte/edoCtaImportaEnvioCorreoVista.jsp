<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head> 
	<link rel="stylesheet" type="text/css" href="css/mensaje.css" media="all"  >
	
	<script type="text/javascript" src="js/soporte/edoCtaImportaEnvioCorreo.js"></script>    
	<script type="text/javascript" src="js/general.js"></script>
	
	<title>Importa Datos Estados de Cuenta Generados</title>
</head>
<body>
	<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend class="ui-widget ui-widget-header ui-corner-all">Importa Datos Estados de Cuenta Generados</legend>
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="pslParamBrokerBean" >
			<legend>Este proceso se usa para poblar la información de los Estatos de Cuenta generados en otros servidores.</legend>
			<br>
			<legend>Solo se debe de usar en caso que la generación de los Estados de Cuenta se realice en un servidor distinto al productivo.</legend>
			<legend>El periodo que será procesado es: <label id="lblAnioMes"></label>
			</legend>
			<br>
			<input type="hidden" id="anioMes" name="anioMes" value=""/>
			<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" iniForma="false" value=""/>
			<input type="submit" class="submit" id="btnGuardar" name="btnGuardar" tabindex="4" value="Guardar"/>
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
