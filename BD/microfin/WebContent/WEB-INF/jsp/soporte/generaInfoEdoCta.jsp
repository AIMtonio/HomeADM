<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head> 
	<link rel="stylesheet" type="text/css" href="css/mensaje.css" media="all"  >
	
	<script type="text/javascript" src="js/soporte/generaInfoEdoCta.js"></script>    
	<script type="text/javascript" src="js/general.js"></script>
	
	<title>Generación de Datos de Estado de Cuenta Semestral</title>
</head>
<body>
	<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend class="ui-widget ui-widget-header ui-corner-all">Generación de Datos de Estado de Cuenta Semestral</legend>
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="pslParamBrokerBean" >
			<legend>Este proceso se usa para poblar la información de los Estados de Cuenta Semestrales</legend>
			<br>
			<legend>Solo se debe de usar después de haber realizado la generación de los Estados de Cuenta del último Mes del Semestre.</legend>
			<legend>El periodo que será procesado es: <label id="lblAnioMes"></label>
			</legend>
			<br>
			<input type="hidden" id="anioMes" name="anioMes" value=""/>
			<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" iniForma="false" value=""/>
			<input type="submit" class="submit" id="btnGuardar" name="btnGuardar" tabindex="4" value="Generar"/>
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
